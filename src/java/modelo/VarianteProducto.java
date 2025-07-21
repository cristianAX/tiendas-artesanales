package modelo;

public class VarianteProducto {

    private int id;
    private int idProducto;
    private String tamaño;
    private double precioVenta;

    private String nombreProducto; 
    private boolean enPromocion;

// para ver la promo en detalle producto
    private String tipoPromocion;      // "porcentaje" o "precio_fijo"
    private double valorPromocion;     //  ejemplo: 20 (%) o 6.50 (precio fijo)
    private String nombrePromocion;    //  ejemplo: "Promo 2x1"
    private int stock;
    private boolean activo;

public boolean isActivo() {
    return activo;
}

public void setActivo(boolean activo) {
    this.activo = activo;
}


    public String getTipoPromocion() {
        return tipoPromocion;
    }

    public void setTipoPromocion(String tipoPromocion) {
        this.tipoPromocion = tipoPromocion;
    }

    public double getValorPromocion() {
        return valorPromocion;
    }

    public void setValorPromocion(double valorPromocion) {
        this.valorPromocion = valorPromocion;
    }

    public String getNombrePromocion() {
        return nombrePromocion;
    }

    public void setNombrePromocion(String nombrePromocion) {
        this.nombrePromocion = nombrePromocion;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(int idProducto) {
        this.idProducto = idProducto;
    }

    public String getTamaño() {
        return tamaño;
    }

    public void setTamaño(String tamaño) {
        this.tamaño = tamaño;
    }

    public double getPrecioVenta() {
        return precioVenta;
    }

    public void setPrecioVenta(double precioVenta) {
        this.precioVenta = precioVenta;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public boolean isEnPromocion() {
        return enPromocion;
    }

    public void setEnPromocion(boolean enPromocion) {
        this.enPromocion = enPromocion;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

}
