package server2;

import common.CustomInputStream;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

public class server {
    public static void main(String[] args) throws IOException {

//        BufferedInputStream reader = new BufferedInputStream(new FileInputStream("./src/client/dog image.jpg"));
//        BufferedOutputStream writer = new BufferedOutputStream(new FileOutputStream("test.jpg"));
//        String line;
//        int c = 0;
//        byte[] buff = new byte[512];
//        int n = 0;
//        while((n = reader.read(buff, 0, 512)) > 0){
//            writer.write(buff, 0, n);
//            ++c;
//        }
//        writer.flush();
//        writer.close();
//        System.out.println("c : " + c);
        try {
            ServerSocket serverSocket = new ServerSocket(5009);
            while (true) {
                Socket socket = serverSocket.accept();

//                ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
//                while(true){
//                    char c = ois.readChar();
//                    System.out.println("c : " + c);
//                }
//                BufferedReader r = new BufferedReader(new InputStreamReader(socket.getInputStream()));
//                System.out.println(r.readLine());
                CustomInputStream cis = new CustomInputStream(socket.getInputStream());
                System.out.println(cis.readLine());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
