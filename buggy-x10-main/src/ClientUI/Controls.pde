import processing.net.*;
import processing.core.PApplet;
import controlP5.*;

class Controls {
  PApplet app;
  ControlP5 cp5;
  int Text_Font_Size = 12;
  int Text_Bg_Color = 80;
  
  PImage img = loadImage("reconnectimg.png");
  
  public void draw(float x, float y, float w, float h) {
        pushMatrix();
        
        // set origin and size
        translate(x, y);
        
        clip(0, 0, w, h);
        
        //draw border
        fill(255);
        stroke(0);
        strokeWeight(7);
        rect(0, 0, w-1,h-1);
        noClip();
        popMatrix();       
    }
    
  String floatToHexStringConverter(String value){
    Float j = float(value);
    int i = Float.floatToIntBits(j);
    String k = Integer.toHexString(i).toUpperCase();
    return k;
  }
  Controls (PApplet papp, int x, int y){
    app = papp;
    cp5 = new ControlP5(papp);
    
    cp5.addToggle("ON_OFF")
    .setCaptionLabel("On              Off")
    .setPosition(x-10,y-30)
    .setSize(200,100)
    //.align(0,0,0,1)
    .setFont(createFont("Gill Sans MT Bold",18))
    .setMode(ControlP5.SWITCH)
    .setColorLabel(color(0,0,0)) 
    .setColorBackground(color(224, 49, 49)) // False color
    //.setColorForeground(color(232, 153, 35)) // Hover Color
    .setColorActive(color(45, 235, 98));    // True color
    ;
    cp5.getController("ON_OFF").getCaptionLabel().align(ControlP5.CENTER,ControlP5.CENTER);
    
    
    cp5.addButton("Reconnect")
     .setPosition(x+310,y-65)
     .setImage(img)
     .updateSize();
     ;
 
    cp5.addTextfield("Input_Speed")
     .setCaptionLabel("Max Speed")
     .setColorLabel(color(0,0,0))
     .setPosition(x+220,y+10)
     .setSize(100,30)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("Input_Speed").getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0).setColor(0);
    
    cp5.addTextfield("P_term")
     .setCaptionLabel("P_term")
     .setColorLabel(color(84, 80, 80))
     .setPosition(x+35,y+90)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("P_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
     
     cp5.addTextfield("I_term")
     .setCaptionLabel("I_term")
     .setColorLabel(color(0,0,0))
     .setPosition(x+135,y+90)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("I_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
     
     cp5.addTextfield("D_term")
     .setCaptionLabel("D_term")
     .setColorLabel(color(0,0,0))
     .setPosition(x+235,y+90)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("D_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
     
     cp5.addTextfield("US_P_term")
     .setCaptionLabel("US_P_term")
     .setColorLabel(color(0,0,0))
     .setPosition(x+35,y+160)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("US_P_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
     
     cp5.addTextfield("US_I_term")
     .setCaptionLabel("US_I_term")
     .setColorLabel(color(0,0,0))
     .setPosition(x+135,y+160)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("US_I_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
     
     cp5.addTextfield("US_D_term")
     .setCaptionLabel("US_D_term")
     .setColorLabel(color(0,0,0))
     .setPosition(x+235,y+160)
     .setSize(50,40)
     .setFont(createFont("Gill Sans MT Bold",12))
     .setColor(color(255))
     .setColorBackground(color(Text_Bg_Color))
     ;
     cp5.getController("US_D_term").getCaptionLabel().align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setColor(0);
  }
  
}
