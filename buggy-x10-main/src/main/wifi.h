#ifndef BuggyWiFi_h
#define BuggyWiFi_h

#include <WiFiNINA.h>
#include "Arduino.h"

namespace BuggyWifi {
    inline void connectToExisting(const char* ssid, const char* password) {
        IPAddress address(192, 168, 0, 207);
      
        int status = WL_IDLE_STATUS;
        while (status != WL_CONNECTED) {
            Serial.print("Attempting to connect to SSID: ");
            Serial.println(ssid);
            status = WiFi.begin(ssid, password);
            Serial.print("Connection status: "); Serial.println(status);
            digitalWrite(LED_BUILTIN, HIGH);
            delay(500);
            digitalWrite(LED_BUILTIN, LOW);
        }
      
        long rssi = WiFi.RSSI();
        Serial.print("Signal strength (RSSI): ");
        Serial.println(rssi);
        
        IPAddress assignedIP = WiFi.localIP();
        Serial.print("IP Address: "); Serial.println(assignedIP);
        
    }
    
    void openAccessPoint(const char* ssid, const char* password) {
        Serial.print("Attempting to open access point: ");
        Serial.println(ssid);
        int status = WiFi.beginAP(ssid, password);
        while (status != WL_AP_LISTENING) {
            Serial.print(status); Serial.print(": "); Serial.println("Failed to start open access point, retrying...");
            WiFi.disconnect();
            status = WiFi.beginAP(ssid, password);
            digitalWrite(LED_BUILTIN, HIGH);
            delay(500);
            digitalWrite(LED_BUILTIN, LOW);
        }
        Serial.print("Access point successfully opened. Password: ");
        Serial.println(password);
    }
}

#endif
