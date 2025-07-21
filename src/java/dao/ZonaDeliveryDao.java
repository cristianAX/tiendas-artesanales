package dao;

import config.Conexion;
import modelo.ZonaDelivery;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ZonaDeliveryDao {

     public List<ZonaDelivery> listarActivos() {
        List<ZonaDelivery> lista = new ArrayList<>();
        String sql = "SELECT * FROM zonas_delivery WHERE activo = true";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ZonaDelivery z = new ZonaDelivery();
                z.setId(rs.getInt("id"));
                z.setDistrito(rs.getString("distrito"));
                z.setCosto(rs.getDouble("costo"));
                z.setDiasEstimados(rs.getInt("dias_estimados"));
                z.setActivo(rs.getBoolean("activo"));
                lista.add(z);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

 public ZonaDelivery obtenerPorId(int id) {
    ZonaDelivery z = null;
    String sql = "SELECT * FROM zonas_delivery WHERE id = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            z = new ZonaDelivery();
            z.setId(rs.getInt("id"));
            z.setDistrito(rs.getString("distrito")); // Cambiado aquí
            z.setCosto(rs.getDouble("costo"));
            z.setDiasEstimados(rs.getInt("dias_estimados"));
            z.setActivo(rs.getBoolean("activo")); // También lo puedes traer
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return z;
}

    
    public void guardar(ZonaDelivery z) {
        String sql = "INSERT INTO zonas_delivery (distrito, costo, dias_estimados, activo) VALUES (?, ?, ?, true)";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, z.getDistrito());
            ps.setDouble(2, z.getCosto());
            ps.setInt(3, z.getDiasEstimados());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void actualizar(ZonaDelivery z) {
        String sql = "UPDATE zonas_delivery SET distrito = ?, costo = ?, dias_estimados = ? WHERE id = ?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, z.getDistrito());
            ps.setDouble(2, z.getCosto());
            ps.setInt(3, z.getDiasEstimados());
            ps.setInt(4, z.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
  public void eliminar(int id) {
        String sql = "UPDATE zonas_delivery SET activo = false WHERE id = ?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
