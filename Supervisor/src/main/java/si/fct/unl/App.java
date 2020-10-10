package si.fct.unl;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;


/**
 * JavaFX App
 */
public class App extends Application {

    @Override
    public void start(Stage primaryStage) {
     
        Warehouse warehouse = new Warehouse();
        warehouse.initilizeHardwarePorts();
                
        InteligentSupervisor supervisor = new     InteligentSupervisor();
        supervisor.startWebServer();

        
        Button buttonXRight = new Button("x-right");
        Button buttonXLeft = new Button("x-left");
        Button buttonXStop = new Button("x-stop");
        buttonXRight.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        buttonXLeft.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        buttonXStop.setMaxSize(Double.MAX_VALUE, Double.MAX_VALUE);
        Button buttonYInside = new Button ("y-inside");
        Button buttonYOutside = new Button ("y-outside");
        Button buttonYStop = new Button ("y-stop");
        Button buttonLaunchProlog = new Button("Launch Prolog");
        Button buttonSuperbvisionUI = new Button("Launch SI-UI");


        
        buttonXRight.setOnAction (event -> {
            warehouse.moveXRight();
            System.out.println("x moving right");
        });
        
        buttonLaunchProlog.setOnAction(event->{
            try {
                String folder = System.getProperty("user.dir");
                Runtime.getRuntime().exec("swipl-win.exe -f "+folder +"/kbase/supervisor.pl -g main");
            } catch (IOException ex) {
                Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
            }                
        });
        
        buttonSuperbvisionUI.setOnAction(event->{
            try {
               
                java.awt.Desktop.getDesktop().browse(new URI("http://localhost:8082/supervisor-ui.html"));
            } catch (IOException ex) {
                Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
            } catch (URISyntaxException ex) {
                Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
            }                
        });


        
        GridPane root = new GridPane();
        root.add(buttonXRight,1,1);
        root.add(buttonXLeft,2,1);
        root.add(buttonXStop,3,1);
        root.add(buttonYInside,1,2);
        root.add(buttonYOutside,2,2);
        root.add(buttonYStop,3,2);
        root.add(buttonLaunchProlog, 1, 3);
        root.add(buttonSuperbvisionUI, 2, 3);
        root.setHgap(10);
        root.setVgap(10);
        Scene scene = new Scene (root, 300, 250);
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(scene);
        primaryStage.show();
        
        
        
        
    }


}