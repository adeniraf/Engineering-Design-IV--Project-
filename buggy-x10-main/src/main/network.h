#ifndef Network_h
#define Network_h
#include <WiFiNINA.h>
#include "buggy_state.h"

const char* const MSG_TELEMETRY = "TEL";

const char* const REQ_CONNECT = "HEY";
const char* const REQ_STOP =  "STO";
const char* const REQ_START = "STA";

const char* const IR_P_TERM = "TPP";
const char* const IR_I_TERM = "TPI";
const char* const IR_D_TERM = "TPD";

const char* const US_P_TERM = "USP";
const char* const US_I_TERM = "USI";
const char* const US_D_TERM = "USD";

const char* const SPEED_TERM= "SPE";


const int STOPPED = 0;
const int RUNNING = 1;

struct BuggyTelem {
    int state; 
    int dummyvariable = 0;
    float leftMotorVoltage;
    float rightMotorVoltage;
    float leftIRSensorValue;
    float rightIRSensorValue;
    float ultrasonicSensorValue;
    float accelerometerX;
    float accelerometerY;
    float accelerometerZ;
    float turn_pid_p;
    float turn_pid_i;
    float turn_pid_d;
    float ultra_pid_p;
    float ultra_pid_i;
    float ultra_pid_d;
    float angle;
};

class Network {
private:
    // don't trust WiFiNINA's message buffer, no idea how large it is or when it gets cleared
    char* messageBuffer;
    int messageLength;
    void parseMessage();
    SharedState* state;
public:
    BuggyTelem telemetry;
    Network(SharedState* state);
    ~Network();
    
    void sendTelemetry(WiFiClient client);
    void processRequests(WiFiClient client);
    float convertToFloat(char* msg);
};

#endif
