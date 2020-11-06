package si.fct.unl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.rapidoid.http.HTTP;
import org.rapidoid.setup.My;
import org.rapidoid.setup.On;

/*
This class is based on a Java thread, which runs permanently and will take care of planning,  monitoring, failures detection, diagnosis and recover.
*/
public class InteligentSupervisor extends Thread {

    private Warehouse warehouse;
    //private WebServerDemo webserver;
    private boolean interrupted = false;

    public InteligentSupervisor(Warehouse warehouse) {
        /*warehouse = new Warehouse();
        warehouse.initilizeHardwarePorts();*/
        this.warehouse=warehouse;
    }

    public void setInterrupted(boolean value) {
        this.interrupted = value;
        
    }
    
    synchronized String executePrologQuery(String query){
    
        String result = HTTP.get("http://localhost:8083/"+query).execute().result();
        
        try{
            Thread.sleep(2);
        }catch(InterruptedException ex){
        
            Logger.getLogger(InteligentSupervisor.class.getName()).log(Level.SEVERE, null, ex);
        }
        return result;
    }
    
    public void invokeDispatcher(){
        
        String result = this.executePrologQuery("query_dispatcher_json");
        if(!result.equalsIgnoreCase("[]")){
            JSONArray jsonArray = new JSONArray(result);
            for (int i=0; i < jsonArray.length(); i++){
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String action = jsonObject.getString("action_name");
                executeAction(action);
                
        
            }           
        }
    }
    
    public void executeAction(String action){
        if(action.equalsIgnoreCase("move_x_right")){
            warehouse.moveXRight();
        }else if(action.equalsIgnoreCase("move_x_left")){
            warehouse.moveXLeft();
        }else if(action.equalsIgnoreCase("stop_x")){
            warehouse.stopX();
        }else{
            System.out.printf("Dispatcher: Action %s means nothing to me. Go away!\n", action);
            return;
        
        }
        System.out.println("Executed action: " + action);
    }
    
    public void updateKnowledgeBase(){
        
        int position, state;
        StringBuilder queryStates = new StringBuilder("true");
        
        position = warehouse.getXPosition();
        if (position != -1){
            queryStates.append(String.format(",assert_once(x_is_at(%d))", position));
        }else{
            queryStates.append(",retract(x_is_at(_))");
        }
    
        position = warehouse.getYPosition();
        if (position != -1){
            queryStates.append(String.format(",assert_once(y_is_at(%d))", position));
        }else{
            queryStates.append(",retract(y_is_at(_))");
        }
    
        queryStates.append(String.format(",assert_once(x_moving(%d))", warehouse.getXMoving()));
        queryStates.append(String.format(",assert_once(y_moving(%d))", warehouse.getYMoving()));
        //FINISH FOR THE REMAINING SENSORS
        //...
        //System.out.println("query" + queryStates.toString()); //use this to test if ok
        String encodedStates = URLEncoder.encode(queryStates.toString(), StandardCharsets.UTF_8);
        String result = this.executePrologQuery("execute_remote_query?query="+encodedStates);
        //System.out.println(result);
    }
    
    public synchronized JSONObject obtainSensorInformation(){
        JSONObject  jsonObj = new JSONObject();
        jsonObj.put("x", warehouse.getXPosition());
        jsonObj.put("y", warehouse.getYPosition());
        jsonObj.put("z", 0);
        jsonObj.put("x_moving", warehouse.getXMoving());
        jsonObj.put("y_moving", warehouse.getYMoving());
        jsonObj.put("cage", warehouse.isPartInCage());
        //Complete for the remaining sensors
        //...

        return jsonObj;
    }
    
    public void run() {
        while (!interrupted) {
            try{
                executePrologQuery("query_forward"); //forward inference
                updateKnowledgeBase();
                invokeDispatcher();
                Thread.yield();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
         
    }
public void startWebServer() {
        On.port(8082);        
        On.get("/").html((req, resp) -> "Inteligent supervision server");
        
        My.errorHandler((req, resp, error) ->{        
            return resp.code(200).result("Error: " + error.getMessage());
        });
        
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
        
        On.get("/y-move-inside").serve(req -> {
            warehouse.moveYInside();
            req.response().plain("OK");
            return req;
        });

        On.get("/y-move-outside").serve(req -> {
            warehouse.moveYoutside();
            req.response().plain("OK");
            return req;
        });

        On.get("/y-stop").serve(req -> {
            warehouse.stopY();
            req.response().plain("OK");
            return req;
        });
        
        On.get("/z-move-up").serve(req -> {
            warehouse.moveZUp();
            req.response().plain("OK");
            return req;
        });

        On.get("/z-move-down").serve(req -> {
            warehouse.moveZDown();
            req.response().plain("OK");
            return req;
        });

        On.get("/z-stop").serve(req -> {
            warehouse.stopZ();
            req.response().plain("OK");
            return req;
        });
       
        On.get("/l-move-inside").serve(req -> {
            warehouse.moveLeftStationInside();
            req.response().plain("OK");
            return req;
        });

        On.get("/l-move-outside").serve(req -> {
            warehouse.moveLeftStationOutside();
            req.response().plain("OK");
            return req;
        });

        On.get("/l-stop").serve(req -> {
            warehouse.stopLeftStation();
            req.response().plain("OK");
            return req;
        });
        
        
        On.get("/r-move-inside").serve(req -> {
            warehouse.moveRightStationInside();
            req.response().plain("OK");
            return req;
        });

        On.get("/r-move-outside").serve(req -> {
            warehouse.moveRightStationOutside();
            req.response().plain("OK");
            return req;
        });

        On.get("/r-stop").serve(req -> {
            warehouse.stopRightStation();
            req.response().plain("OK");
            return req;
        });
        
        On.get("/read_sensor_values").serve(req -> {
            
            JSONObject jsonObj = obtainSensorInformation();
            req.response().plain(jsonObj.toString()    );
            return req;

        });
        
   
        On.get("/execute_remote_query").serve(req -> {            
            String the_query = "/execute_remote_query?query=" + URLEncoder.encode(req.param("query"), StandardCharsets.UTF_8);
            String result = this.executePrologQuery(the_query); //HTTP.get("http://localhost:8083/execute_remote_query?query="+the_query).execute().result();            
            req.response().plain(result);
            return req;
        });
    }
    
}
