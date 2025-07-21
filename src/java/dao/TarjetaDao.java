package dao;

import config.Conexion;
import modelo.TarjetaSimulada;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TarjetaDao {

    // Validar tarjeta: número, titular, fecha, cvv, y que pertenezca al usuario
    public TarjetaSimulada validar(String numero, String titular, String fechaExp, String cvv, int idUsuario) {
        String sql = "SELECT * FROM tarjetas_simuladas WHERE numero_tarjeta = ? AND nombre_titular = ? " +
                     "AND fecha_expiracion = ? AND cvv = ? AND idUsuario = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numero);
            ps.setString(2, titular);
            ps.setString(3, fechaExp);
            ps.setString(4, cvv);
            ps.setInt(5, idUsuario);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TarjetaSimulada tarjeta = new TarjetaSimulada();
                tarjeta.setId(rs.getInt("id"));
                tarjeta.setNumero(rs.getString("numero_tarjeta"));
                tarjeta.setNombreTitular(rs.getString("nombre_titular"));
                tarjeta.setFechaExpiracion(rs.getString("fecha_expiracion"));
                tarjeta.setCvv(rs.getString("cvv"));
                tarjeta.setSaldo(rs.getDouble("saldo"));
                tarjeta.setIdUsuario(rs.getInt("idUsuario"));
                return tarjeta;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Descontar saldo de tarjeta
    public void descontarSaldo(int idTarjeta, double monto) {
        String sql = "UPDATE tarjetas_simuladas SET saldo = saldo - ? WHERE id = ?";
        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, monto);
            ps.setInt(2, idTarjeta);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
