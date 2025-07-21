package servlet;

import dao.ProductoDao;
import dao.CategoriaDao;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Producto;
import modelo.Categoria;

import java.io.IOException;
import java.util.List;

@WebServlet("/productos-por-categoria")
public class ProductosPorCategoriaServlet extends HttpServlet {
    ProductoDao productoDao = new ProductoDao();
    CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("panel-cliente");
            return;
        }

        int idCategoria = Integer.parseInt(idStr);
        List<Producto> productos = productoDao.listarPorCategoria(idCategoria);
        Categoria categoria = categoriaDao.obtenerPorId(idCategoria);

        request.setAttribute("productos", productos);
        request.setAttribute("categoria", categoria);
        request.getRequestDispatcher("userPage/ProductosPorCategoria.jsp").forward(request, response);
    }
}
