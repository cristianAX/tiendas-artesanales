package modelo;

public class TarjetaSimulada {

    private int id;
    private String numero;
    private String nombreTitular;
    private String fechaExpiracion;
    private String cvv;
    private double saldo;
    private int idUsuario;

    public TarjetaSimulada() {
    }

    public TarjetaSimulada(int id, String numero, String nombreTitular, String fechaExpiracion, String cvv, double saldo, int idUsuario) {
        this.id = id;
        this.numero = numero;
        this.nombreTitular = nombreTitular;
        this.fechaExpiracion = fechaExpiracion;
        this.cvv = cvv;
        this.saldo = saldo;
        this.idUsuario = idUsuario;
    }

    // Getters y Setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getNombreTitular() {
        return nombreTitular;
    }

    public void setNombreTitular(String nombreTitular) {
        this.nombreTitular = nombreTitular;
    }

    public String getFechaExpiracion() {
        return fechaExpiracion;
    }

    public void setFechaExpiracion(String fechaExpiracion) {
        this.fechaExpiracion = fechaExpiracion;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }
}
