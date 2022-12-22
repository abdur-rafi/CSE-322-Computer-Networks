package Client;

import common.Utility;

import java.io.File;
import java.io.IOException;
import java.net.Socket;
import java.util.Scanner;

public class Main {
    public static void main(String[] args){
        System.out.println("From client");
        try {
            Scanner scanner = new Scanner(System.in);
            while(true){
                Socket socket = new Socket("localhost", 5008);
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
                    if(!(Utility.isText(file) || Utility.isImage(file))){
                        System.out.println("File Type Not Supported");
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
