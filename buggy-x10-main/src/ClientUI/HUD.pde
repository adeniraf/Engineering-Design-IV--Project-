import controlP5.*;

class HUD { 
  
    public void draw(BuggyTelem telem, float x, float y, float w, float h) {
        pushMatrix();
        
        // set origin and size
        translate(x, y);
        //clip(0, 0, w, h);
        
        // draw border
        fill(255);
        stroke(0);
        strokeWeight(4);
        //rect(0, 0, w-1,h-1);
        circle(w/2,h/2,w);
        
        // draw buggy
        drawHeadingLines(telem.angle, w, h); 
        drawBuggy(telem, w, h);
        //drawAcceleration(telem.accelerometerX, telem.accelerometerY, w, h);
        
        
        // reset
        noClip();
        popMatrix();
    }
    
    public void drawHeadingLines(float angle, float w, float h) {
        float rads = radians(angle);
        
        pushMatrix();
        translate(w / 2.0f, h / 2.0f);
        rotate(rads);
        translate(-w / 2.0f, -h / 2.0f);
        
        strokeWeight(2);
        stroke(255, 0, 0);
       // line((w - len) / 2.0f, h / 2.0f, len, h / 2.0f);
        line(0, h / 2, w, h / 2);
        stroke(0, 255, 0);
        line(w / 2, 0, w / 2, h);
        
        popMatrix();
    }
     
    private void drawBuggy(BuggyTelem telem, float w, float h) {
        final float buggyWidth = 70;
        final float buggyHeight = 90;
        final float wheelWidth = 10;
        final float wheelHeight = 40;
        final float irSensorWidth = 15;
        final float irSensorHeight = 20;
        final float margin = 5;
        
        // body
        final float buggyX = (w - buggyWidth) / 2.0f;
        final float buggyY = (h - buggyHeight) / 2.0f;
        noFill();
        stroke(0);
        rect(buggyX, buggyY, buggyWidth, buggyHeight);
        
        // wheels
        rect(buggyX - wheelWidth - margin, buggyY, wheelWidth, wheelHeight);
        rect(buggyX + buggyWidth + wheelWidth - margin, buggyY, wheelWidth, wheelHeight);
        
        // ir sensors
        rect((w - margin) / 2 - irSensorWidth, buggyY - margin - irSensorHeight, irSensorWidth, irSensorHeight);
        rect((w + margin) / 2, buggyY - margin - irSensorHeight, irSensorWidth, irSensorHeight);
        
        /* text */
        fill(0,0,0);
        // motors
        // String sf3 = nf(f, 0, 2);
        String rmv = nf(telem.rightMotorVoltage,0,2);
        String lmv = nf(telem.leftMotorVoltage,0,2);
        int left_text_offset = 47;
        int right_text_offset = 26;
        textAlign(LEFT, TOP);
        text(lmv + " V", buggyX - wheelWidth - 2 * margin - left_text_offset, buggyY);
        textAlign(RIGHT, TOP);
        text(rmv + " V", buggyX + buggyWidth + wheelWidth + 2 *  + right_text_offset, buggyY);
        
        
        // ir sensors
        textAlign(RIGHT, TOP);
        int leftSensor = floor(telem.leftIRSensorValue);
        int rightSensor = floor(telem.rightIRSensorValue);
        text(leftSensor, w / 2 - 1.5 * margin - irSensorWidth, buggyY - margin - irSensorHeight);
        textAlign(LEFT, TOP);
        text(rightSensor, w / 2 + irSensorWidth + 1.5 * margin, buggyY - margin - irSensorHeight);
    }
    
    private void drawAcceleration(float accelX, float accelY, float w, float h) {
        final float scale = -100;
        stroke(0, 0, 255);
        line(w / 2, h / 2, w / 2 + accelX * scale, h / 2 + accelY * scale);
    }       
}
