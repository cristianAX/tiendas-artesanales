package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    public static Connection getConexion() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tienda_productos_artesania",
                "demo", "demo123");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
