package net.forlevity.datacollector;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Created by ivan on 10/25/15.
 */
@Path("/")
public class RootResource {
    @GET
    public Response getroot() throws URISyntaxException {
        return Response.temporaryRedirect(new URI("https://www.google.com/maps/?q="
                +TrackerState.instance.getLatitude()+","+TrackerState.instance.getLongitude()))
                .build();
    }

    // TODO: add unique identifier with /loc and /dat requests so you can collect data from multiple devices

    @GET
    @Path("loc")
    @Produces(MediaType.TEXT_PLAIN)
    public String loc(@QueryParam("latitude") double latitude,
                      @QueryParam("longitude") double longitude,
                      @QueryParam("altitude") int altitude,
                      @QueryParam("haccuracy") int haccuracy,
                      @QueryParam("vaccuracy") int vaccuracy,
                      @QueryParam("speed") int speed,
                      @QueryParam("direction") int direction,
                      @QueryParam("distance") int distance) {
        TrackerState.instance.update(latitude, longitude, altitude,
            haccuracy, vaccuracy, speed, direction, distance,
                null, null, null);
        //System.out.println("new location: "+latitude+","+longitude+" accuracy="+accuracy);
        return "received";
    }
    @GET
    @Path("dat")
    @Produces(MediaType.TEXT_PLAIN)
    public String dat(@QueryParam("conc") double concentration,
                      @QueryParam("tempc") double tempc,
                      @QueryParam("humidity") double humidity) {
        TrackerState.instance.update(null, null, null, null, null, null, null, null,
                concentration,tempc,humidity);
        //System.out.println("particle concentration: "+concentration+" pcs/0.01cf");
        return "ok";
    }
}
