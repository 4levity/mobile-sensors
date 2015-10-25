# GPS tracker app for iPhone #

Thanks to Nick Fox who created the GpsTracker app on which this is based.
https://github.com/nickfox/

Note that this app only works up to iOS 7.1. So it's perfect for an iPhone 3 or 4.

This app probably doesn't require a jailbroken phone. (I think, not tested)

You could modify this app to also gather sensor data via Bluetooth or iPhone's own sensors,
and send it all at once, rather than using the little script in the ios-script folder
which does require jailbreaking.

### Building ###

You need to install CocoaPods from https://cocoapods.org/

Then change into the ios-gps-tracker folder and run

    pod install

You should see that this creates a folder called Pods.

After this is done, you can load the project in Xcode, compile it and
transfer it to a phone.
