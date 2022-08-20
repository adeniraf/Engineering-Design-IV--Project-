#include "network.h"

Network::Network(SharedState* state) {
  this->messageBuffer = new char[256];
  this->messageLength = 0;
  this->state = state;
}

void writeFloat(WiFiClient client, float f) {
    uint32_t rep;
    memcpy(&rep, &f, sizeof(rep));
    client.print(rep, HEX);
}

void Network::sendTelemetry(WiFiClient client) {
    client.print(MSG_TELEMETRY); client.print(" ");
    client.print(telemetry.state, HEX); client.print(" ");
    writeFloat(client, telemetry.angle); client.print(" ");
    writeFloat(client, telemetry.leftMotorVoltage); client.print(" ");
    writeFloat(client, telemetry.rightMotorVoltage); client.print(" ");
    writeFloat(client, telemetry.leftIRSensorValue); client.print(" ");
    writeFloat(client, telemetry.rightIRSensorValue); client.print(" ");
    writeFloat(client, telemetry.ultrasonicSensorValue); client.print(" ");
    writeFloat(client, telemetry.accelerometerX); client.print(" ");
    writeFloat(client, telemetry.accelerometerY); client.print(" ");
    writeFloat(client, telemetry.accelerometerZ); client.print(" ");
    writeFloat(client, telemetry.turn_pid_p); client.print(" ");
    writeFloat(client, telemetry.turn_pid_i); client.print(" ");
    writeFloat(client, telemetry.turn_pid_d); client.print(" ");
    writeFloat(client, telemetry.ultra_pid_p); client.print(" ");
    writeFloat(client, telemetry.ultra_pid_i); client.print(" ");
    writeFloat(client, telemetry.ultra_pid_d); client.print(" ");
    writeFloat(client, telemetry.dummyvariable); client.print(" ");
   
    client.print('\n');
}

void Network::parseMessage() {
    if (this->messageLength < 3) // branch chosen if shenanigans occur
        return;

        
    if (strncmp(this->messageBuffer, REQ_CONNECT, 3) == 0) {
        Serial.println("Client connected");
    } else if (strncmp(this->messageBuffer, REQ_STOP, 3) == 0) {
        Serial.println("Stop Request");
        this->telemetry.state = STOPPED;
    } else if (strncmp(this->messageBuffer, REQ_START, 3) == 0) {
        Serial.println("Start Request");
        this->telemetry.state = RUNNING;
        
    } else if (strncmp(this->messageBuffer, SPEED_TERM, 3) == 0) {
        float Buggy_Speed = convertToFloat(this->messageBuffer + 4);
        //Serial.println(Buggy_Speed);
        this->state->Max_Speed = Buggy_Speed; 
    }
            
      else if (strncmp(this->messageBuffer, IR_P_TERM, 3) == 0) {
        float P_term = convertToFloat(this->messageBuffer + 4);
        this->state->turn_pid.p_term = P_term;
    } else if (strncmp(this->messageBuffer, IR_I_TERM, 3) == 0) {
        float I_term = convertToFloat(this->messageBuffer + 4);
        this->state->turn_pid.i_term = I_term;
    } else if (strncmp(this->messageBuffer, IR_D_TERM, 3) == 0) {
        float D_term = convertToFloat(this->messageBuffer + 4);
        this->state->turn_pid.d_term = D_term;
    }
    
      else if (strncmp(this->messageBuffer, US_P_TERM, 3) == 0) {
        float P_term = convertToFloat(this->messageBuffer + 4);
        this->state->ultrasonic_pid.p_term = P_term;
    } else if (strncmp(this->messageBuffer, US_I_TERM, 3) == 0) {
        float I_term = convertToFloat(this->messageBuffer + 4);
        this->state->ultrasonic_pid.i_term = I_term;
    } else if (strncmp(this->messageBuffer, US_D_TERM, 3) == 0) {
        float D_term = convertToFloat(this->messageBuffer + 4);
        this->state->ultrasonic_pid.d_term = D_term;
    }
    
}

void Network::processRequests(WiFiClient client) {
    if (client.available() > 0) {
        char c = client.read();
        if (c == '\n') {
            parseMessage();
            this->messageLength = 0;
        } else if (this->messageLength < 256) {
            this->messageBuffer[this->messageLength] = c;
            this->messageLength++;
        }
    }
}

float Network::convertToFloat(char* msg){
    char *ptr;
    long int val = strtol(msg, &ptr, 16);
    uint32_t ret = (uint32_t) val;
    float f;
    memcpy(&f, &ret, sizeof(f));
    return f;
}


Network::~Network() {
    delete[] this->messageBuffer;
}
