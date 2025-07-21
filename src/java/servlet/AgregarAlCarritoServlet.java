/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.ProductoDao;
import dao.PromocionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import modelo.ItemCarrito;
import modelo.Producto;
import modelo.Promocion;
import modelo.VarianteProducto;

@WebServlet("/AgregarAlCarritoServlet")
public class AgregarAlCarritoServlet extends HttpServlet {

    private final ProductoDao productoDao = new ProductoDao();
    private final PromocionDao promocionDao = new PromocionDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int idProducto = Integer.parseInt(request.getParameter("idProducto"));
            int idVariante = Integer.parseInt(request.getParameter("idVariante"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));

            Producto producto = productoDao.obtenerPorIdConVariantes(idProducto);

            VarianteProducto variante = null;
            for (VarianteProducto v : producto.getVariantes()) {
                if (v.getId() == idVariante) {
                    variante = v;
                    break;
                }
            }

            if (variante == null) {
                throw new Exception("Variante no encontrada para el producto.");
            }

            Promocion promocion = promocionDao.obtenerPromocionActivaParaVariante(idVariante);

            ItemCarrito nuevoItem = new ItemCarrito(producto, variante, cantidad, promocion);

            HttpSession session = request.getSession();
            List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");

            if (carrito == null) {
                carrito = new ArrayList<>();
            }

            boolean yaExiste = false;
            for (ItemCarrito item : carrito) {
                if (item.getVariante().getId() == idVariante) {
                    item.setCantidad(item.getCantidad() + cantidad);
                    yaExiste = true;
                    break;
                }
            }

            if (!yaExiste) {
                carrito.add(nuevoItem);
            }

            session.setAttribute("carrito", carrito);
            response.sendRedirect("userPage/carrito.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al agregar al carrito.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}
