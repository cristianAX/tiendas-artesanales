package modelo;

import java.util.List;

public class Promocion {
    private int id;
    private String nombre;
    private String tipo; // "porcentaje" o "precio_fijo"
    private double valor;
    private String fechaInicio;
    private String fechaFin;
    // para poder ver variantes en la lista de promos 
    
    private List<VarianteProducto> variantes;


    // Getters y Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public double getValor() { return valor; }
    public void setValor(double valor) { this.valor = valor; }
    public String getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }
    public String getFechaFin() { return fechaFin; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }
    public List<VarianteProducto> getVariantes() {
    return variantes;
}

public void setVariantes(List<VarianteProducto> variantes) {
    this.variantes = variantes;
}
}
