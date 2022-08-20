#ifndef BuggyState_h
#define BuggyState_h
#include "pid.h"

struct SharedState {
    PID turn_pid;
    PID ultrasonic_pid;
    float Max_Speed = 240;
};

#endif
