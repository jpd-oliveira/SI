package si.fct.unl;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.GridPane;
import javafx.stage.Stage;
import javafx.stage.WindowEvent;


/**
 * JavaFX App
 */
public class App extends Application {
    
    Warehouse warehouse = new Warehouse();
    final InteligentSupervisor supervisor  = new InteligentSupervisor(warehouse);

    @Override
    public void start(Stage primaryStage) {

        new Thread() {
            public void run() {               
                warehouse.initilizeHardwarePorts();
            }
        }.start();
        
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
        
        Button buttonZUp = new Button("z-up");
        Button buttonZDown = new Button("z-down");
        Button buttonZStop = new Button("z-stop");
        
        Button buttonLeftStationIn = new Button("l-in");
        Button buttonLeftStationOut = new Button("l-out");
        Button buttonLeftStationStop = new Button("l-stop");
        
        Button buttonRightStationIn = new Button("r-in");
        Button buttonRightStationOut = new Button("r-out");
        Button buttonRightStationStop = new Button("r-stop");
        
        Button buttonLaunchProlog = new Button("Launch Prolog");
        Button buttonSuperbvisionUI = new Button("Launch SI-UI");
        Button startSupervisorButton = new Button("Start Supervisor");


        
        buttonXRight.setOnAction (event -> {
            warehouse.moveXRight();
            System.out.println("x moving right");
        });
        
        buttonXLeft.setOnAction (event -> {
            warehouse.moveXLeft();
            System.out.println("x moving left");
        });
        
        buttonXStop.setOnAction (event -> {
            warehouse.stopX();
            System.out.println("x stoped");
        });
        
         buttonYInside.setOnAction (event -> {
            warehouse.moveYInside();
            System.out.println("y moving inside");
        });
        
        buttonYOutside.setOnAction (event -> {
            warehouse.moveYoutside();
            System.out.println("y outside");
        });
        
        buttonYStop.setOnAction (event -> {
            warehouse.stopY();
            System.out.println("x stoped");
        });
        
         buttonZUp.setOnAction (event -> {
            warehouse.moveZUp();
            System.out.println("x moving right");
        });
        
        buttonZDown.setOnAction (event -> {
            warehouse.moveZDown();
            System.out.println("x moving left");
        });
        
        buttonZStop.setOnAction (event -> {
            warehouse.stopZ();
            System.out.println("x stoped");
        });
        
        
        buttonLeftStationIn.setOnAction (event -> {
            warehouse.moveLeftStationInside();
            System.out.println("Left station moving inside");
        });
        
        buttonLeftStationOut.setOnAction (event -> {
            warehouse.moveLeftStationOutside();
            System.out.println("Left station moving outside");
        });
        
        buttonLeftStationStop.setOnAction (event -> {
            warehouse.stopLeftStation();
            System.out.println("Left station stoped");
        });
        
        
        buttonRightStationIn.setOnAction (event -> {
            warehouse.moveRightStationInside();
            System.out.println("Right station moving inside");
        });
        
        buttonRightStationOut.setOnAction (event -> {
            warehouse.moveRightStationOutside();
            System.out.println("Right station moving outside");
        });
        
        buttonRightStationStop.setOnAction (event -> {
            warehouse.stopRightStation();
            System.out.println("Right station stoped");
        });
        
        buttonLaunchProlog.setOnAction(event->{
            try {
                String folder = System.getProperty("user.dir");
                Runtime.getRuntime().exec("swipl-win.exe -f "+folder +"/kbase/supervisor.pl -g main");
                buttonLaunchProlog.setDisable(true);
            } catch (IOException ex) {
                Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
            }                
        });
        
        buttonSuperbvisionUI.setOnAction(event->{
            
            buttonSuperbvisionUI.setDisable(true);
            
            try {
                java.awt.Desktop.getDesktop().browse(new URI("http://localhost:8082/supervisor-ui.html"));
            } catch (IOException | URISyntaxException ex) {
                Logger.getLogger(App.class.getName()).log(Level.SEVERE, null, ex);
            }                
        });
        
        startSupervisorButton.setOnAction(event->{
            
            startSupervisorButton.setDisable(true);
            supervisor.start();
        });


        
        GridPane root = new GridPane();
        root.add(buttonXRight,1,1);
        root.add(buttonXLeft,2,1);
        root.add(buttonXStop,3,1);
        root.add(buttonYInside,1,2);
        root.add(buttonYOutside,2,2);
        root.add(buttonYStop,3,2);
        root.add(buttonZUp,1,3);
        root.add(buttonZDown,2,3);
        root.add(buttonZStop,3,3);
        root.add(buttonLeftStationIn,1,4);
        root.add(buttonLeftStationOut,2,4);
        root.add(buttonLeftStationStop,3,4);
        root.add(buttonRightStationIn,1,5);
        root.add(buttonRightStationOut,2,5);
        root.add(buttonRightStationStop,3,5);
        
        root.add(buttonLaunchProlog, 1, 6);
        root.add(buttonSuperbvisionUI, 2, 6);
        root.add(startSupervisorButton, 3, 6);
        root.setHgap(10);
        root.setVgap(10);
        Scene scene = new Scene (root, 300, 250);
        primaryStage.setTitle("Hello World");
        primaryStage.setScene(scene);
        primaryStage.show();      
    }
    
    private void closeWindowEvent(WindowEvent event){
    
        System.out.println("Window close request ...");
        supervisor.setInterrupted(true);
        Platform.exit();
        System.exit(0);
    }
    
    public static void main(String[] arg){
        launch();
    }
}