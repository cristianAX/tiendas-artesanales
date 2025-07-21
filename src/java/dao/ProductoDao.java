package dao;

import config.Conexion;
import modelo.Producto;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import modelo.Promocion;
import modelo.VarianteProducto;

public class ProductoDao {

    Conexion cn = new Conexion();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    public Producto obtenerPorIdConVariantes(int id) {
        Producto p = null;
        String sqlProducto = "SELECT * FROM productos WHERE id = ? AND activo = true";
        String sqlVariantes = "SELECT v.*, pr.tipo AS tipo_promocion, pr.valor AS valor_promocion, pr.nombre AS nombre_promocion "
                + "FROM variantes_producto v "
                + "LEFT JOIN promociones_variantes pv ON v.id = pv.id_variante "
                + "LEFT JOIN promociones pr ON pv.id_promocion = pr.id AND CURDATE() BETWEEN pr.fecha_inicio AND pr.fecha_fin "
                + "WHERE v.id_producto = ? AND v.activo = true";

        try (Connection con = Conexion.getConexion()) {
            PreparedStatement ps = con.prepareStatement(sqlProducto);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagen(rs.getString("imagen"));

                // Obtener variantes
                PreparedStatement psVar = con.prepareStatement(sqlVariantes);
                psVar.setInt(1, id);
                ResultSet rsVar = psVar.executeQuery();
                List<VarianteProducto> variantes = new ArrayList<>();
                while (rsVar.next()) {
                    VarianteProducto v = new VarianteProducto();
                    v.setId(rsVar.getInt("id"));
                    v.setTamaño(rsVar.getString("tamaño"));
                    v.setPrecioVenta(rsVar.getDouble("precio_venta"));
                    v.setStock(rsVar.getInt("stock"));

                    String tipoPromo = rsVar.getString("tipo_promocion");
                    if (tipoPromo != null) {
                        v.setEnPromocion(true);
                        v.setTipoPromocion(tipoPromo);
                        v.setValorPromocion(rsVar.getDouble("valor_promocion"));
                        v.setNombrePromocion(rsVar.getString("nombre_promocion"));
                    } else {
                        v.setEnPromocion(false);
                    }

                    variantes.add(v);
                }
                p.setVariantes(variantes);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    /**
     *
     *
     * public Producto obtenerPorIdConVariantes(int id) { Producto p = null;
     * String sqlProducto = "SELECT * FROM productos WHERE id = ?"; String
     * sqlVariantes = "SELECT * FROM variantes_producto WHERE id_producto = ?";
     *
     * try (Connection con = Conexion.getConexion()) { PreparedStatement ps =
     * con.prepareStatement(sqlProducto); ps.setInt(1, id); ResultSet rs =
     * ps.executeQuery();
     *
     * if (rs.next()) { p = new Producto(); p.setId(rs.getInt("id"));
     * p.setNombre(rs.getString("nombre"));
     * p.setDescripcion(rs.getString("descripcion"));
     * p.setImagen(rs.getString("imagen"));
     *
     * // Obtener variantes PreparedStatement psVar =
     * con.prepareStatement(sqlVariantes); psVar.setInt(1, id); ResultSet rsVar
     * = psVar.executeQuery(); List<VarianteProducto> variantes = new
     * ArrayList<>(); while (rsVar.next()) { VarianteProducto v = new
     * VarianteProducto(); v.setId(rsVar.getInt("id"));
     * v.setTamaño(rsVar.getString("tamaño"));
     * v.setPrecioVenta(rsVar.getDouble("precio_venta"));
     * v.setStock(rsVar.getInt("stock")); variantes.add(v); }
     * p.setVariantes(variantes); }
     *
     * } catch (Exception e) { e.printStackTrace(); }
     *
     * return p; }
     *
     */
    public List<Producto> listarSoloProductos() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE activo = true";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagen(rs.getString("imagen"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Producto> listarPorCategoria(int idCategoria) {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE idCategoria = ? AND activo = true";

        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCategoria);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Producto p = new Producto();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setImagen(rs.getString("imagen"));
                p.setIdCategoria(rs.getInt("idCategoria"));
                lista.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int guardar(Producto p) {
        int idGenerado = -1;
        String sql = "INSERT INTO productos(nombre, descripcion, imagen, idCategoria) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setString(3, p.getImagen());
            ps.setInt(4, p.getIdCategoria());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                idGenerado = rs.getInt(1);  // retorna el ID generado
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return idGenerado;
    }

    public void actualizar(Producto producto) {
        String sql = "UPDATE productos SET nombre = ?, descripcion = ?, imagen = ?, idCategoria = ? WHERE id = ?";

        try (Connection con = Conexion.getConexion()) {

            // ✅ 0. Verificar si el producto está activo
            String validarSql = "SELECT activo FROM productos WHERE id = ?";
            try (PreparedStatement psValidar = con.prepareStatement(validarSql)) {
                psValidar.setInt(1, producto.getId());
                ResultSet rsVal = psValidar.executeQuery();
                if (rsVal.next() && !rsVal.getBoolean("activo")) {
                    // El producto está inactivo, no se actualiza
                    return;
                }
            }

            // 1. Actualizar producto
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, producto.getNombre());
                ps.setString(2, producto.getDescripcion());
                ps.setString(3, producto.getImagen());
                ps.setInt(4, producto.getIdCategoria());
                ps.setInt(5, producto.getId());
                ps.executeUpdate();
            }

            // 2. Obtener promociones asociadas por tamaño
            Map<String, List<Integer>> promocionesPorTamaño = new HashMap<>();
            String sqlPromos = "SELECT pv.id_promocion, vp.tamaño FROM promociones_variantes pv "
                    + "JOIN variantes_producto vp ON pv.id_variante = vp.id "
                    + "WHERE vp.id_producto = ?";
            try (PreparedStatement psPromo = con.prepareStatement(sqlPromos)) {
                psPromo.setInt(1, producto.getId());
                ResultSet rsPromo = psPromo.executeQuery();
                while (rsPromo.next()) {
                    String tamaño = rsPromo.getString("tamaño");
                    int idPromo = rsPromo.getInt("id_promocion");
                    promocionesPorTamaño.computeIfAbsent(tamaño, k -> new ArrayList<>()).add(idPromo);
                }
            }

            // 3. Eliminar relaciones promociones-variantes
            String deleteRelaciones = "DELETE FROM promociones_variantes WHERE id_variante IN (SELECT id FROM variantes_producto WHERE id_producto = ?)";
            try (PreparedStatement psDeleteRel = con.prepareStatement(deleteRelaciones)) {
                psDeleteRel.setInt(1, producto.getId());
                psDeleteRel.executeUpdate();
            }

            Set<Integer> variantesProtegidas = new HashSet<>(); // vacío

            // 5. Actualizar, insertar o eliminar variantes según el caso
// 5. Actualizar, insertar o eliminar variantes según el caso
            VarianteDao varianteDao = new VarianteDao();
            List<VarianteProducto> actuales = varianteDao.listarPorProducto(producto.getId());

// Crear mapa con tamaños estandarizados
            Map<String, VarianteProducto> mapaActuales = new HashMap<>();
            for (VarianteProducto v : actuales) {
                mapaActuales.put(v.getTamaño().trim().toLowerCase(), v);
            }

// 🔄 ELIMINAR LAS QUE YA NO ESTÁN EN EL FORMULARIO
            Set<String> tamañosNuevos = new HashSet<>();
            for (VarianteProducto v : producto.getVariantes()) {
                tamañosNuevos.add(v.getTamaño().trim().toLowerCase());
            }

            for (VarianteProducto vExistente : actuales) {
                String tamañoExistente = vExistente.getTamaño().trim().toLowerCase();
                if (!tamañosNuevos.contains(tamañoExistente)) {
                    if (!variantesProtegidas.contains(vExistente.getId())) {
                        System.out.println("Eliminando variante con tamaño: " + tamañoExistente + " ID: " + vExistente.getId());
                        varianteDao.eliminar(vExistente.getId());
                    }
                }
            }

// ⏩ Insertar/actualizar las que sí están
            List<Integer> nuevasVarianteIds = new ArrayList<>();
            List<String> tamañosInsertados = new ArrayList<>();

            for (VarianteProducto v : producto.getVariantes()) {
                String tamañoEstandar = v.getTamaño().trim().toLowerCase();
                VarianteProducto existente = mapaActuales.get(tamañoEstandar);

                if (existente != null) {
                    v.setId(existente.getId());

                    if (variantesProtegidas.contains(v.getId())) {
                        varianteDao.actualizar(v); // Solo stock/precio
                    } else {
                        varianteDao.eliminar(v.getId());
                        v.setIdProducto(producto.getId());
                        v.setActivo(true);
                        int nuevoId = varianteDao.guardarYRetornarID(v);
                        v.setId(nuevoId);
                    }
                } else {
                    v.setIdProducto(producto.getId());
                    v.setActivo(true);
                    int nuevoId = varianteDao.guardarYRetornarID(v);
                    v.setId(nuevoId);
                }

                nuevasVarianteIds.add(v.getId());
                tamañosInsertados.add(tamañoEstandar);
            }

            // 6. Volver a asociar promociones según tamaño
            String insertRelacion = "INSERT INTO promociones_variantes (id_promocion, id_variante) VALUES (?, ?)";
            try (PreparedStatement psAsociar = con.prepareStatement(insertRelacion)) {
                for (int i = 0; i < nuevasVarianteIds.size(); i++) {
                    String tamañoNuevo = tamañosInsertados.get(i);
                    int idVar = nuevasVarianteIds.get(i);

                    if (promocionesPorTamaño.containsKey(tamañoNuevo)) {
                        for (Integer idPromo : promocionesPorTamaño.get(tamañoNuevo)) {
                            psAsociar.setInt(1, idPromo);
                            psAsociar.setInt(2, idVar);
                            psAsociar.addBatch();
                        }
                    }
                }
                psAsociar.executeBatch();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * public void actualizar(Producto producto) { String sql = "UPDATE
     * productos SET nombre = ?, descripcion = ?, imagen = ?, idCategoria = ?
     * WHERE id = ?";
     *
     * try (Connection con = Conexion.getConexion(); PreparedStatement ps =
     * con.prepareStatement(sql)) {
     *
     * ps.setString(1, producto.getNombre()); ps.setString(2,
     * producto.getDescripcion()); ps.setString(3, producto.getImagen());
     * ps.setInt(4, producto.getIdCategoria()); ps.setInt(5, producto.getId());
     * ps.executeUpdate();
     *
     * // 🟡 1. Guardar promociones asociadas a cada tamaño de variante
     * Map<String, List<Integer>> promocionesPorTamaño = new HashMap<>(); String
     * sqlPromos = "SELECT pv.id_promocion, vp.tamaño FROM promociones_variantes
     * pv " + "JOIN variantes_producto vp ON pv.id_variante = vp.id " + "WHERE
     * vp.id_producto = ?"; try (PreparedStatement psPromo =
     * con.prepareStatement(sqlPromos)) { psPromo.setInt(1, producto.getId());
     * ResultSet rsPromo = psPromo.executeQuery(); while (rsPromo.next()) {
     * String tamaño = rsPromo.getString("tamaño"); int idPromo =
     * rsPromo.getInt("id_promocion");
     *
     * promocionesPorTamaño .computeIfAbsent(tamaño, k -> new ArrayList<>())
     * .add(idPromo); } }
     *
     * // 🟠 2. Eliminar relaciones promociones-variantes String
     * deleteRelaciones = "DELETE FROM promociones_variantes WHERE id_variante
     * IN (SELECT id FROM variantes_producto WHERE id_producto = ?)"; try
     * (PreparedStatement psDeleteRel = con.prepareStatement(deleteRelaciones))
     * { psDeleteRel.setInt(1, producto.getId()); psDeleteRel.executeUpdate(); }
     *
     * // 🔴 3. Eliminar variantes anteriores String deleteSql = "DELETE FROM
     * variantes_producto WHERE id_producto = ?"; try (PreparedStatement
     * psDelete = con.prepareStatement(deleteSql)) { psDelete.setInt(1,
     * producto.getId()); psDelete.executeUpdate(); }
     *
     * // 🟢 4. Insertar nuevas variantes String insertSql = "INSERT INTO
     * variantes_producto (id_producto, tamaño, precio_venta, stock) VALUES (?,
     * ?, ?,?)"; List<Integer> nuevasVarianteIds = new ArrayList<>();
     * List<String> tamañosInsertados = new ArrayList<>();
     *
     * try (PreparedStatement psInsert = con.prepareStatement(insertSql,
     * Statement.RETURN_GENERATED_KEYS)) { for (VarianteProducto v :
     * producto.getVariantes()) { psInsert.setInt(1, producto.getId());
     * psInsert.setString(2, v.getTamaño()); psInsert.setDouble(3,
     * v.getPrecioVenta()); psInsert.setInt(4, v.getStock());
     *
     * psInsert.executeUpdate();
     *
     * ResultSet rs = psInsert.getGeneratedKeys(); if (rs.next()) {
     * nuevasVarianteIds.add(rs.getInt(1));
     * tamañosInsertados.add(v.getTamaño()); } } }
     *
     * // 🔵 5. Volver a asociar SOLO promociones del mismo tamaño String
     * insertRelacion = "INSERT INTO promociones_variantes (id_promocion,
     * id_variante) VALUES (?, ?)"; try (PreparedStatement psAsociar =
     * con.prepareStatement(insertRelacion)) { for (int i = 0; i <
     * nuevasVarianteIds.size(); i++) { String tamañoNuevo =
     * tamañosInsertados.get(i); int idVar = nuevasVarianteIds.get(i);
     *
     * if (promocionesPorTamaño.containsKey(tamañoNuevo)) { for (Integer idPromo
     * : promocionesPorTamaño.get(tamañoNuevo)) { psAsociar.setInt(1, idPromo);
     * psAsociar.setInt(2, idVar); psAsociar.addBatch(); } } }
     * psAsociar.executeBatch(); }
     *
     * } catch (Exception e) { e.printStackTrace(); } }
*
     */
    public void eliminar(int idProducto) {
        String sqlVar = "UPDATE variantes_producto SET activo = false WHERE id_producto = ?";
        String sqlProd = "UPDATE productos SET activo = false WHERE id = ?";

        try (Connection con = Conexion.getConexion()) {
            PreparedStatement ps1 = con.prepareStatement(sqlVar);
            ps1.setInt(1, idProducto);
            ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement(sqlProd);
            ps2.setInt(1, idProducto);
            ps2.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
