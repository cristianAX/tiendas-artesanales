package servlet;

import dao.CarritoDao;
import dao.ZonaDeliveryDao;
import dao.MetodoPagoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.ItemCarrito;
import modelo.Usuario;
import modelo.ZonaDelivery;
import modelo.MetodoPago;

import java.io.IOException;
import java.util.List;

@WebServlet("/ProcesarCompraServlet")
public class ProcesarCompraServlet extends HttpServlet {

    private final CarritoDao carritoDao = new CarritoDao();
    private final ZonaDeliveryDao zonaDao = new ZonaDeliveryDao();
    private final MetodoPagoDao metodoDao = new MetodoPagoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

        if (usuario == null) {
            System.out.println("[ERROR] Usuario no logueado.");
            response.sendRedirect("login.jsp");
            return;
        }

        if (carrito == null || carrito.isEmpty()) {
            System.out.println("[INFO] Carrito vacío al procesar compra.");
            response.sendRedirect("userPage/carrito.jsp");
            return;
        }

        int idUsuario = usuario.getId();

        try {
            carritoDao.eliminarCarritoPorUsuario(idUsuario);

            for (ItemCarrito item : carrito) {
                if (item.getProducto() == null || item.getVariante() == null) {
                    System.out.println("[WARN] Ítem de carrito inválido: producto o variante nulo.");
                    continue;
                }

                int idProducto = item.getProducto().getId();
                int idVariante = item.getVariante().getId();
                int cantidad = item.getCantidad();
                Integer idPromocion = (item.getPromocion() != null) ? item.getPromocion().getId() : null;

                carritoDao.insertarRegistroCarrito(idUsuario, idProducto, idVariante, cantidad, idPromocion);
                System.out.println("[OK] Insertado producto ID: " + idProducto + ", variante ID: " + idVariante + ", cantidad: " + cantidad);
            }

            List<ZonaDelivery> zonas = zonaDao.listarActivos();
            List<MetodoPago> metodos = metodoDao.listar();

            // Calcular total considerando promociones
            double totalCompra = 0;
            for (ItemCarrito item : carrito) {
                totalCompra += item.getSubtotal(); // este ya considera promociones
            }

            request.setAttribute("zonas", zonas);
            request.setAttribute("metodosPago", metodos);
            request.setAttribute("totalCompra", totalCompra);

            request.getRequestDispatcher("userPage/procesar-pago.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[ERROR] Al procesar la compra: " + e.getMessage());
            response.sendRedirect("userPage/carrito.jsp");
        }
    }
}
