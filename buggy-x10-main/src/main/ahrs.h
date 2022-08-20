#ifndef AHRS_h
#define AHRS_h
#include <Arduino_LSM6DS3.h>
#include <MadgwickAHRS.h>
#include "matrix.h"

struct Heading {
    union { float roll, xRot; };
    union { float pitch, yRot; };
    union { float yaw, zRot; };
};

class AHRS {
private:
    Madgwick filter;
    float3 gyroOffset;
    float3 gyro;
    float3 accel;

    Heading heading;

public:
    AHRS(void);

    bool begin();
    void update();

    Heading getHeading() {
        return heading;
    }

    float3 getGyro() {
        return gyro;
    }

    float3 getAccel() {
        return accel;
    }
};

#endif
