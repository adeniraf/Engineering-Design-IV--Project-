#include "pid.h"
#include <limits>
#include <Arduino.h>

PID::PID() {
    this->p_term = 1;
    this->i_term = 1;
    this->d_term = 1;
    this->filter_beta = 1;
    this->last_error = 0;
    this->integral = 0;
    this->derivative = 0;
    this->value = 0;
    this->i_max = std::numeric_limits<float>::max();
    this->i_min = -std::numeric_limits<float>::max();
}

void PID::update(float error, float& p, float& i, float& d) {
    float dx = error - this->last_error;
    this->derivative = this->derivative - (this->filter_beta * (this->derivative - dx));
    this->integral = min(max(this->integral + error * this->i_term, this->i_min), this->i_max);
    this->value = error * this->p_term + this->integral + this->derivative * this->d_term;
    this->last_error = error;

    p = error * this->p_term;
    i = this->integral;
    d = this->derivative * this->d_term;

//    Serial.print(error * this->p_term); Serial.print(", ");
//    Serial.print(this->integral); Serial.print(", ");
//    Serial.print(this->derivative * this->d_term); Serial.print(", ");
//    Serial.println(this->value);
}
