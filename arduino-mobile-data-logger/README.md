# arduino sensor reader for mobile-sensors #

This project should work on pretty much any regular Arduino and only requires a few connections.

With a smaller microcontroller (even an Arduino Mini) and some careful soldering, you could make this whole package only a little bigger than the iPhone itself. You could even get a little tricky and power the whole thing from the iPhone plug, if a day or less of battery life would be sufficient. That said, I didn't do any of those things; this was for a 1 day hackathon!

* Used Grove Base Shield to simplify connecting components.   
* Uses Grove 101020074 Temperature & Humidity sensor plugged into i2c port
* Uses Grove 101020012 Grove Dust Sensor attached plugged into Digital #8 port

### Drivers ###

To use the temperature and humidity sensor in Arduino, you need to install the library. Go here and follow the simple instructions. https://github.com/Seeed-Studio/Grove_Temper_Humidity_TH02

The dust sensor doesn't have much of a driver yet. This project incorporates some code shared by Chris Nafis to interface with the device. http://www.howmuchsnow.com/arduino/airquality/grovedust/

### How to connect serial port to iPhone ###

Use breakout board e.g. PodBreakout or similar which exposes iPhone serial RX pin.

iPhone uses 3.3v serial while Arduino uses 5V. Don't connect directly, could damage iPhone.

1. Connect ground to iPhone ground
2. Connect Arduino TX to voltage divider made from 3x 100 ohm resistors
3. Connect iPhone RX between resistors 1 and 2.

Diagram:


	GND - Resistor - Resistor + Resistor - ArduinoTX
                              |
                          iPhoneRX

### Using Anker or similar USB power supply ###

These power supplies are convenient, but some models turn off automatically if there is not enough load.

A 1/4 watt 100 ohm resistor connected between 5V and Gnd pins will add (waste) 50mA of load and prevent the USB power supply from turning off.

