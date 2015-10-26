# Java datacollector server for mobile-sensors #

This is a simple, fairly self-explanatory implementation of a Jetty self-contained web service with Jersey 2 annotated endpoints. 
Should build and run with JDK 1.7 under Linux, Windows or OS X. 

A reasonable starting point for more sophisticated projects - the addition of authentication, privacy, request logging, a database, and support for multiple devices is left as an exercise!

To compile the server:

    ./gradlew jar
or

    gradlew jar

To run the server:

    java -jar build/libs/datacollector-1.0-SNAPSHOT.jar
