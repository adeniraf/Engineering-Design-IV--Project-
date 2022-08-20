#include "ahrs.h"

AHRS::AHRS() {
    this->gyroOffset = float3(0, 0, 0);
    this->gyro = float3(0, 0, 0);
    this->accel = float3(0, 0, 0);
}

bool AHRS::begin() {
    if (!IMU.begin()) { return false; }
    filter.begin(IMU.gyroscopeSampleRate());

    float avgX, avgY, avgZ;

    const int sampleNumber = 100;

    for (int i = 0; i < sampleNumber; i++) {
        while (!IMU.accelerationAvailable());
        float x, y, z;
        IMU.readGyroscope(x, y, z);
        avgX += x;
        avgY += y;
        avgZ += z;
    }

    avgX /= sampleNumber;
    avgY /= sampleNumber;
    avgZ /= sampleNumber;

    this->gyroOffset.x = avgX;
    this->gyroOffset.y = avgY;
    this->gyroOffset.z = avgZ;
}

void AHRS::update() {
    if (IMU.accelerationAvailable() && IMU.gyroscopeAvailable()) {
        float3 rawGyro(0, 0, 0);

        // read values
        IMU.readAcceleration(this->accel.x, this->accel.y, this->accel.z);
        IMU.readGyroscope(this->gyro.x, this->gyro.y, this->gyro.z);

        gyro -= this->gyroOffset;
        gyro *= 2;

        // filter constant; the weight that the new value has on the existing one
        // higher means noisier, but more responsive
        const float beta = 0.1f;

        //this->gyro = this->gyro - (beta * (gyro - rawGyro));

        // combine gyro and accelerometer readings
        this->filter.updateIMU(this->gyro.x, this->gyro.y, this->gyro.z, this->accel.x, this->accel.y, this->accel.z);
        
        this->heading.pitch = filter.getPitch();
        this->heading.roll = filter.getRoll();
        this->heading.yaw = filter.getYaw();
    }
}
