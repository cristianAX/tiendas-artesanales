package servlet;

import dao.CategoriaDao;
import dao.ProductoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import modelo.Categoria;

@WebServlet("/panel-cliente")
public class ClienteServlet extends HttpServlet {

    private final ProductoDao productoDao = new ProductoDao();
    private final CategoriaDao categoriaDao = new CategoriaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        List<Categoria> categorias = categoriaDao.listar();
        request.setAttribute("categorias", categorias);

        // Aquí sí se carga correctamente la lista de productos
        request.setAttribute("productos", productoDao.listarSoloProductos());

        // Redirigir al panel del cliente
        request.getRequestDispatcher("userPage/panelCliente.jsp").forward(request, response);
    }
}
