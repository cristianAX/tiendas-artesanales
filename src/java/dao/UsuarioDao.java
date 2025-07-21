package dao;

import config.Conexion;
import modelo.Usuario;
import java.sql.*;

public class UsuarioDao {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public Usuario login(String correo, String password) {
        Usuario u = null;
        String sql = "SELECT * FROM usuarios WHERE correo = ? AND password = ?";
        try {
            Connection con = cn.getConexion();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setNombre(rs.getString("nombre"));
                u.setApellidos(rs.getString("apellidos"));
                u.setCorreo(rs.getString("correo"));
                u.setRol(rs.getString("rol"));  // ¡Muy importante!
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }
  public boolean registrar(Usuario u) {
    String sql = "INSERT INTO usuarios (nombre, apellidos, dni, telefono, correo, password, rol) VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (Connection con = cn.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, u.getNombre());
        ps.setString(2, u.getApellidos());
        ps.setString(3, u.getDni());
        ps.setString(4, u.getTelefono());
        ps.setString(5, u.getCorreo());
        ps.setString(6, u.getPassword());
        ps.setString(7, "user"); // Registro siempre como usuario normal

        ps.executeUpdate();
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
}
