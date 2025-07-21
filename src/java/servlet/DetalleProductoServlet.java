package servlet;

import dao.ProductoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Producto;


import java.io.IOException;

@WebServlet("/detalleProducto")
public class DetalleProductoServlet extends HttpServlet {
    ProductoDao productoDao = new ProductoDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idProducto = Integer.parseInt(request.getParameter("id"));
            Producto producto = productoDao.obtenerPorIdConVariantes(idProducto);

            // Verifica si cada variante tiene promoción activa
          
            request.setAttribute("producto", producto);
            request.getRequestDispatcher("userPage/DetalleProducto.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error en DetalleProductoServlet: " + e.getMessage(), e);
        }
    }
}
