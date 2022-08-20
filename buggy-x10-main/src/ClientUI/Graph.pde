import java.util.*;

static final int NUM_VALUES = 500;
static final int MIN_HORIZONTAL_SCALE = 100; 
static final int MIN_VERTICAL_SCALE = 100;

class Plot {
    private final List<PVector> values;
    
    final String name;
    final color lineColor;
    
    Plot(String name, color lineColor) {
        this.values = new LinkedList();
        textSize(13); // Changes text size of everything for some reason 
        this.name = name;
        this.lineColor = lineColor;
    }
    
    public void setCurrentValue(float x, float y) {
        if (this.values.size() > NUM_VALUES) {

            this.values.remove(0);
        }
        this.values.add(new PVector(x, y));
    }
    
    public float getXMax() {
        if (values.size() == 0)
            return 0;
            
        float maximum = values.get(0).x;
        for (PVector v : values) {
            maximum = max(maximum, v.x);
        }
        
        return maximum;
    }
    
    public float getYMax() {
        if (values.size() == 0)
            return 0;
            
        float maximum = values.get(0).y;
        for (PVector v : values) {
            maximum = max(maximum, v.y);
        }
        
        return maximum;
    }
    
    public float getXMin() {
        if (values.size() == 0)
            return 0;
            
        float minimum = values.get(0).x;
        for (PVector v : values) {
            minimum = min(minimum, v.x);
        }
        
        return minimum;
    }
    
    public float getYMin() {
        if (values.size() == 0)
            return 0;
            
        float minimum = values.get(0).y;
        for (PVector v : values) {
            minimum = min(minimum, v.y);
        }
        
        return minimum;
    }
    
    public List<PVector> getValues() {
        return values;
    }
}

class Graph {
    
    private final Plot[] plots;
    
    public Graph(Plot...plots) {
        this.plots = plots;
    }
   
    public void draw(float x, float y, float w, float h) {
        
        pushMatrix();
        translate(x, y);
        clip(0, 0, w, h);
        
        final float marginTop = 30;
        final float marginLeft = 60;
        final float marginBottom = 20;
        final float marginRight = 30;
        
        final float graphWidth = w - marginLeft - marginRight;
        final float graphHeight = h - marginTop - marginBottom;
        
        noClip();
        fill(255);
        strokeWeight(4);
        stroke(0);
        rect(marginLeft, marginTop, graphWidth, graphHeight);
        
        float xMin = 0, yMin = 0, xMax = 0, yMax = 0;
        if (plots.length > 0) {
            xMin = plots[0].getXMin();
            xMax = plots[0].getXMax();
            yMin = plots[0].getYMin();
            yMax = plots[0].getYMax();
        }
        for (Plot p : plots) {
            xMin = min(xMin, p.getXMin());
            xMax = max(xMax, p.getXMax());
            yMin = min(yMin, p.getYMin());
            yMax = max(yMax, p.getYMax());
        }
        
        yMax += 10;
        yMin -= 10;
        
        xMax = max(xMax, MIN_HORIZONTAL_SCALE);
        //float ySize = max(yMax - yMin, MIN_VERTICAL_SCALE);
        //float yDiff = ySize - (yMax - yMin);
        //yMax += yDiff * 0.5f;
        //yMin -= yDiff * 0.5f;
        
        final int numXIntervals = 6;
        final int numYIntervals = 6;
        
        textAlign(CENTER, TOP);
        fill(0);
        stroke(0);
        for (int i = 0; i <= numXIntervals; i++) {
            float f = ((float) i) / numXIntervals;
            float ix = f * graphWidth + marginLeft;
            float iy = h - 20;
            line(ix, iy, ix, iy + 5);
            String str = String.format("%.2f%n", (xMax - xMin) * f + xMin);
            text(str, ix, iy + 7);
        }
        
        textAlign(RIGHT, CENTER);
        for (int i = 0; i <= numYIntervals; i++) {
            float f = ((float) i) / numYIntervals;
            float ix = marginLeft;
            float iy = graphHeight * (1 - f) + marginTop;
            line(ix - 5, iy, ix, iy);
            String str = String.format("%.2f%n", (yMax - yMin) * f + yMin);
            text(str, ix - 8, iy);
        }
        
        final float xRange = xMax - xMin;
        final float yRange = yMax - yMin;
        
        if (yMin <= 0 && yMax >= 0) {
            float zeroY = marginTop + graphHeight + yMin / yRange * graphHeight;
            stroke(0);
            line(marginLeft, zeroY, marginLeft + graphWidth, zeroY);
        }
        
        textAlign(LEFT, CENTER);
        float tx = marginLeft;
        for (Plot p : plots) {
            fill(p.lineColor);
            text(p.name, tx, marginTop / 2);
            tx += 10 + textWidth(p.name);
            if (p.getValues().size() > 0) {
                stroke(p.lineColor);
                float lastX = (p.getValues().get(0).x - xMin) / xRange * graphWidth;
                float lastY = (p.getValues().get(0).y - yMin) / yRange * graphHeight;
                for (int i = 1; i < p.getValues().size(); i++) {
                    // convert values into screen coordinates
                    float px = (p.getValues().get(i).x - xMin) / xRange * graphWidth;
                    float py = (p.getValues().get(i).y - yMin) / yRange * graphHeight;
                    line(lastX + marginLeft, marginTop + graphHeight - lastY, px + marginLeft, marginTop + graphHeight - py);
                    lastX = px;
                    lastY = py;
                }
            }
        }
        
        popMatrix();
    }
}
