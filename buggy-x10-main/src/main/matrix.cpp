#include "matrix.h"
#include <math.h>

void headingMatrix(float3x3& mat, float yaw, float pitch, float roll) {
    // first column
    mat.components[0][0] = cos(yaw) * cos(pitch); 
    mat.components[1][0] = sin(yaw) * cos(pitch);
    mat.components[2][0] = -sin(pitch);

    // second column
    mat.components[1][0] = cos(yaw) * sin(pitch) * sin(roll) - sin(yaw) * cos(roll);
    mat.components[1][1] = sin(yaw) * sin(pitch) * sin(roll) + sin(yaw) * cos(roll);
    mat.components[1][2] = cos(pitch) * sin(roll); 

    // third column
    mat.components[2][0] = cos(yaw) * sin(pitch) * cos(roll) + sin(yaw) * sin(roll);
    mat.components[2][1] = sin(yaw) * sin(pitch) * cos(roll) - cos(yaw) * sin(roll);
    mat.components[2][2] = cos(pitch) * cos(roll);
}
