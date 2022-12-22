package Server.SocketServer;

import common.Utility;

import java.io.*;
import java.net.Socket;
import java.util.Date;
public class Worker extends Thread {
    private Socket socket;
    private String header;
    BufferedOutputStream bos;
    public Worker(Socket socket) throws IOException {
        this.socket = socket;
        header = "HTTP/1.1 %d %s\r\nServer: Java HTTP Server : 1.0\r\nDate: %s\r\nContent-Type: %s\r\nContent-Length: %d\r\n\r\n";
        bos = new BufferedOutputStream(socket.getOutputStream());
    }


    void sendError() throws IOException {
        File file = new File("notFound.html");
        String h = String.format(header,404, "NOT FOUND", new Date().toString(),"text/html",file.length());
        bos.write(h.getBytes());
        Utility.sendFile(file, bos);

    }
    void sendIndex() throws IOException {
        File file = new File("index.html");
        String h = String.format(header,200, "ok", new Date().toString(),"text/html",file.length());
        bos.write(h.getBytes());
//        System.out.println("here");
        Utility.sendFile(file, bos);
    }
    void sendDirList(File file) throws IOException {
        String response = HTMLBuilder.build(file);
        var b = response.getBytes();
        String h = String.format(header,200, "ok", new Date().toString(),"text/html",b.length);
        bos.write(h.getBytes());
        bos.write(b);
    }

    void sendFile(File file, String contentType) throws IOException {
        System.out.println("content type : " +  contentType);
        System.out.println("file name : " + file.getName());
        String h = String.format(header, 200, "ok", new Date().toString(), contentType, file.length());
        bos.write(h.getBytes());
        Utility.sendFile(file, bos);
    }
    void sendTextFile(File file) throws IOException {
        sendFile(file, "text/plain");
    }
    void sendImageFile(File file) throws IOException {
        String extension = Utility.getExtension(file);
        sendFile(file, "image/" + extension);
    }
    void downloadFile(File file){

    }
    @Override
    public void run() {
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            String s, f;
            f = br.readLine();
            System.out.println("f:" + f);
            StringBuilder builder = new StringBuilder(f);
            while((s = br.readLine()) != null){
                builder.append(s).append("\r\n");
                if(s.isEmpty())
                    break;
            }

            if(f.startsWith("GET")){
                var tokens = f.split(" ");
                if(tokens.length < 2){
                    System.out.println("====================== ");
                }
                else{
                    String path = tokens[1];
                    System.out.println(path);
                    path = path.replace("%20", " ");
                    System.out.println(path);
                    if(path.equalsIgnoreCase("/")){
                        sendIndex();
                    }
                    else if(path.equalsIgnoreCase("/root") || path.startsWith("/root/")){
                        File file = new File("." + path);
                        if(!file.exists()){
                            sendError();
                        }
                        else if(file.isDirectory()){
                            sendDirList(file);
                        }
                        else{
                            if(Utility.isText(file)){
                                sendTextFile(file);
                            }
                            else if(Utility.isImage(file))
                                sendImageFile(file);
                            else{
                                downloadFile(file);
                            }

                        }
                    }
                    else{
                        sendError();

                    }
                    bos.flush();
                    bos.close();

                }

            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}
