// === DAO: PromocionDao.java ===
package dao;

import config.Conexion;
import modelo.Promocion;
import modelo.VarianteProducto;

import java.sql.*;
import java.util.*;

public class PromocionDao {

    public int guardar(Promocion p) {
        String sql = "INSERT INTO promociones(nombre, tipo, valor, fecha_inicio, fecha_fin) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getTipo());
            ps.setDouble(3, p.getValor());
            ps.setString(4, p.getFechaInicio());
            ps.setString(5, p.getFechaFin());
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

    public void asignarVariante(int idPromo, int idVariante) {
        String sql = "INSERT INTO promociones_variantes(id_promocion, id_variante) VALUES (?, ?)";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPromo);
            ps.setInt(2, idVariante);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Promocion> listarTodas() {
        List<Promocion> lista = new ArrayList<>();
        String sql = "SELECT * FROM promociones ORDER BY fecha_inicio DESC";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Promocion p = new Promocion();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setTipo(rs.getString("tipo"));
                p.setValor(rs.getDouble("valor"));
                p.setFechaInicio(rs.getString("fecha_inicio"));
                p.setFechaFin(rs.getString("fecha_fin"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Promocion obtenerPorId(int id) {
        Promocion p = null;
        String sql = "SELECT * FROM promociones WHERE id = ?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                p = new Promocion();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setTipo(rs.getString("tipo"));
                p.setValor(rs.getDouble("valor"));
                p.setFechaInicio(rs.getString("fecha_inicio"));
                p.setFechaFin(rs.getString("fecha_fin"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }

    public void actualizar(Promocion p) {
        String sql = "UPDATE promociones SET nombre=?, tipo=?, valor=?, fecha_inicio=?, fecha_fin=? WHERE id=?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getTipo());
            ps.setDouble(3, p.getValor());
            ps.setString(4, p.getFechaInicio());
            ps.setString(5, p.getFechaFin());
            ps.setInt(6, p.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM promociones WHERE id=?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Promocion> obtenerTodasConVariantes() {
        List<Promocion> promociones = new ArrayList<>();

        String sql = "SELECT pr.*, v.id AS variante_id, v.tamaño, v.precio_venta, "
                + "v.id_producto, p.nombre AS nombre_producto "
                + "FROM promociones pr "
                + "LEFT JOIN promociones_variantes pv ON pr.id = pv.id_promocion "
                + "LEFT JOIN variantes_producto v ON pv.id_variante = v.id "
                + "LEFT JOIN productos p ON v.id_producto = p.id "
                + "ORDER BY pr.id";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            Map<Integer, Promocion> map = new HashMap<>();

            while (rs.next()) {
                int id = rs.getInt("id");

                Promocion promo = map.get(id);
                if (promo == null) {
                    promo = new Promocion();
                    promo.setId(id);
                    promo.setNombre(rs.getString("nombre"));
                    promo.setTipo(rs.getString("tipo"));
                    promo.setValor(rs.getDouble("valor"));
                    promo.setFechaInicio(rs.getString("fecha_inicio"));
                    promo.setFechaFin(rs.getString("fecha_fin"));
                    promo.setVariantes(new ArrayList<>());
                    map.put(id, promo);
                }

                int idVar = rs.getInt("variante_id");
                if (idVar > 0) {
                    VarianteProducto v = new VarianteProducto();
                    v.setId(idVar);
                    v.setTamaño(rs.getString("tamaño"));
                    v.setPrecioVenta(rs.getDouble("precio_venta"));
                    v.setIdProducto(rs.getInt("id_producto"));
                    v.setNombreProducto(rs.getString("nombre_producto"));
                    promo.getVariantes().add(v);
                }
            }

            promociones.addAll(map.values());

        } catch (Exception e) {
            e.printStackTrace();
        }

        return promociones;
    }

    // Obtener promoción activa por ID de variante
    public Promocion obtenerPromocionActivaParaVariante(int idVariante) {
        Promocion promo = null;
        String sql = "SELECT p.* FROM promociones p " +
             "JOIN promociones_variantes pv ON pv.id_promocion = p.id " +
             "WHERE pv.id_variante = ? " +
             "AND CURRENT_DATE BETWEEN p.fecha_inicio AND p.fecha_fin " +
             "LIMIT 1";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idVariante);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                promo = new Promocion();
                promo.setId(rs.getInt("id"));
                promo.setNombre(rs.getString("nombre"));
                promo.setTipo(rs.getString("tipo"));
                promo.setValor(rs.getDouble("valor"));
                promo.setFechaInicio(rs.getString("fecha_inicio"));
                promo.setFechaFin(rs.getString("fecha_fin"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return promo;
    }
}
