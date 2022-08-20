
class Accel {
     public void draw(BuggyTelem telem, float x, float y, float w, float h) {
         float len = w * w / (8 * h) + h / 2;
         float cx = w / 2;
         float cy = len;
         strokeWeight(4.5);
         
         fill(255);
         rect(x, y, w, h,8);
         
         // x axis
         float dx = cx + clamp(telem.accelerometerX * 5, -1, 1) * (w - cx);
         float dy = cy + clamp(telem.accelerometerX * 5, -1, 1) * (h - cy);
         stroke(255, 0, 0);
        
         fill(255, 0, 0);
         line(x + cx, y + cy, x + dx, y + dy);
         textAlign(RIGHT, BOTTOM);
         text("X Axis", x + w-2, y + h);
         
         // z axis
         dx = cx + clamp(telem.accelerometerZ * 0.5, -1, 1) * (w / 2 - cx);
         dy = cy + clamp(telem.accelerometerZ * 0.5, -1, 1) * (0 - cy);
         stroke(0, 0, 255);
         fill(0, 0, 255);
         line(x + cx, y + cy, x + dx, y + dy);
         textAlign(CENTER, TOP);
         text("Z Axis", x + w / 2, y);
         
         // y axis
         dx = cx + clamp(telem.accelerometerY * 5, -1, 1) * (0 - cx);
         dy = cy + clamp(telem.accelerometerY * 5, -1, 1) * (h - cy);
         stroke(0, 255, 0);
         fill(0, 255, 0);
         line(x + cx, y + cy, x + dx, y + dy);
         textAlign(LEFT, BOTTOM);
         text(" Y Axis", x, y + h);
     }
}

 private static float clamp(float x, float min, float max) {
      return max(min(x, max), min);
 }
