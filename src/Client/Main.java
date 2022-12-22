package Client;

import java.io.File;
import java.io.IOException;
import java.net.Socket;
import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        System.out.println("From client");
        try {
            Socket socket = new Socket("localhost", 5008);
            Scanner scanner = new Scanner(System.in);
            while(true){
                System.out.println("Enter file path: ");
                String fileName = scanner.nextLine();
                File file = new File("./src/client/" + fileName);
                if(!file.exists()){
                    System.out.println("File does not exist");
                }
                else if(file.isDirectory()){
                    System.out.println("Given path is a directory");
                }
                else{
                    new Worker(socket, file).start();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
