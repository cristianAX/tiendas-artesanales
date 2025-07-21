package dao;

import config.Conexion;
import modelo.ItemCarrito;
import modelo.Pedido;
import modelo.ZonaDelivery;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.http.HttpServletRequest;

import java.io.FileOutputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import modelo.DetallePedido;
import modelo.Producto;
import modelo.VarianteProducto;

public class PedidoDao {

    public int insertarPedido(Pedido pedido) {
        String sql = "INSERT INTO pedidos(fecha, nombre, apellido, direccion, idZonaDelivery, costo_envio, proceso, idUsuario, idMetodoPago) " +
                     "VALUES (NOW(), ?, ?, ?, ?, ?, ?, ?, ?)";
        int idPedidoGenerado = -1;

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, pedido.getNombre());
            ps.setString(2, pedido.getApellido());
            ps.setString(3, pedido.getDireccion());

            if (pedido.getIdZonaDelivery() != null) {
                ps.setInt(4, pedido.getIdZonaDelivery());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setDouble(5, pedido.getCostoEnvio());
            ps.setString(6, pedido.getProceso());
            ps.setInt(7, pedido.getIdUsuario());
            ps.setInt(8, pedido.getIdMetodoPago());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idPedidoGenerado = rs.getInt(1);
                System.out.println("Pedido insertado con ID: " + idPedidoGenerado);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return idPedidoGenerado;
    }

    public void insertarDetallePedido(int idPedido, int idProducto, int idVariante, int cantidad, double precioUnitario, Integer idPromocion) {
        String sql = "INSERT INTO detalle_pedido(idPedido, idProducto, idVariante, cantidad, precio_unitario, subtotal, estado, idPromocion) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'confirmado', ?)";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            ps.setInt(2, idProducto);
            ps.setInt(3, idVariante);
            ps.setInt(4, cantidad);
            ps.setDouble(5, precioUnitario);
            ps.setDouble(6, precioUnitario * cantidad);

            if (idPromocion != null) {
                ps.setInt(7, idPromocion);
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public ZonaDelivery obtenerZonaPorId(int idZona) {
        String sql = "SELECT * FROM zonas_delivery WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idZona);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ZonaDelivery z = new ZonaDelivery();
                z.setId(rs.getInt("id"));
                z.setDistrito(rs.getString("distrito"));
                z.setCosto(rs.getDouble("costo"));
                z.setDiasEstimados(rs.getInt("dias_estimados"));
                return z;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void generarComprobantePDF(Pedido pedido, List<ItemCarrito> carrito, double total, int idPedido, HttpServletRequest request) {
        Document document = new Document();
        try {
            if (carrito == null || carrito.isEmpty()) {
                throw new IllegalArgumentException("El carrito está vacío. No se puede generar comprobante.");
            }

            String path = request.getServletContext().getRealPath("/comprobantes");
            java.io.File carpeta = new java.io.File(path);
            if (!carpeta.exists()) {
                carpeta.mkdirs();
            }

            String archivo = path + "/comprobante_pedido_" + idPedido + ".pdf";
            PdfWriter.getInstance(document, new FileOutputStream(archivo));

            document.open();
            document.newPage();

            Font titulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
            Font subtitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.DARK_GRAY);
            Font texto = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.DARK_GRAY);
            Font bold = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.BLACK);

            Paragraph encabezado = new Paragraph("MÍTIKAS - Comprobante de Pedido", titulo);
            encabezado.setAlignment(Element.ALIGN_CENTER);
            encabezado.setSpacingAfter(12);
            document.add(encabezado);

            document.add(new Paragraph("Fecha: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")), texto));
            document.add(new Paragraph("Cliente: " + pedido.getNombre() + " " + pedido.getApellido(), texto));
            document.add(new Paragraph("Dirección: " + pedido.getDireccion(), texto));
            document.add(new Paragraph("Método de Pago: " + (pedido.getIdMetodoPago() == 1 ? "Tarjeta" : "Contraentrega"), texto));

            if (pedido.getIdZonaDelivery() != null) {
                ZonaDelivery zona = obtenerZonaPorId(pedido.getIdZonaDelivery());
                if (zona != null && zona.getDiasEstimados() > 0) {
                    document.add(new Paragraph("Entrega estimada en aproximadamente " + zona.getDiasEstimados() + " días.", texto));
                }
            }

            document.add(Chunk.NEWLINE);

