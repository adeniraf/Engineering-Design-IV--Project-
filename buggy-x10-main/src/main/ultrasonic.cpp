#include "ultrasonic.h"

Ultrasonic * Ultrasonic::instance;

void Ultrasonic::begin(int trigger_pin, int echo_pin) {
    this->trigger_pin = trigger_pin;
    this->distance_ready = false;
    this->state = READY;
    
    instance = this;
    pinMode(trigger_pin, OUTPUT);
    attachInterrupt(digitalPinToInterrupt(echo_pin), Ultrasonic::ultrasonicISR, CHANGE);
}

void Ultrasonic::trigger() {
    unsigned long _time = millis();

    // 60 ms recommended by manufacturer
    if (!this->state == READY && _time < this->last_ultrasonic_trig + 100) {
        return;
    }

    this->state = AWAITING_RESPONSE;
    
    digitalWrite(this->trigger_pin, HIGH);

    // delay 3 cycles (specified by manufacturer)
    delayMicroseconds(10);

    digitalWrite(this->trigger_pin, LOW);

    this->last_ultrasonic_trig = _time;
}

void Ultrasonic::ultrasonicISR() {
    if (instance->state == AWAITING_RESPONSE) {
        // start measuring ultrasonic response duration
        
        // `micros()` has a resolution of 4 microseconds on the Nano
        instance->ultrasonic_response_start_time = micros();

        // go to next state; wait for response to end
        instance->state = MEASURING_TOF;
    } else if (instance->state == MEASURING_TOF) {
        // finish measuring ultrasonic response duration

        // distance is proportional to response time
        unsigned long final_time = micros();
        instance->sonic_distance = final_time - instance->ultrasonic_response_start_time;
        instance->distance_ready = true;
        instance->state = READY;
    }
}
