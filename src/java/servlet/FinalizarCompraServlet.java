package servlet;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/FinalizarCompraServlet")
public class FinalizarCompraServlet extends HttpServlet {

    private final PedidoDao pedidoDao = new PedidoDao();
    private final VarianteDao varianteDao = new VarianteDao();
    private final TarjetaDao tarjetaDao = new TarjetaDao();
    private final CarritoDao carritoDao = new CarritoDao();
    private final ZonaDeliveryDao zonaDao = new ZonaDeliveryDao();
    private final MetodoPagoDao metodoDao = new MetodoPagoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        List<ItemCarrito> carrito = (List<ItemCarrito>) sesion.getAttribute("carrito");

        if (usuario == null || carrito == null || carrito.isEmpty()) {
            response.sendRedirect("userPage/carrito.jsp");
            return;
        }

        // Datos del formulario
        String tipoEntrega = request.getParameter("tipoEntrega");
        String direccion;
        Integer idZona = null;
        double costoDelivery = 0.0;

        if ("domicilio".equals(tipoEntrega)) {
            idZona = Integer.parseInt(request.getParameter("idZona"));
            direccion = request.getParameter("direccion");
            ZonaDelivery zona = pedidoDao.obtenerZonaPorId(idZona);
            if (zona != null) {
                costoDelivery = zona.getCosto();
            }
        } else {
            direccion = "Av. Aviación 5095, Galería Nuevo Polvos Rosados – Tienda 78 y 79";
        }

        int idMetodoPago = Integer.parseInt(request.getParameter("idMetodoPago"));

        // Total de compra
        double totalCompra = carrito.stream().mapToDouble(ItemCarrito::getSubtotal).sum() + costoDelivery;

        // Validar pago si es con tarjeta
        if (idMetodoPago == 1) {
            String numero = request.getParameter("numeroTarjeta");
            String titular = request.getParameter("nombreTitular");
            String fecha = request.getParameter("fechaExpiracion");
            String cvv = request.getParameter("cvv");

            TarjetaSimulada tarjeta = tarjetaDao.validar(numero, titular, fecha, cvv, usuario.getId());
            if (tarjeta == null || tarjeta.getSaldo() < totalCompra) {
                request.setAttribute("error", "Tarjeta inválida o saldo insuficiente.");
                request.setAttribute("zonas", zonaDao.listarActivos());
                request.setAttribute("metodosPago", metodoDao.listar());
                request.setAttribute("totalCompra", carrito.stream().mapToDouble(ItemCarrito::getSubtotal).sum());
                request.getRequestDispatcher("userPage/procesar-pago.jsp").forward(request, response);
                return;
            }
            tarjetaDao.descontarSaldo(tarjeta.getId(), totalCompra);
        }

        // Validar stock
        boolean stockSuficiente = true;
        for (ItemCarrito item : carrito) {
            int stockActual = varianteDao.obtenerStock(item.getVariante().getId());
            if (stockActual < item.getCantidad()) {
                stockSuficiente = false;
                break;
            }
        }

        // Crear y registrar pedido
        Pedido pedido = new Pedido();
        pedido.setNombre(usuario.getNombre());
        pedido.setApellido(usuario.getApellidos());
        pedido.setDireccion(direccion);
        pedido.setIdZonaDelivery(idZona);
        pedido.setProceso("solicitud_recibida");
        pedido.setIdUsuario(usuario.getId());
        pedido.setIdMetodoPago(idMetodoPago);

        
        pedido.setCostoEnvio(costoDelivery); // Con esto se guarda el costo correcto

        
        int idPedido = pedidoDao.insertarPedido(pedido);

        if (idPedido == -1) {
            request.setAttribute("error", "No se pudo registrar el pedido.");
            request.getRequestDispatcher("userPage/procesar-pago.jsp").forward(request, response);
            return;
        }

        // Insertar detalle del pedido
        for (ItemCarrito item : carrito) {
            pedidoDao.insertarDetallePedido(
                    idPedido,
                    item.getProducto().getId(),
                    item.getVariante().getId(),
                    item.getCantidad(),
                    item.getPrecioFinal(),
                    (item.getPromocion() != null) ? item.getPromocion().getId() : null
            );
        }

        // Descontar stock solo si hay suficiente
        if (stockSuficiente) {
            for (ItemCarrito item : carrito) {
                varianteDao.restarStock(item.getVariante().getId(), item.getCantidad());
            }
            pedidoDao.actualizarEstadoPedido(idPedido, "en_proceso");
        }

        // Generar comprobante
        pedidoDao.generarComprobantePDF(pedido, carrito, totalCompra, idPedido, request);

        // Vaciar carrito
        sesion.removeAttribute("carrito");
        carritoDao.eliminarCarritoPorUsuario(usuario.getId());

        // Redirigir a descarga
        response.sendRedirect("descargar-pdf?archivo=comprobante_pedido_" + idPedido + ".pdf");
    }
}
