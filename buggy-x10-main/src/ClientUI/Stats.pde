
class Stats {
  
  String str_state = "OFF";
  String str_speed = "240";
  String str_object_check = "No";
  final float us_sensor_threshold = 950;
  // Hard Coded Default PID Coefficient Numbers To appear on Stat Board
  String str_p_coeff = "0.28";
  String str_i_coeff = "0.0035";
  String str_d_coeff = "0.39";
  
  
  String  str_US_p_coeff = "0.05";
  String  str_US_i_coeff = "0.0001";
  String  str_US_d_coeff = "0.05";
  
  PFont font = createFont("Gill Sans MT Bold",14);
  float x;
  float y;
  float w;
  float h;
  
  public Stats(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  

  public void draw(BuggyTelem telem,float x, float y, float w, float h) {
        pushMatrix();
        
        // set origin and size
        translate(x, y);
        clip(0, 0, w, h);
        
        //draw border
        fill(255);
        stroke(0);
        strokeWeight(7);
        rect(0, 0, w-1,h-1,12);       
        //noClip();
        popMatrix();   
        fill(0);
        textFont(font);
        textSize(16);
        text("Buggy State: " + str_state , x+10 , y+30);
        text("Buggy Speed: " + str_speed , x+10 , y+60);        
        text("IR P Coefficient: " + str_p_coeff , x+10 , y+90); 
        text("IR I  Coefficient: " + str_i_coeff , x+10 , y+120); 
        text("IR D Coefficient: " + str_d_coeff , x+10 , y+150);
        
        pushMatrix();
        
        translate(x+205, y);
        clip(0, 0, w, h);
        
        fill(255);
        stroke(0);
        strokeWeight(7);
        rect(0, 0, w-1,h-1,12);       
        //noClip();
        popMatrix();
        fill(0);
        textFont(font);
        textSize(16);
        text("Object infront? : " ,x+215,y+30);
        text("Distance Value: " + telem.utlrasonicSensorValue,x+215,y+60);
        text("US P Coefficient: " +  str_US_p_coeff, x+215 , y+90);
        text("US I Coefficient: " +  str_US_i_coeff, x+215 , y+120);
        text("US D Coefficient: " +  str_US_d_coeff, x+215 , y+150);
        
        
        check_object_distance(telem.utlrasonicSensorValue);
        text(str_object_check,x+350,y+30);
        
    }
    
  void check_object_distance(float us_sensor_value){
      if (us_sensor_value < us_sensor_threshold){
          str_object_check = "Yes";
          fill(27, 204, 71);
          return;
      }
      str_object_check = "No";
      fill(196, 63, 63);
  }

  void set_state(String str){
     str_state = str;
  }
  
  void set_speed(String str){
     str_speed = str;
  }
  
  void set_P_term(String str) {
      str_p_coeff = str;
    }
    
  void set_I_term(String str) {
      str_i_coeff = str;
    }
    
  void set_D_term(String str) {
      str_d_coeff = str;
    }
   
   void set_US_P_term(String str) {
      str_US_p_coeff = str;
    }
    
  void set_US_I_term(String str) {
      str_US_i_coeff = str;
    }
    
  void set_US_D_term(String str) {
      str_US_d_coeff = str;
    }    
    
}
