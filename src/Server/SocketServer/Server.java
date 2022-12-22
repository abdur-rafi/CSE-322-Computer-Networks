package Server.SocketServer;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    private static Server server;
    private ServerSocket serverSocket;
    private Server() throws IOException {
        serverSocket = new ServerSocket(5008);
    }
    public static Server getServer() throws IOException {
        if(server == null){
            server = new Server();
        }
        return server;
    }

    public void start(){
        while(true){
            try {
                Socket socket = serverSocket.accept();
                new Worker(socket).start();

            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }
}
