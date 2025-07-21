package servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.ItemCarrito;

import java.io.IOException;
import java.util.List;

@WebServlet("/ActualizarCantidadServlet")
public class ActualizarCantidadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int idVariante = Integer.parseInt(request.getParameter("idVariante"));
        int cantidad = Integer.parseInt(request.getParameter("cantidad"));

        HttpSession session = request.getSession();
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

        for (ItemCarrito item : carrito) {
            if (item.getVariante().getId() == idVariante) {
                item.setCantidad(cantidad);
                break;
            }
        }

        response.sendRedirect("userPage/carrito.jsp");
    }
}
