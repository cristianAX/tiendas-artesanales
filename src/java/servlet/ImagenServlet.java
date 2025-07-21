package servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/imagenes/*")
public class ImagenServlet extends HttpServlet {
    private final String uploadDir = "C:/mitikas_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String archivo = request.getPathInfo().substring(1); 
        File imagen = new File(uploadDir, archivo);

        if (!imagen.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(getServletContext().getMimeType(imagen.getName()));
        response.setContentLengthLong(imagen.length());

        try (FileInputStream in = new FileInputStream(imagen);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int len;
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
            }
        }
    }
}
