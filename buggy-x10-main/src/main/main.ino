he #include <WiFiNINA.h>
#include "secrets.h"
#include "ultrasonic.h"
#include "ahrs.h"
#include "pid.h"
#include "wifi.h"
#include "network.h"
#include "buggy_state.h"

/* --- Sensor Constants ---  */
const int IR_LEFT = 1;
const int IR_RIGHT = 7;

int IR_LEFT_THRESHOLD = 480;
int IR_RIGHT_THRESHOLD = 480;

const int US_TRIG = 2;
const int US_ECHO = 3;

/* --- Motor Constants ---  */
const int MOTOR_L_ENABLE = 12;
const int MOTOR_L1 = 11;
const int MOTOR_L2 = 10;
const int MOTOR_R_ENABLE = 9;
const int MOTOR_R1 = 8;
const int MOTOR_R2 = 7;

/* --- Sensors ---  */
Ultrasonic ultrasonic;

const unsigned int TARGET_ULTRASONIC_DISTANCE = 900;

SharedState state;

/* --- Heading/Navigation ---  */

AHRS ahrs;

/* --- Network --- */
WiFiServer server(3574); // Port
Network network(&state);
WiFiClient client;

void setup() {
    Serial.begin(9600);    
    pinMode(MOTOR_L1, OUTPUT);
    pinMode(MOTOR_L2, OUTPUT);
    pinMode(MOTOR_R1, OUTPUT);
    pinMode(MOTOR_R2, OUTPUT);
    pinMode(US_TRIG, OUTPUT);

    // blink to indicate reset
    pinMode(LED_BUILTIN, OUTPUT);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
    delay(500);

    /*
     * If you want to use the Arduino as an access point instead of connecting
     * to an existing network, swap the following two lines.
     */
    //BuggyWifi::connectToExisting(SSID, PASSWORD);
    BuggyWifi::openAccessPoint("arduino", "barbarbar");
    
    server.begin();
    
    if (!ahrs.begin()) {
        Serial.println("Failed to initialize AHRS. Halting...");
        while (true);
    }
  
    state.turn_pid.p_term = 0.28f;
    state.turn_pid.i_term = 0.0035f;
    state.turn_pid.d_term = 0.39f;
    state.turn_pid.setWindupReset(-511, 511);
    state.turn_pid.filter_beta = 0.2f;

    state.ultrasonic_pid.p_term = 0.05;
    state.ultrasonic_pid.i_term = 0.001;
    state.ultrasonic_pid.d_term = 0.05;
    state.ultrasonic_pid.setWindupReset(-state.Max_Speed, state.Max_Speed); 
    state.ultrasonic_pid.filter_beta = 0.3f;
  
    network.telemetry.state = STOPPED;
  
    // D3 conveniently is also interrupt pin 3
    ultrasonic.begin(US_TRIG, US_ECHO);

    ultrasonic.trigger();
    while (!ultrasonic.isDistanceReady()) {}
}

void drive_left(int power) {
    analogWrite(MOTOR_L_ENABLE, abs(power));
    if (power > 0) {
        digitalWrite(MOTOR_L2, HIGH);
        digitalWrite(MOTOR_L1, 0);
    } else {
        digitalWrite(MOTOR_L1, HIGH);
        digitalWrite(MOTOR_L2, 0);
    }
}

void drive_right(int power) {
    analogWrite(MOTOR_R_ENABLE, abs(power));
    if (power > 0) {
        digitalWrite(MOTOR_R2, HIGH);
        digitalWrite(MOTOR_R1, 0);
    } else {
        digitalWrite(MOTOR_R1, HIGH);
        digitalWrite(MOTOR_R2, 0);
    }
}

void loop() {
    ahrs.update();
    ultrasonic.trigger();
    
    network.telemetry.angle = ahrs.getHeading().yaw;
    network.telemetry.accelerometerX = ahrs.getAccel().x;
    network.telemetry.accelerometerY = ahrs.getAccel().y;
    network.telemetry.accelerometerZ = ahrs.getAccel().z;
 
    if (server.available()) {
        // This only allows one client to connect at once
        // May want to change this in the future
        client = server.available();
    }
    
    if (client.connected()) {
        Serial.println(network.telemetry.angle);
        network.processRequests(client);
        network.sendTelemetry(client);
    }
   
    const float ir_left = 1024 - analogRead(IR_LEFT);
    const float ir_right = 1024 - analogRead(IR_RIGHT);
  
    network.telemetry.leftIRSensorValue = ir_left;
    network.telemetry.rightIRSensorValue = ir_right;
    network.telemetry.ultrasonicSensorValue = ultrasonic.getDistance();

    //Serial.println(ultrasonic.getDistance());
  
    float left = 0, right = 0;
    if (network.telemetry.state == RUNNING) {
        const float turn_error = ir_left - ir_right;
        float p, i, d;
        state.turn_pid.update(turn_error, network.telemetry.turn_pid_p, network.telemetry.turn_pid_i, network.telemetry.turn_pid_d);
        //network.telemetry.pid_p, network.telemetry.pid_i, network.telemetry.pid_d
        const int ultrasonic_error = ultrasonic.getDistance() - TARGET_ULTRASONIC_DISTANCE;
        state.ultrasonic_pid.update(ultrasonic_error,network.telemetry.ultra_pid_p, network.telemetry.ultra_pid_i, network.telemetry.ultra_pid_d);
        const float speed = max(min(state.ultrasonic_pid.getValue(), state.Max_Speed), -state.Max_Speed);
        
        float steering = max(min(state.turn_pid.getValue(), 511), -511);
        if (speed > 0) {
            if (steering > 0) {
                // left > right
                //              (+)             (+)(+)
                left = max(min(steering * 0.5f + speed, 255), -255);
                right = left - steering;
            } else {
                // right > left
                //              (-)(-)           (+)(+)
                right = max(min(-steering * 0.5f + speed, 255), -255);
                left = right + steering;
            }
        } else {
            if (steering > 0) {
                // left > right
                //               (-)(+)          (+)(-)  
                right = max(min(-steering * 0.5f + speed, 255), -255);
                left = right + steering;
            } else {
                // right > left
                //              (-)             (+)(-)
                left = max(min(steering * 0.5f + speed, 255), -255);
                right = left - steering;
            }
        }
    }
    drive_left(left);
    drive_right(right);
    network.telemetry.leftMotorVoltage = left / 255 * 5;
    network.telemetry.rightMotorVoltage = right / 255 * 5;
}
