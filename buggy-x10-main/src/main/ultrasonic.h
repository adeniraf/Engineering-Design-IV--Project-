#ifndef Ultrasonic_h
#define Ultrasonic_h
#include "Arduino.h"

enum UltrasonicState {
    READY, AWAITING_RESPONSE, MEASURING_TOF
};

class Ultrasonic {
private:
    // Need a singleton because ISRs must be attached to static methods
    static Ultrasonic * instance;

    int trigger_pin;

    unsigned long last_ultrasonic_trig;
    unsigned long ultrasonic_response_start_time;
    unsigned long sonic_distance;
    
    volatile bool distance_ready;
    volatile UltrasonicState state = AWAITING_RESPONSE;
    static void ultrasonicISR();

public:
    void begin(int trigger_pin, int echo_pin);
    void trigger();

    unsigned long getDistance() {
        return sonic_distance;
    }

    bool isDistanceReady() {
        return distance_ready;
    }
};

#endif
