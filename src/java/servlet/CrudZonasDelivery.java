package servlet;

import dao.ZonaDeliveryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import modelo.ZonaDelivery;

import java.io.IOException;
import java.util.List;

@WebServlet("/zonas-delivery")
public class CrudZonasDelivery extends HttpServlet {

    ZonaDeliveryDao dao = new ZonaDeliveryDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "nuevo":
                request.setAttribute("modo", "form");
                request.getRequestDispatcher("adminPage/zonaDelivery.jsp").forward(request, response);
                break;

            case "editar":
                int idEditar = Integer.parseInt(request.getParameter("id"));
                ZonaDelivery zona = dao.obtenerPorId(idEditar);
                request.setAttribute("modo", "form");
                request.setAttribute("zona", zona);
                request.getRequestDispatcher("adminPage/zonaDelivery.jsp").forward(request, response);
                break;

            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(idEliminar); // baja lógica
                response.sendRedirect("zonas-delivery");
                break;

            case "listar":
            default:
                List<ZonaDelivery> lista = dao.listarActivos();
                request.setAttribute("listaZonas", lista);
                request.getRequestDispatcher("adminPage/zonaDelivery.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String distrito = request.getParameter("distrito");
        double costo = Double.parseDouble(request.getParameter("costo"));
        int dias = Integer.parseInt(request.getParameter("diasEstimados"));

        ZonaDelivery z = new ZonaDelivery(id, distrito, costo, dias, true);

        if (id == 0) {
            dao.guardar(z);
        } else {
            dao.actualizar(z);
        }

        response.sendRedirect("zonas-delivery");
    }
}
