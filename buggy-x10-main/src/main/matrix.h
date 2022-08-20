#ifndef Matrix_h
#define Matrix_h

struct float3 {
    union {
        float components[3];
        struct {
            float x, y, z;      
        };
    };

    float3 operator+(const float3& v) {
        float3 result;
        result.x = v.x + x;
        result.y = v.y + y;
        result.z = v.z + z;
        return result;
    }

    float3 operator-(const float3& v) {
        float3 result;
        result.x = x - v.x;
        result.y = y - v.y;
        result.z = z - v.z;
        return result;
    }

    float3& operator+=(const float3& v) {
        this->x += v.x;
        this->y += v.y;
        this->z += v.z;
        return *this;
    }

    float3& operator*=(const float s) {
        this->x *= s;
        this->y *= s;
        this->z *= s;
    }

    float3& operator-=(const float3& v) {
        this->x -= v.x;
        this->y -= v.y;
        this->z -= v.z;
        return *this;
    }

    float3() : x(0), y(0), z(0) {}
    float3(float x, float y, float z) : x(x), y(y), z(z) {}
};

inline float3 operator*(const float3& lhs, float rhs) {
    float3 result;
    result.x = lhs.x * rhs;
    result.y = lhs.y * rhs;
    result.z = lhs.z * rhs;
    return result;
}

inline float3 operator*(float lhs, const float3& rhs) {
    float3 result;
    result.x = lhs * rhs.x;
    result.y = lhs * rhs.y;
    result.z = lhs * rhs.z;
    return result;
}

struct float3x3 {
    float components[3][3];

    float3 operator*(const float3& v) {
        float3 result;
        result.x = v.x * components[0][0] + v.y * components[0][1] + v.z * components[0][2];
        result.y = v.x * components[1][0] + v.y * components[1][1] + v.z * components[1][2];
        result.z = v.x * components[2][0] + v.y * components[2][1] + v.z * components[2][2];
        return result;
    }
};

extern void headingMatrix(float3x3& mat, float yaw, float pitch, float roll);

#endif
