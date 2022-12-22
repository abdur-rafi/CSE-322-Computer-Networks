package Server;

import Server.SocketServer.Server;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        System.out.println("hello socket server");
        Server.getServer().start();
//        System.out.println(System.getProperty("user.dir"));
//        var lst = new File("./root/").list();
//        for(var f : lst){
//            System.out.println(new File("./root/" + f).isDirectory());
//            System.out.println(f);
//        }
//        System.out.println(HTMLBuilder.build(new File("./root/")));
    }

}
