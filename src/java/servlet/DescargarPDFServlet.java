package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/descargar-pdf")
public class DescargarPDFServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String archivo = request.getParameter("archivo");

        if (archivo == null || archivo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nombre de archivo no especificado.");
            return;
        }

        String ruta = getServletContext().getRealPath("/comprobantes/" + archivo);
        File file = new File(ruta);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Archivo no encontrado.");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=" + archivo);
        response.setContentLength((int) file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }

        }
    }
}
