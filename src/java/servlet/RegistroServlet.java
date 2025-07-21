/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.UsuarioDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import modelo.Usuario;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    UsuarioDao dao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        Usuario u = new Usuario();
        u.setNombre(nombre);
        u.setApellidos(apellidos);
        u.setDni(dni);
        u.setTelefono(telefono);
        u.setCorreo(correo);
        u.setPassword(password);
        u.setRol("user");

        boolean exito = dao.registrar(u);

        if (exito) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Error al registrar. ¿Ya estás registrado?");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
