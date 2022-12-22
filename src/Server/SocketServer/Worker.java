package Server.SocketServer;

import common.CustomInputStream;
import common.Utility;

import java.io.*;
import java.net.Socket;
import java.util.Date;

public class Worker extends Thread {
    private Socket socket;
    private String header;
    BufferedOutputStream bos;
    CustomInputStream reader;

    public Worker(Socket socket) throws IOException {
        this.socket = socket;
        header = "HTTP/1.1 %d %s\r\nServer: Java HTTP Server : 1.0\r\nDate: %s\r\nContent-Type: %s\r\nContent-Length: %d\r\n\r\n";
        bos = new BufferedOutputStream(socket.getOutputStream());
        reader = new CustomInputStream(socket.getInputStream());
    }


    void sendError() throws IOException {
        File file = new File("notFound.html");
        String h = String.format(header, 404, "NOT FOUND", new Date().toString(), "text/html", file.length());
        bos.write(h.getBytes());
        Utility.sendFile(file, bos, false);

    }

    void sendIndex() throws IOException {
        File file = new File("index.html");
        String h = String.format(header, 200, "ok", new Date().toString(), "text/html", file.length());
        bos.write(h.getBytes());
//        System.out.println("here");
        Utility.sendFile(file, bos, false);
    }

    void sendDirList(File file) throws IOException {
        String response = HTMLBuilder.build(file);
        var b = response.getBytes();
        String h = String.format(header, 200, "ok", new Date().toString(), "text/html", b.length);
        bos.write(h.getBytes());
        bos.write(b);
    }

    void sendFile(File file, String contentType) throws IOException {
        System.out.println("content type : " + contentType);
        System.out.println("file name : " + file.getName());
        String h = String.format(header, 200, "ok", new Date().toString(), contentType, file.length());
        bos.write(h.getBytes());
        Utility.sendFile(file, bos, false);
    }

    void sendTextFile(File file) throws IOException {
        sendFile(file, "text/plain");
    }

    void sendImageFile(File file) throws IOException {
        String extension = Utility.getExtension(file);
        sendFile(file, "image/" + extension);
    }

    void downloadFile(File file) {

    }

    void receiveFile(String filename ) throws IOException {
        String size = reader.readLine();
        System.out.println("filename : " + filename + " size: " + size);
        long sz = Long.parseLong(size);
        int bufferSize = 512;
        byte[] buffer = new byte[bufferSize];
        int readChar = 0;
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("./root/upload/" + filename));
        while(sz > 0){
            readChar = reader.read(buffer, 0, bufferSize);
            if(readChar < 0) return;
            sz -= readChar;
            bos.write(buffer, 0, readChar);
        }
        System.out.println("here");

        bos.flush();
        bos.close();

    }

    String getQuery(String line) {

        var tokens = line.split(" ");
        if (tokens.length < 2) {
            System.out.println("====================== ");
            return "";
        } else {
            String path = tokens[1];
            path = path.replace("%20", " ");
            return path;
        }
    }

    @Override
    public void run() {
        try {
            InputStream isr = socket.getInputStream();
            String f;
            f = reader.readLine();
            System.out.println("f:" + f);
            if (f.startsWith("GET")) {
                String path = getQuery(f);
                System.out.println(path);
                if(path.length() == 0)
                    return;

                if (path.equalsIgnoreCase("/")) {
                    sendIndex();
                } else if (path.equalsIgnoreCase("/root") || path.startsWith("/root/")) {
                    File file = new File("." + path);
                    if (!file.exists()) {
                        sendError();
                    } else if (file.isDirectory()) {
                        sendDirList(file);
                    } else {
                        if (Utility.isText(file)) {
                            sendTextFile(file);
                        } else if (Utility.isImage(file))
                            sendImageFile(file);
                        else {
                            downloadFile(file);
                        }

                    }
                } else {
                    sendError();

                }
                bos.flush();

            } else if (f.startsWith("UPLOAD")) {
                String filename = getQuery(f);
                if(filename.length() == 0){
                    System.out.println("Invalid file name");
                    return;
                }
                File file = new File(filename);
                if(!(Utility.isText(file) || Utility.isImage(file))){
                    System.out.println("File Type Not Supported");
                    return;
                }
                receiveFile(filename);

            } else {
                System.out.println("UNSUPPORTED REQUEST");
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}
