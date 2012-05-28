#include <Wire.h>

#include <Max3421e.h>
#include <Usb.h>
#include <AndroidAccessory.h>

#include "NewSoftSerial.h"

#include "Adafruit_Thermal.h"
#include "start.cpp"
#include "Penguins.cpp"
#include "ends.cpp"

AndroidAccessory acc("Yunsu Choi",
"Air Purifier",
"DemoKit Arduino Board",
"1.0",
"http://www.android.com",
"0000000012345678");

int printer_RX_Pin = 2;  // this is the green wire
int printer_TX_Pin = 3;  // this is the yellow wire 
Adafruit_Thermal printer(printer_RX_Pin, printer_TX_Pin);

void setup()
{
  Serial.begin(9600);
  Serial.print("\r\nStart");
  acc.powerOn();
}

void loop()
{
  static byte count = 0;
  byte msg[3];

  if (acc.isConnected()) {
    Serial.print("Accessory connected. ");
    int len = acc.read(msg, sizeof(msg), 1); // Do Not Change 1 into -1
    //delay(1000);
    Serial.print("Message length: ");
    Serial.println(len, DEC);
  } 
  delay(100);
  
    if (acc.isConnected()) { // working codes are MUST in this {} site.
    int len = acc.read(msg, sizeof(msg), 1);  
    if (len>0){
      if (msg[0] == 0x1){ // recognize first element from Android.
          if (msg[1] == 0x0) { //when button pressed in Android.
            acc.write(msg, 3); // send message to SerialMonitor
            printer.begin();
           
            delay(3000);
            printer.printBitmap(66, 171, start);  // Image 1(start.ccp) print
            delay(3000);
        
            printer.print("simple words\n");  // Text output
            delay(3000);
        
            delay(3000);
            printer.printBitmap(66, 191, ends);  // Image 2(end.ccp) print
            delay(3000);
        
            printer.sleep(); //Tell printer to sleep. MUST call wake before printing again, even if reset
            printer.wake(); //Wake printer.
            printer.setDefault(); //set printer to defaults. ****WILL FEED SEVERAL LINES WHEN CALLED***
          }
          
          else if(msg[1] == 0x1){
            int msg[2];
            
            printer.begin();   

            delay(3000);
            printer.print(msg[2]);  // Text output
            delay(3000);
            printer.print(" steps!\n");  // Text output            
            
            printer.sleep(); //Tell printer to sleep. MUST call wake before printing again, even if reset
            printer.wake(); //Wake printer.
            printer.setDefault(); //set printer to defaults. ****WILL FEED SEVERAL LINES WHEN CALLED***

            acc.write(msg, 3);
          }
      }
  }
 }
}

