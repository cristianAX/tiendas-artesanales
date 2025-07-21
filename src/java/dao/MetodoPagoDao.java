package dao;

import config.Conexion;
import modelo.MetodoPago;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MetodoPagoDao {

    public List<MetodoPago> listar() {
        List<MetodoPago> lista = new ArrayList<>();
        String sql = "SELECT * FROM metodosPago";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MetodoPago m = new MetodoPago();
                m.setId(rs.getInt("id"));
                m.setMetodo(rs.getString("metodo"));
                lista.add(m);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
}
