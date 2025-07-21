package dao;

import config.Conexion;
import modelo.ItemCarrito;
import modelo.Producto;
import modelo.Promocion;
import modelo.VarianteProducto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CarritoDao {

    // Listar ítems del carrito por usuario
    public List<ItemCarrito> listarPorUsuario(int idUsuario) {
        List<ItemCarrito> lista = new ArrayList<>();

        String sql = "SELECT c.*, p.nombre AS nombre_producto, p.descripcion, v.tamaño, v.precio_venta, v.stock, " +
                     "promo.id AS id_promocion, promo.nombre AS nombre_promocion, promo.tipo, promo.valor " +
                     "FROM carrito c " +
                     "JOIN productos p ON c.idProducto = p.id " +
                     "JOIN variantes_producto v ON c.idVariante = v.id " +
                     "LEFT JOIN promociones promo ON c.idPromocion = promo.id " +
                     "WHERE c.idUsuario = ?";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Producto producto = new Producto();
                producto.setId(rs.getInt("idProducto"));
                producto.setNombre(rs.getString("nombre_producto"));
                producto.setDescripcion(rs.getString("descripcion"));

                VarianteProducto variante = new VarianteProducto();
                variante.setId(rs.getInt("idVariante"));
                variante.setTamaño(rs.getString("tamaño"));
                variante.setPrecioVenta(rs.getDouble("precio_venta"));
                variante.setStock(rs.getInt("stock"));

                Promocion promocion = null;
                if (rs.getInt("id_promocion") != 0) {
                    promocion = new Promocion();
                    promocion.setId(rs.getInt("id_promocion"));
                    promocion.setNombre(rs.getString("nombre_promocion"));
                    promocion.setTipo(rs.getString("tipo"));
                    promocion.setValor(rs.getDouble("valor"));
                }

                ItemCarrito item = new ItemCarrito();
                item.setProducto(producto);
                item.setVariante(variante);
                item.setCantidad(rs.getInt("cantidad"));
                item.setPromocion(promocion);

                lista.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    // Insertar ítem en tabla carrito o actualizar si ya existe
    public void insertarRegistroCarrito(int idUsuario, int idProducto, int idVariante, int cantidad, Integer idPromocion) {
        String sql = "INSERT INTO carrito(idUsuario, idProducto, idVariante, cantidad, idPromocion) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE cantidad = VALUES(cantidad), idPromocion = VALUES(idPromocion)";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idProducto);
            ps.setInt(3, idVariante);
            ps.setInt(4, cantidad);

            if (idPromocion != null) {
                ps.setInt(5, idPromocion);
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Eliminar 1 solo ítem del carrito
    public void eliminarItem(int idUsuario, int idVariante) {
        String sql = "DELETE FROM carrito WHERE idUsuario = ? AND idVariante = ?";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.setInt(2, idVariante);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Vaciar carrito completamente para un usuario (tras finalizar compra)
    public void eliminarCarritoPorUsuario(int idUsuario) {
        String sql = "DELETE FROM carrito WHERE idUsuario = ?";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
