package dao;

import config.Conexion;
import modelo.VarianteProducto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VarianteDao {

    public List<VarianteProducto> listarPorProducto(int idProducto) {
        List<VarianteProducto> lista = new ArrayList<>();
        String sql = "SELECT * FROM variantes_producto WHERE id_producto = ? AND activo = true";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VarianteProducto v = new VarianteProducto();
                    v.setId(rs.getInt("id"));
                    v.setIdProducto(rs.getInt("id_producto"));
                    v.setTamaño(rs.getString("tamaño"));
                    v.setPrecioVenta(rs.getDouble("precio_venta"));
                    v.setStock(rs.getInt("stock"));
                    v.setActivo(rs.getBoolean("activo"));
                    lista.add(v);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<VarianteProducto> obtenerTodas() {
        List<VarianteProducto> lista = new ArrayList<>();
        String sql =
            "SELECT v.*, p.nombre AS nombre_producto, " +
            "       EXISTS ( " +
            "           SELECT 1 FROM promociones_variantes pv " +
            "           INNER JOIN promociones promo ON promo.id = pv.id_promocion " +
            "           WHERE pv.id_variante = v.id " +
            "             AND CURDATE() BETWEEN promo.fecha_inicio AND promo.fecha_fin " +
            "       ) AS en_promocion " +
            "FROM variantes_producto v " +
            "JOIN productos p ON v.id_producto = p.id " +
            "WHERE v.activo = true";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                VarianteProducto v = new VarianteProducto();
                v.setId(rs.getInt("id"));
                v.setIdProducto(rs.getInt("id_producto"));
                v.setTamaño(rs.getString("tamaño"));
                v.setPrecioVenta(rs.getDouble("precio_venta"));
                v.setStock(rs.getInt("stock"));
                v.setEnPromocion(rs.getBoolean("en_promocion"));
                v.setNombreProducto(rs.getString("nombre_producto"));
                v.setActivo(rs.getBoolean("activo"));
                lista.add(v);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public void guardar(VarianteProducto v) {
        String sql = "INSERT INTO variantes_producto(id_producto, tamaño, precio_venta, stock, activo) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, v.getIdProducto());
            ps.setString(2, v.getTamaño());
            ps.setDouble(3, v.getPrecioVenta());
            ps.setInt(4, v.getStock());
            ps.setBoolean(5, true); // siempre activa

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int guardarYRetornarID(VarianteProducto v) {
        String sql = "INSERT INTO variantes_producto(id_producto, tamaño, precio_venta, stock, activo) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, v.getIdProducto());
            ps.setString(2, v.getTamaño());
            ps.setDouble(3, v.getPrecioVenta());
            ps.setInt(4, v.getStock());
            ps.setBoolean(5, true); // siempre activa

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public void actualizar(VarianteProducto v) {
        String sql = "UPDATE variantes_producto SET precio_venta = ?, stock = ?, activo = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, v.getPrecioVenta());
            ps.setInt(2, v.getStock());
            ps.setBoolean(3, v.isActivo());
            ps.setInt(4, v.getId());
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void eliminar(int idVariante) {
        String sql = "UPDATE variantes_producto SET activo = false WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVariante);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void eliminarPorProducto(int idProducto) {
        String sql = "UPDATE variantes_producto SET activo = false WHERE id_producto = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean validarStock(int idVariante, int cantidad) {
        String sql = "SELECT stock FROM variantes_producto WHERE id = ? AND activo = true";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVariante);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int stockActual = rs.getInt("stock");
                return stockActual >= cantidad;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int obtenerStock(int idVariante) {
        String sql = "SELECT stock FROM variantes_producto WHERE id = ? AND activo = true";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idVariante);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void restarStock(int idVariante, int cantidad) {
        String sql = "UPDATE variantes_producto SET stock = stock - ? WHERE id = ? AND activo = true";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cantidad);
            ps.setInt(2, idVariante);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
