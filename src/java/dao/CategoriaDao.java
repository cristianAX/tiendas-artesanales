package dao;

import config.Conexion;
import modelo.Categoria;

import java.sql.*;
import java.util.*;

public class CategoriaDao {
    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT * FROM categorias";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setId(rs.getInt("id"));
                c.setCategoria(rs.getString("categoria"));
                c.setImagen(rs.getString("imagen"));
                lista.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }
    
     public void agregar(Categoria c) {
        String sql = "INSERT INTO categorias (categoria, imagen) VALUES (?, ?)";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getCategoria());
            ps.setString(2, c.getImagen());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Categoria obtenerPorId(int id) {
        Categoria c = new Categoria();
        String sql = "SELECT * FROM categorias WHERE id = ?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                c.setId(rs.getInt("id"));
                c.setCategoria(rs.getString("categoria"));
                c.setImagen(rs.getString("imagen"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    public void actualizar(Categoria c) {
        String sql = "UPDATE categorias SET categoria = ?, imagen = ? WHERE id = ?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setString(1, c.getCategoria());
            ps.setString(2, c.getImagen());
            ps.setInt(3, c.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM categorias WHERE id = ?";
        try {
            con = cn.getConexion();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
