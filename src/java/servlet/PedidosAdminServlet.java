package servlet;

import dao.PedidoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.Pedido;

import java.io.IOException;
import java.util.List;
import modelo.DetallePedido;

@WebServlet("/pedidos")
public class PedidosAdminServlet extends HttpServlet {

    private final PedidoDao pedidoDao = new PedidoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Pedido> pedidos = pedidoDao.listarTodosConUsuario();

for (Pedido p : pedidos) {
    List<DetallePedido> detalles = pedidoDao.listarDetallePedido(p.getId());
    p.setDetalles(detalles);
}

        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("adminPage/pedidos.jsp").forward(request, response);
    }
}
