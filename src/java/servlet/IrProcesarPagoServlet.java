package servlet;

import dao.CarritoDao;
import dao.MetodoPagoDao;
import dao.ZonaDeliveryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/procesar-pago")
public class IrProcesarPagoServlet extends HttpServlet {

    private final ZonaDeliveryDao zonaDao = new ZonaDeliveryDao();
    private final MetodoPagoDao metodoDao = new MetodoPagoDao();
    private final CarritoDao carritoDao = new CarritoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<ZonaDelivery> zonas = zonaDao.listarActivos();
        List<MetodoPago> metodos = metodoDao.listar();

        @SuppressWarnings("unchecked")
        List<ItemCarrito> carrito = (List<ItemCarrito>) sesion.getAttribute("carrito");

        double totalCompra = 0.0;
        if (carrito != null) {
            totalCompra = carrito.stream().mapToDouble(ItemCarrito::getSubtotal).sum();
        }

        request.setAttribute("zonas", zonas);
        request.setAttribute("metodosPago", metodos);
        request.setAttribute("totalCompra", totalCompra);

        request.getRequestDispatcher("userPage/procesar-pago.jsp").forward(request, response);
    }
}
