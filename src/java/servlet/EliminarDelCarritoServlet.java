package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import modelo.ItemCarrito;

@WebServlet(name = "EliminarDelCarritoServlet", urlPatterns = {"/EliminarDelCarritoServlet"})
public class EliminarDelCarritoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int idVariante = Integer.parseInt(request.getParameter("idVariante"));
        HttpSession session = request.getSession();
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

        carrito.removeIf(item -> item.getVariante().getId() == idVariante);

        response.sendRedirect("userPage/carrito.jsp");
    }
}
