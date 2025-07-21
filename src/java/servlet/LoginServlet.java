package servlet;

import dao.UsuarioDao;
import dao.CarritoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import modelo.ItemCarrito;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    UsuarioDao dao = new UsuarioDao();
    CarritoDao carritoDao = new CarritoDao(); // ✅ Se declara aquí

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        Usuario usuario = dao.login(correo, password);

        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);
            List<ItemCarrito> carrito = carritoDao.listarPorUsuario(usuario.getId());
            session.setAttribute("carrito", carrito);

            if ("admin".equals(usuario.getRol())) {
                response.sendRedirect("adminPage/panelAdmin.jsp");
            } else if ("user".equals(usuario.getRol())) {
                response.sendRedirect("panel-cliente");
            } else {
                request.setAttribute("error", "Rol no válido.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("error", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
