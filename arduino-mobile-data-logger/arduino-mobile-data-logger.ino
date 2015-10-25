/* 
 *  Arduino Mobile Data Logger
 *  created for SF Science Hack Day 2015
 *  by C. Ivan Cooper
 */
 
/*
 Some code from: Grove - Dust Sensor Demo v1.0
 Interface to Shinyei Model PPD42NS Particle Sensor
 Program by Christopher Nafis written April 2012 
 http://www.seeedstudio.com/depot/grove-dust-sensor-p-1050.html
 http://www.sca-shinyei.com/pdf/PPD42NS.pdf
 */

#include <TH02_dev.h>
#include "Arduino.h"
#include "Wire.h" 

int pin = 8;
unsigned long duration;
unsigned long starttime;
//unsigned long sampletime_ms = 30000; // 30 seconds
unsigned long sampletime_ms = 10000; // 10 seconds (less accurate)
unsigned long lowpulseoccupancy = 0;
float ratio = 0;
float concentration = 0;

void setup() {
  Serial.begin(9600);
  pinMode(8,INPUT); // air quality sampling

  /* Power up,delay 150ms,until voltage is stable */
  delay(150);
  /* Reset HP20x_dev */
  TH02.begin(); // temp + humidity
  delay(100);
  
  starttime = millis();//get the current time;
}

void loop() {
  duration = pulseIn(pin, LOW);
  lowpulseoccupancy = lowpulseoccupancy+duration;

  if ((millis()-starttime) > sampletime_ms)//if the sampel time == 30s
  {
    // after x seconds we calculate dust sensor result
    ratio = lowpulseoccupancy/(sampletime_ms*10.0);  // Integer percentage 0=>100
    concentration = 1.1*pow(ratio,3)-3.8*pow(ratio,2)+520*ratio+0.62; // using spec sheet curve

    // and snapshot other sensor data
    float temp = TH02.ReadTemperature(); 
    float humidity = TH02.ReadHumidity();

    // and send result over serial port
    Serial.print("conc=");
    Serial.print(concentration);
    Serial.print("tempc=");
    Serial.print(temp);
    Serial.print("humidity=");
    Serial.print(humidity);    
    Serial.println("\n");
    
    // reset dust sensor counter and timer and resume sampling
    lowpulseoccupancy = 0;
    starttime = millis();
  }


}
