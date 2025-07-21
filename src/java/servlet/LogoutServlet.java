package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cerrar la sesión actual
        HttpSession session = request.getSession(false); 
        if (session != null) {
            session.invalidate(); // Elimina todos los atributos de sesión
        }

        // Redirigir al inicio público
        response.sendRedirect(request.getContextPath() + "/inicio");
    }
}
