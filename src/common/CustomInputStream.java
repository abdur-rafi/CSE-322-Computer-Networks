package common;

import java.io.IOException;
import java.io.InputStream;

public class CustomInputStream {
    private byte[] buffer;
    private InputStream is;

    public CustomInputStream(InputStream is){
        this.is = is;
    }
    public String getLine() throws IOException {
        StringBuilder s = new StringBuilder();
        int c;

        while((c = is.read()) != -1){
            if(c == 10){
                return s.toString();
            }
            s.append((char) c);
        }
        return s.toString();
    }

    public int read(byte[] buf, int offset, int len) throws IOException {
        return is.read(buf, offset, len);
    }
    public int read(byte[] buf) throws IOException {
        return is.read(buf);
    }

    public void close() throws IOException {
        is.close();
    }


    public static void main(String[] args){


    }
}
