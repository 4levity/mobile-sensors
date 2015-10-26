# Java datacollector server for mobile-sensors #

This is a simple, fairly self-explanatory implementation of a Jetty self-contained web service with Jersey 2 annotated endpoints.

Requires: Java 1.7

Compile the server:

    ./gradlew jar
or

    gradlew jar

Run the server:

    java -jar build/libs/datacollector-1.0-SNAPSHOT.jar
