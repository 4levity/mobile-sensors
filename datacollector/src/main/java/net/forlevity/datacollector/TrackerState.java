package net.forlevity.datacollector;

import java.util.Date;

/**
 * Created by ivan on 10/25/15.
 */
public class TrackerState {
    public static TrackerState instance = new TrackerState();
    private TrackerState() {}

    // gps
    Date gpsTimestamp = null;
    Double latitude = null;
    Double longitude = null;
    Integer altitude = null;
    Integer haccuracy = null;
    Integer vaccuracy = null;
    Integer speed = null;
    Integer direction = null;
    Integer distance = null;

    // sensors
    Date sensorTimestamp = null;
    Double concentration = null;
    Double tempc = null;
    Double humidity = null;

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public Integer getAltitude() {
        return altitude;
    }

    public Integer getHaccuracy() {
        return haccuracy;
    }

    public Integer getVaccuracy() {
        return vaccuracy;
    }

    public Integer getSpeed() {
        return speed;
    }

    public Integer getDirection() {
        return direction;
    }

    public Integer getDistance() {
        return distance;
    }

    public Double getConcentration() {
        return concentration;
    }

    public Double getTempc() {
        return tempc;
    }

    public Double getHumidity() {
        return humidity;
    }

    public void update(Double latitude, Double longitude, Integer altitude, Integer haccuracy, Integer vaccuracy,
                       Integer speed, Integer direction, Integer distance, Double concentration, Double tempc, Double humidity) {
        if(latitude != null) {
            this.gpsTimestamp = new Date();
            this.latitude = latitude;
            this.longitude = longitude;
            this.altitude = altitude;
            this.haccuracy = haccuracy;
            this.vaccuracy = vaccuracy;
            this.speed = speed;
            this.direction = direction;
            this.distance = distance;
        }
        if(concentration != null) {
            this.sensorTimestamp = new Date();
            this.concentration = concentration;
            this.tempc = tempc;
            this.humidity = humidity;
        }

        // TODO: write to a file or database

        System.out.println(this.gpsTimestamp+","
                +this.latitude+","
                +this.longitude+","
                +this.altitude+","
                +this.haccuracy+","
                +this.vaccuracy+","
                +this.speed+","
                +this.direction+","
                +this.distance+","
                +this.sensorTimestamp+","
                +this.tempc+","
                +this.humidity+","
                +this.concentration);
    }
}
