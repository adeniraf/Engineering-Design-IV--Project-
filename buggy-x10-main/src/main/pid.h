#ifndef PID_h
#define PID_h

class PID {
private:
    float value;
    float last_error;
    float integral;
    float derivative;
    float i_max;
    float i_min;

public:
    float p_term;
    float i_term;
    float d_term;
    float filter_beta;

    PID(void);
    void update(float error, float& p, float& i, float& d);

    void setWindupReset(float _min, float _max) {
        this->i_min = _min;
        this->i_max = _max;
    }
    
    float getValue() {
        return value;
    }
};

#endif
