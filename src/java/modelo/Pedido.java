package modelo;

import java.util.List;

public class Pedido {

    private int id;
    private String fecha;
    private String nombre;
    private String apellido;
    private String direccion;
    private Integer idZonaDelivery;  // Puede ser null (ej: entrega en local)
    private double costoEnvio;       // NUEVO: para registrar el costo de delivery
    private String proceso;
    private int idUsuario;
    private int idMetodoPago;
    private List<DetallePedido> detalles;

    public Pedido() {
    }

    public Pedido(String nombre, String apellido, String direccion, Integer idZonaDelivery, double costoEnvio, int idUsuario, int idMetodoPago) {
        this.nombre = nombre;
        this.apellido = apellido;
        this.direccion = direccion;
        this.idZonaDelivery = idZonaDelivery;
        this.costoEnvio = costoEnvio;
        this.idUsuario = idUsuario;
        this.idMetodoPago = idMetodoPago;
    }

    // Getters y setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellido() {
        return apellido;
    }

    public void setApellido(String apellido) {
        this.apellido = apellido;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Integer getIdZonaDelivery() {
        return idZonaDelivery;
    }

    public void setIdZonaDelivery(Integer idZonaDelivery) {
        this.idZonaDelivery = idZonaDelivery;
    }

    public double getCostoEnvio() {
        return costoEnvio;
    }

    public void setCostoEnvio(double costoEnvio) {
        this.costoEnvio = costoEnvio;
    }

    public String getProceso() {
        return proceso;
    }

    public void setProceso(String proceso) {
        this.proceso = proceso;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdMetodoPago() {
        return idMetodoPago;
    }

    public void setIdMetodoPago(int idMetodoPago) {
        this.idMetodoPago = idMetodoPago;
    }

    public List<DetallePedido> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetallePedido> detalles) {
        this.detalles = detalles;
    }

}
