# mobile-sensors #

Created by Ivan Cooper / 4Levity for SF Science Hack Day 2015

https://github.com/4levity

Description: Mobile sensor data collection w/ iPhone+Arduino+Java server components

### Instructions ###

This project has several components. Each folder has its own README file
explaining how to use that component.

* arduino-mobile-data-logger - Arduino project to get sensor data and send
over the serial port to the iPhone

* ios-script - Simple shell script for jailbroken iPhone that receives data from Arduino and sends
it to a remote web service.

* ios-gps-tracker - iOS app that constantly gets location from Location Services on
the phone, and sends it to a remote web service any time the location changes.

* datacollector - Standalone Java app that runs a Jetty web service to collect data
from the ios-script and ios-gps-tracker .
