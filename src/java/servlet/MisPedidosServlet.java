/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.PedidoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import modelo.DetallePedido;
import modelo.Pedido;
import modelo.Usuario;

@WebServlet("/mis-pedidos")
public class MisPedidosServlet extends HttpServlet {

    private final PedidoDao pedidoDao = new PedidoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Pedido> pedidos = pedidoDao.listarPedidosPorUsuario(usuario.getId());

        // Cargar detalles de cada pedido
        for (Pedido p : pedidos) {
            List<DetallePedido> detalles = pedidoDao.listarDetallePedido(p.getId());
            p.setDetalles(detalles);
        }

        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("userPage/misPedidos.jsp").forward(request, response);
    }
}
