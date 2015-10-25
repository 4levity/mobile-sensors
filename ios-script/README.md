# iOS shell script for sensor data upload #

This simple script runs on the iPhone from the shell. For this demo I started it manually but it could run automatically from a .plist file.

Requires wget and Core Utilities from Cydia repository.

TO USE: 

 * SSH into the phone and create this script e.g. sftp or copy and paste into a file
 * make the script executable: "chmod u+x gather.sh"
 * Edit the script and replace the URL with the URL to your server where datacollector program is running.
 * Run the script: "./gather.sh"

### Why doesn't it work? ###

Try running minicom first (install from Cydia).

In minicom, set the serial port to /dev/tty.iap , baud rate to 9600 baud.

With the Arduino connected, you should see sensor data updating every 10 seconds in minicom.

Then, quit minicom and run the script.