            PdfPTable tabla = new PdfPTable(4);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{3, 1, 1, 1});

            PdfPCell celda;

            celda = new PdfPCell(new Phrase("Producto", bold));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);

            celda = new PdfPCell(new Phrase("Cantidad", bold));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);

            celda = new PdfPCell(new Phrase("Precio", bold));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);

            celda = new PdfPCell(new Phrase("Subtotal", bold));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);

            for (ItemCarrito item : carrito) {
                tabla.addCell(new Phrase(item.getProducto().getNombre() + " - " + item.getVariante().getTamaño(), texto));
                tabla.addCell(new Phrase(String.valueOf(item.getCantidad()), texto));
                tabla.addCell(new Phrase(String.format("S/. %.2f", item.getPrecioFinal()), texto));
                tabla.addCell(new Phrase(String.format("S/. %.2f", item.getSubtotal()), texto));
            }

            double subtotal = carrito.stream().mapToDouble(ItemCarrito::getSubtotal).sum();
            double envio = total - subtotal;

            PdfPCell celdaEnvio = new PdfPCell(new Phrase("Envío", bold));
            celdaEnvio.setColspan(3);
            celdaEnvio.setHorizontalAlignment(Element.ALIGN_RIGHT);
            tabla.addCell(celdaEnvio);
            tabla.addCell(new Phrase(String.format("S/. %.2f", envio), texto));

            PdfPCell celdaTotal = new PdfPCell(new Phrase("Total", bold));
            celdaTotal.setColspan(3);
            celdaTotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
            tabla.addCell(celdaTotal);
            tabla.addCell(new Phrase(String.format("S/. %.2f", total), bold));

            document.add(tabla);

            document.add(Chunk.NEWLINE);
            Paragraph gracias = new Paragraph("Gracias por su compra en MÍTIKAS", texto);
            gracias.setAlignment(Element.ALIGN_CENTER);
            document.add(gracias);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            document.close();
        }
    }



    public void actualizarEstadoPedido(int idPedido, String nuevoEstado) {
        String sql = "UPDATE pedidos SET proceso = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPedido);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<Pedido> listarTodosConUsuario() {
    List<Pedido> lista = new ArrayList<>();
    String sql = "SELECT p.*, u.nombre AS nombreUsuario, u.apellidos AS apellidosUsuario " +
                 "FROM pedidos p " +
                 "JOIN usuarios u ON p.idUsuario = u.id " +
                 "ORDER BY p.fecha DESC";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Pedido p = new Pedido();
            p.setId(rs.getInt("id"));
p.setFecha(rs.getTimestamp("fecha").toString());
            p.setNombre(rs.getString("nombre"));
            p.setApellido(rs.getString("apellido"));
            p.setDireccion(rs.getString("direccion"));
            p.setIdZonaDelivery(rs.getObject("idZonaDelivery") != null ? rs.getInt("idZonaDelivery") : null);
            p.setCostoEnvio(rs.getDouble("costo_envio"));
            p.setProceso(rs.getString("proceso"));
            p.setIdUsuario(rs.getInt("idUsuario"));
            p.setIdMetodoPago(rs.getInt("idMetodoPago"));

      
            lista.add(p);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return lista;
}
    public List<DetallePedido> listarDetallePedido(int idPedido) {
    List<DetallePedido> lista = new ArrayList<>();

 String sql = "SELECT dp.*, p.nombre AS nombreProducto, vp.tamaño " +
             "FROM detalle_pedido dp " +
             "JOIN productos p ON dp.idProducto = p.id " +
             "JOIN variantes_producto vp ON dp.idVariante = vp.id " +
             "WHERE dp.idPedido = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idPedido);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            DetallePedido detalle = new DetallePedido();
            detalle.setId(rs.getInt("id"));
            detalle.setCantidad(rs.getInt("cantidad"));
            detalle.setPrecioUnitario(rs.getDouble("precio_unitario"));
            detalle.setSubtotal(rs.getDouble("subtotal"));

            Producto producto = new Producto();
            producto.setNombre(rs.getString("nombreProducto"));

            VarianteProducto variante = new VarianteProducto();
            variante.setTamaño(rs.getString("tamaño"));

            detalle.setProducto(producto);
            detalle.setVariante(variante);

            lista.add(detalle);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return lista;
}

public List<Pedido> listarPedidosPorUsuario(int idUsuario) {
    List<Pedido> lista = new ArrayList<>();
    String sql = "SELECT * FROM pedidos WHERE idUsuario = ? ORDER BY fecha DESC";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idUsuario);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Pedido p = new Pedido();
            p.setId(rs.getInt("id"));
            p.setFecha(rs.getTimestamp("fecha").toString());
            p.setNombre(rs.getString("nombre"));
            p.setApellido(rs.getString("apellido"));
            p.setDireccion(rs.getString("direccion"));
            p.setIdZonaDelivery(rs.getObject("idZonaDelivery") != null ? rs.getInt("idZonaDelivery") : null);
            p.setCostoEnvio(rs.getDouble("costo_envio"));
            p.setProceso(rs.getString("proceso"));
            p.setIdUsuario(rs.getInt("idUsuario"));
            p.setIdMetodoPago(rs.getInt("idMetodoPago"));

            lista.add(p);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return lista;
}

}
