package si.fct.unl;

import org.rapidoid.setup.App;
import org.rapidoid.setup.On;
import org.rapidoid.setup.Setup;


public class WebServerDemo {
    
    public static void startServer() {
        On.port(8082);
        On.get("/").html((req, resp) -> "Hello again!");     
    }
    
}
