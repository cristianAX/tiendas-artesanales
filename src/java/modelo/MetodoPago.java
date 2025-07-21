package modelo;

public class MetodoPago {
    private int id;
    private String metodo;

    public MetodoPago() {}

    public MetodoPago(int id, String metodo) {
        this.id = id;
        this.metodo = metodo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMetodo() {
        return metodo;
    }

    public void setMetodo(String metodo) {
        this.metodo = metodo;
    }
}
