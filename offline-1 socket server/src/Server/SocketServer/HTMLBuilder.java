package Server.SocketServer;

import java.io.File;

public class HTMLBuilder {
    public static String build(File src){
        StringBuilder html = new StringBuilder("<html><head></head><body>");
        if(src.isDirectory()){
            var ls = src.list();
            html.append("<ul>");
            if(ls != null){
                for(var f : ls){
                    if(new File(src.getPath() + "/" + f).isDirectory())
                        html.append(String.format("<li style=\"font-style:italic;font-weight:bold;\"><a href=\"/%s\"> %s </a> </li>", src.getPath() + "/" + f, f));
                    else
                        html.append(String.format("<li><a target = '_blank'  href='/%s'> %s </a> </li>",src.getPath() + "/" + f, f));
                }
            }
        }
        html.append("</body></html>");
        return html.toString();
    }
}
