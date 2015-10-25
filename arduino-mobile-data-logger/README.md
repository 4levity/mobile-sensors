# arduino sensor reader for mobile-sensors #

Should work on pretty much any regular Arduino.

Uses Seeed 101020074 Temperature & Humidity sensor attached to i2c port

Uses Seeed 101020012 Grove Dust Sensor attached to Digital 8 port

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

