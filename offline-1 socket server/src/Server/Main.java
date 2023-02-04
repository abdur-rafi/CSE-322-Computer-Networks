package Server;

import Server.SocketServer.Server;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        System.out.println("hello socket server");
        Server.getServer().start();
    }

}
