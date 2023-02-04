package Client;

import common.Utility;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.Socket;

public class Worker extends Thread {

    private BufferedOutputStream bos;
    private Socket socket;
    File file;


    public Worker(Socket socket, File file) throws IOException {
        this.socket = socket;
        bos = new BufferedOutputStream(socket.getOutputStream());
        this.file = file;
    }


    @Override
    public void run() {

        try {
            bos.write(("UPLOAD " + file.getName().replace(" ", "%20") + "\n").getBytes());
            bos.flush();
            Utility.sendFile(file, bos, true);
            bos.flush();
            bos.close();
            socket.close();


        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
