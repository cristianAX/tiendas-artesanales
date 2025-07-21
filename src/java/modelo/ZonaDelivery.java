package modelo;

public class ZonaDelivery {

    private int id;
    private String distrito;
    private double costo;
    private int diasEstimados;
    private boolean activo;

    public ZonaDelivery() {}

    public ZonaDelivery(int id, String distrito, double costo, int diasEstimados, boolean activo) {
        this.id = id;
        this.distrito = distrito;
        this.costo = costo;
        this.diasEstimados = diasEstimados;
        this.activo = activo;

    }

    // Getters y setters

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDistrito() {
        return distrito;
    }

    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }

    public int getDiasEstimados() {
        return diasEstimados;
    }

    public void setDiasEstimados(int diasEstimados) {
        this.diasEstimados = diasEstimados;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }
    
}
