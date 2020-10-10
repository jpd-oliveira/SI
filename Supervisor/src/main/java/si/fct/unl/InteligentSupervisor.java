package si.fct.unl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import org.rapidoid.http.HTTP;
import org.rapidoid.setup.On;

/*
This class is based on a Java thread, which runs permanently and will take care of planning,  monitoring, failures detection, diagnosis and recover.
*/
public class InteligentSupervisor extends Thread {

    private Warehouse warehouse;
    private WebServerDemo webserver;

    private boolean interrupted = false;

    public InteligentSupervisor() {
        this.warehouse = new Warehouse();
        this.warehouse.initilizeHardwarePorts();
    }

    public void setInterrupted(boolean value) {
        this.interrupted = value;
    }
    
    public void run() {
        while (!interrupted) {
            Thread.yield();
        }
     
        // REMAINING CODE HEHE (next slides)
        
    }
public void startWebServer() {
        On.port(8082);        
        On.get("/").html((req, resp) -> "Inteligent supervision server");
        
        On.get("/x-move-right").serve(req -> {
            warehouse.moveXRight();
            req.response().plain("OK");
            return req;
        });

        On.get("/x-move-left").serve(req -> {
            warehouse.moveXLeft();
            req.response().plain("OK");
            return req;
        });

        On.get("/x-stop").serve(req -> {
            warehouse.stopX();
            req.response().plain("OK");
            return req;
        });
        
        On.get("/execute_remote_query").serve(req -> {            
            String the_query = URLEncoder.encode(req.param("query"), StandardCharsets.UTF_8);
            String result = HTTP.get("http://localhost:8083/execute_remote_query?query="+the_query).execute().result();            
            req.response().plain(result);
            return req;
        });
    }
    
}
