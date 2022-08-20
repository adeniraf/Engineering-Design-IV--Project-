

class Console {

  String[] txts = {"","","","","","","",""};
  int counter = 0;
  PFont font = createFont("Gill Sans MT Bold",15);
  PImage img = loadImage ("consoleps.png");
  public void draw(float x, float y, float w, float h) {
    pushMatrix();
    translate(x,y);
    clip(0, 0, w, h);
    fill(255);
    stroke(0);
    strokeWeight(7);
    rect(0, 0, w-1,h-1,15);
    noClip();
    popMatrix();
    fill(0);
    textFont(font);
    
    text(txts[0], x+10 , y+20);
    text(txts[1], x+10 , y+40);
    text(txts[2], x+10 , y+60);
    text(txts[3], x+10 , y+80);
    text(txts[4], x+10 , y+100);
    text(txts[5], x+10 , y+120);
    text(txts[6], x+10 , y+140);
    text(txts[7], x+10 , y+160);
    
    tint(255, 60);
    image(img,x+295,y+70);
    noTint();
    
  }
  
  void Print_Text(String text) {
    if (counter == 0 ){
       txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 1){
       txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 2){
       txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 3){
       txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 4){
       txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 5){
      txts[counter] = text;
       counter++;
       return;
    }
    if (counter == 6){
      txts[counter] = text;
       counter++;
       return;
    }
    if (counter > 6){
      counter = 0;
      for (int i = 1; i < 7; i++){
        txts[i] = "";
      }
      Print_Text(text);
    }
    return;   
  }
  
}
