# mobile-sensors #

Description: Mobile sensor data collection w/ iPhone+Arduino+Java server components

Created by Ivan Cooper for SF Science Hack Day 2015 - Original source at https://github.com/4levity

You are free to use and modify this under the terms of the MIT license; see the LICENSE file for details.

### Instructions ###

Each component folder has its own README file explaining how to build and use that component. You need a Windows, Mac or Linux computer with Arduino software and JDK 1.7 to build the Arduino and Java components. You need a Mac with Xcode installed to build the iOS component.

Details on how to connect the Arduino serial port to an iPhone are in the "arduino-mobile-data-logger" folder.

### Component Descriptions ###

There are four components:

* arduino-mobile-data-logger - Arduino project to get sensor data and send
over the serial port to the iPhone

* ios-script - Simple shell script for jailbroken iPhone that receives data from Arduino and sends
it to a remote web service.

* ios-gps-tracker - iOS app that constantly gets location from Location Services on
the phone, and sends it to a remote web service any time the location changes.

* datacollector - Standalone Java app that runs a Jetty web service to collect data
from the ios-script and ios-gps-tracker .
