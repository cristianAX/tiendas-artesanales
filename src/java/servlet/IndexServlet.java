package servlet;

import dao.CategoriaDao;
import dao.ProductoDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import modelo.Producto;

import java.io.IOException;
import java.util.List;
import modelo.Categoria;

@WebServlet("/inicio") // o "/index" si lo usas como inicio
public class IndexServlet extends HttpServlet {

    ProductoDao productoDao = new ProductoDao();
    CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Producto> productos = productoDao.listarSoloProductos(); // sin variantes por ahora
        List<Categoria> categorias = categoriaDao.listar();

        request.setAttribute("productos", productos);
        request.setAttribute("categorias", categorias);

        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
