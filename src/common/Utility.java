package common;

import java.io.*;

public class Utility {

    public static boolean sendFile(File file, BufferedOutputStream bw ) {
        try{
//            if(writeSize){
//                bw.write(file.length());
//            }
            byte[] buffer = new byte[1024];
            int n;
            BufferedInputStream br = new BufferedInputStream(new FileInputStream(file));
            while((n = br.read(buffer)) != -1){
                bw.write(buffer, 0, n);
            }
//            System.out.println("here2");
        }
        catch (IOException e){
            return false;
        }
        return true;
    }

    public static String getExtension(File file){
        int i = file.getName().lastIndexOf(".");
        if(i >= 0) return file.getName().substring(i + 1);
        return "";
    }
    public static boolean isText(File file){
        String extension = Utility.getExtension(file);
        return extension.equalsIgnoreCase("txt");

    }
    public static boolean isImage(File file){

        String extension = Utility.getExtension(file);

        return extension.equalsIgnoreCase("jpg") ||
                extension.equalsIgnoreCase("jpeg") ||
                extension.equalsIgnoreCase("png") ||
                extension.equalsIgnoreCase("svg");
    }


}
