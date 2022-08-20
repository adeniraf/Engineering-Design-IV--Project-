import processing.net.*;
import java.nio.*;
import java.util.*;

public static final String MSG_TELEMETRY = "TEL";

class BuggyTelem {
    public int state;
    public int dummyvariable;
    public float leftMotorVoltage;
    public float rightMotorVoltage;
    public float leftIRSensorValue;
    public float rightIRSensorValue;
    public float utlrasonicSensorValue;
    public float accelerometerX;
    public float accelerometerY;
    public float accelerometerZ;
    public float turn_pid_p;
    public float turn_pid_i;
    public float turn_pid_d;
    public float ultra_pid_p;
    public float ultra_pid_i;
    public float ultra_pid_d;
    public float angle;
};

class MessageParser {
    
    private final Queue<String> messageQueue;
    private boolean messageStarted = false;
    private StringBuilder current;
    
    public MessageParser() {
        this.messageQueue = new LinkedList();
        this.current = new StringBuilder();
        
    }
    
    public void poll(Client client) {
        while (client.available() > 0) {
            
            int value = client.read(); // 0 -> 255
            if (value == (int) '\n') {
                /// we have reached the end of a message
                // only add the message to the queue if we also saw the start
                if (messageStarted) {
                    messageQueue.add(current.toString());
                    println(current.toString());
                }
                current = new StringBuilder();
                messageStarted = true;
            } else {
                // always add the character to the string even if we end up throwing it away
                current.append((char) value);
            }
        }
    }
    
    public Queue<String> getMessageQueue() {
        return messageQueue;
    }
}

class Network extends PApplet {
    private long lastMsgTime;
    private final Client client;
    private final MessageParser parser;
    private BuggyTelem buggyTelem;
    
    public long getLastMsgTime(){
      return this.lastMsgTime;
    }
      
    public Network(Client client) {
        lastMsgTime = millis();
        this.parser = new MessageParser();
        this.client = client;
        this.client.write("HEY\n");
    }
    
    public void process() {
        parser.poll(client);
      
        while (parser.getMessageQueue().size() > 0) {
            lastMsgTime = millis();
            String message = parser.getMessageQueue().poll();
            String[] tokens = message.split(" ");
            switch (tokens[0]) {
                case MSG_TELEMETRY:
                    readBuggyTelemetry(tokens);
                    break;
                default:
                    System.err.println("Unknown Message: " + message);
                break;
            }
        }
    }
    
    public BuggyTelem getBuggyTelem() {
        return buggyTelem; 
    }
    
    private void readBuggyTelemetry(String[] tokens) throws MalformedMessageException {
        buggyTelem = new BuggyTelem();
        if (tokens.length != 18) {
            throw new MalformedMessageException("TEL", "Expected 18 tokens, got " + tokens.length);
        }
        buggyTelem.state                 = toInt(tokens[1], buggyTelem.state);
        buggyTelem.angle                 = toFloat(tokens[2], buggyTelem.angle);
        buggyTelem.leftMotorVoltage      = toFloat(tokens[3], buggyTelem.leftMotorVoltage);
        buggyTelem.rightMotorVoltage     = toFloat(tokens[4], buggyTelem.rightMotorVoltage);
        buggyTelem.leftIRSensorValue     = toFloat(tokens[5], buggyTelem.leftIRSensorValue);
        buggyTelem.rightIRSensorValue    = toFloat(tokens[6], buggyTelem.rightIRSensorValue);
        buggyTelem.utlrasonicSensorValue = toFloat(tokens[7], buggyTelem.utlrasonicSensorValue);
        buggyTelem.accelerometerX        = toFloat(tokens[8], buggyTelem.accelerometerX);
        buggyTelem.accelerometerY        = toFloat(tokens[9], buggyTelem.accelerometerY);
        buggyTelem.accelerometerZ        = toFloat(tokens[10], buggyTelem.accelerometerZ);
        buggyTelem.turn_pid_p            = toFloat(tokens[11], buggyTelem.turn_pid_p);
        buggyTelem.turn_pid_i            = toFloat(tokens[12], buggyTelem.turn_pid_i);
        buggyTelem.turn_pid_d            = toFloat(tokens[13], buggyTelem.turn_pid_d);
        buggyTelem.ultra_pid_p           = toFloat(tokens[14], buggyTelem.ultra_pid_p);
        buggyTelem.ultra_pid_i           = toFloat(tokens[15], buggyTelem.ultra_pid_i);
        buggyTelem.ultra_pid_d           = toFloat(tokens[16], buggyTelem.ultra_pid_d);
        buggyTelem.dummyvariable         = toInt(tokens[17], buggyTelem.dummyvariable); // Filler Line needed otherwise data sent is lost / gone 
       
    }
    
    private int toInt(String intStr, int def) {
        if (intStr == null) 
            return def;
        
        try {
            return Integer.parseInt(intStr.trim());
        } catch (NumberFormatException ignored) {
            return def; 
        }
    }
    
    private float toFloat(String floatStr, float def) {
        if (floatStr == null) 
            return def;
        
        try {
            Long i = Long.parseLong(floatStr.trim(), 16);
            return Float.intBitsToFloat(i.intValue());
        } catch (NumberFormatException ignored) {
            return def; 
        }
    }
}

public class MalformedMessageException extends RuntimeException {
   public MalformedMessageException(String messageType, String exception) {
       super("Exception while parsing " + messageType + " message: " + exception);
   }
}
