
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

public class Webserver {

    public static void main(String[] args) throws Exception {
        HttpServer server = HttpServer.create(new InetSocketAddress(8000), 0);
        server.createContext("/game", new MyHandler());
        server.setExecutor(null); // creates a default executor
        server.start();
    }

    static class MyHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange t) throws IOException {
            
            //Execute command
            try {
                //Process process = Runtime.getRuntime().exec("kubectl get pod");

                String[] cmdline = { "/data", "-c", "/kubectl run -it --rm --image=docker.io/andreatraldi/game:v1 --restart=Never game -- /bin/bash" }; 
                Process process = Runtime.getRuntime().exec(cmdline);
                printResults(process);
                
            } catch (Exception e) {
                // printStackTrace method
                // prints line numbers + call stack
                e.printStackTrace();
              
                // Prints what exception has been thrown
                System.out.println(e);
            }
    


            String response = "Entering the Game!";
            t.sendResponseHeaders(200, response.length());
            OutputStream os = t.getResponseBody();
            os.write(response.getBytes());
            os.close();
        }
    }

    public static void printResults(Process process) throws IOException {
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line = "";
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
}

}
