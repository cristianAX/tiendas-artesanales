package modelo;

import java.util.List;

public class Producto {
    private int id;
    private String nombre;
    private String descripcion;
    private String imagen;
    private int idCategoria;

    // Lista de variantes del producto
    private List<VarianteProducto> variantes;

    // Getters y setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getImagen() {
        return imagen;
    }
    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public int getIdCategoria() {
        return idCategoria;
    }
    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public List<VarianteProducto> getVariantes() {
        return variantes;
    }
    public void setVariantes(List<VarianteProducto> variantes) {
        this.variantes = variantes;
    }
}
