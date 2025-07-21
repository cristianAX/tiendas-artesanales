package modelo;

public class ItemCarrito {

    private Producto producto;
    private VarianteProducto variante;
    private int cantidad;
    private Promocion promocion; // puede ser null

    public ItemCarrito() {
    }

    public ItemCarrito(Producto producto, VarianteProducto variante, int cantidad, Promocion promocion) {
        this.producto = producto;
        this.variante = variante;
        this.cantidad = cantidad;
        this.promocion = promocion;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public VarianteProducto getVariante() {
        return variante;
    }

    public void setVariante(VarianteProducto variante) {
        this.variante = variante;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Promocion getPromocion() {
        return promocion;
    }

    public void setPromocion(Promocion promocion) {
        this.promocion = promocion;
    }

    /**
     * Retorna el precio final unitario considerando si hay promoción.
     */
    public double getPrecioFinal() {
        if (variante == null) return 0.0;

        double precioBase = variante.getPrecioVenta();

        if (promocion != null) {
            switch (promocion.getTipo()) {
                case "porcentaje":
                    precioBase -= precioBase * (promocion.getValor() / 100.0);
                    break;
                case "precio_fijo":
                    precioBase = promocion.getValor();
                    break;
            }
        }

        // Nunca retornar precio negativo
        return Math.max(0.0, precioBase);
    }

    /**
     * Retorna el subtotal del ítem: precio final * cantidad
     */
    public double getSubtotal() {
        return getPrecioFinal() * cantidad;
    }
}
