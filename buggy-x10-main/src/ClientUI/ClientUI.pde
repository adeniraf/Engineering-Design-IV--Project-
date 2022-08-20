import controlP5.*;
import processing.net.*;
import java.awt.Toolkit;

ControlP5 cp5;
Client client;
Network network;
HUD hud;

Console console;
Controls controls;
Stats stats;
Graph turn_pidGraph;
Graph us_pidGraph;
Accel accel;
Plot p_term, i_term, d_term;
Plot us_p_term, us_i_term, us_d_term;
PImage backgroundimg;

void setup() {
    size(1600, 900);
    
    client = new Client(this, "192.168.4.1", 3574); // For Access Point
    //client = new Client(this, "192.168.0.207", 3574); // For WiFi
    
    network = new Network(client);
    
    p_term = new Plot("PID_p", color(0, 0, 255));
    i_term = new Plot("PID_i", color(255, 0, 0));
    d_term = new Plot("PID_d", color(0, 255, 0));
    
    us_p_term = new Plot("US_PID_p", color(0, 0, 255));
    us_i_term = new Plot("US_PID_i", color(255, 0, 0));
    us_d_term = new Plot("US_PID_d", color(0, 255, 0));
    
    backgroundimg = loadImage("bckg2.png");
   
    turn_pidGraph = new Graph(p_term, i_term, d_term);
    us_pidGraph = new Graph(us_p_term, us_i_term, us_d_term);
    
    stats = new Stats(942,25,200,125);
    controls = new Controls(this,775,570);
    hud = new HUD();
    console = new Console();
    accel = new Accel();
    
}

void draw() {
    background(backgroundimg);
    
    network.process();
    if (network.getBuggyTelem() != null) {
        int time = millis();
        p_term.setCurrentValue(time, network.getBuggyTelem().turn_pid_p);
        i_term.setCurrentValue(time, network.getBuggyTelem().turn_pid_i);
        d_term.setCurrentValue(time, network.getBuggyTelem().turn_pid_d);
        
        us_p_term.setCurrentValue(time, network.getBuggyTelem().ultra_pid_p);
        us_i_term.setCurrentValue(time, network.getBuggyTelem().ultra_pid_i);
        us_d_term.setCurrentValue(time, network.getBuggyTelem().ultra_pid_d);
        
        hud.draw(network.getBuggyTelem(), 1160, 30, 390, 390);
        turn_pidGraph.draw(20, 40, 700, 400);
        us_pidGraph.draw(20, 450, 700, 400);
        
        stats.draw(network.getBuggyTelem(),730,250,195,180);
        controls.draw(730,500,400,310);
        console.draw(730,65,400,165);
        accel.draw(network.getBuggyTelem(), 1170, 470, 370, 370);
    }
    if (network.getLastMsgTime() + 1500 < millis() && !client.active() ){
      Reconnect();
    }
}

public void Reconnect() {
    console.Print_Text("Manually reconnecting Client");
    client.stop();
    client = new Client(this, "192.168.0.207", 3574); // Wifi
    //client = new Client(this, "192.168.4.1", 3574);  // Access point 
    network = new Network(client);
}
  
void ON_OFF(boolean Switch) {
    Toolkit.getDefaultToolkit().beep(); // Sound test , may or may not break ears idk
    if (Switch){
      // Turn on the buggy 
        stats.set_state("ON");
        console.Print_Text("Starting buggy");
        client.write("STA\n");
    }
    else {
      // Turn off the buggy
        stats.set_state("OFF");
        console.Print_Text("Stopping buggy");
        client.write("STO\n");
    }
}

void Input_Speed(String text) { 
    console.Print_Text("Changing buggy speed to: " + text); 
    stats.set_speed(text);
    String s = "SPE " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
  //println(s);
}

void P_term(String text) { 
    console.Print_Text("Changing IR_P variable to: " + text); 
    stats.set_P_term(text);
    String s = "TPP " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
    //println(s);
}

void I_term(String text) {
    console.Print_Text("Changing IR_I variable to: " + text); 
    stats.set_I_term(text);
    String s = "TPI " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
 //println(s);
}

void D_term(String text) {
    console.Print_Text("Changing IR_D variable to: " + text);  
    stats.set_D_term(text);
    String s = "TPD " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
 //println(s);
}

void US_P_term(String text) { 
    console.Print_Text("Changing US_P variable to: " + text); 
    stats.set_US_P_term(text);
    String s = "USP " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
 //println(s);
}

void US_I_term(String text) {
    console.Print_Text("Changing US_I variable to: " + text); 
    stats.set_US_I_term(text);
    String s = "USI " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
 //println(s);
}

void US_D_term(String text) {
    console.Print_Text("Changing US_D variable to: " + text); 
    stats.set_US_D_term(text);
    String s = "USD " + controls.floatToHexStringConverter(text) + "\n";
    client.write(s);
 //println(s);
}
