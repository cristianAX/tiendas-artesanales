package servlet;

import dao.PromocionDao;
import dao.VarianteDao;
import modelo.Promocion;
import modelo.VarianteProducto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/crud-promociones")
public class CrudPromociones extends HttpServlet {
    PromocionDao promocionDao = new PromocionDao();
    VarianteDao varianteDao = new VarianteDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        if (accion == null || accion.equals("listar")) {
List<Promocion> promociones = promocionDao.obtenerTodasConVariantes();
            req.setAttribute("promociones", promociones);
            req.getRequestDispatcher("/adminPage/promocionesLista.jsp").forward(req, resp);

        } else if (accion.equals("nueva")) {
            List<VarianteProducto> variantes = varianteDao.obtenerTodas();
            req.setAttribute("variantes", variantes);
            req.getRequestDispatcher("/adminPage/agregarPromoAdmin.jsp").forward(req, resp);

        } else if (accion.equals("editar")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Promocion promo = promocionDao.obtenerPorId(id);
            req.setAttribute("promo", promo);
            req.getRequestDispatcher("/adminPage/editarPromocion.jsp").forward(req, resp);

        } else if (accion.equals("eliminar")) {
            int id = Integer.parseInt(req.getParameter("id"));
            promocionDao.eliminar(id);
            resp.sendRedirect("crud-promociones?accion=listar");

        } else {
            resp.sendRedirect("crud-promociones?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accion = req.getParameter("accion");

        String nombre = req.getParameter("nombre");
        String tipo = req.getParameter("tipo");
        double valor = Double.parseDouble(req.getParameter("valor"));
        String fechaInicio = req.getParameter("fecha_inicio");
        String fechaFin = req.getParameter("fecha_fin");

        Promocion promo = new Promocion();
        promo.setNombre(nombre);
        promo.setTipo(tipo);
        promo.setValor(valor);
        promo.setFechaInicio(fechaInicio);
        promo.setFechaFin(fechaFin);

        if ("actualizar".equals(accion)) {
            promo.setId(Integer.parseInt(req.getParameter("id")));
            promocionDao.actualizar(promo);

        } else if ("guardar".equals(accion)) {
            int idPromo = promocionDao.guardar(promo);
            String[] variantesSeleccionadas = req.getParameterValues("variantes");

            if (idPromo != -1 && variantesSeleccionadas != null) {
                for (String idVar : variantesSeleccionadas) {
                    promocionDao.asignarVariante(idPromo, Integer.parseInt(idVar));
                }
            }
        }

        resp.sendRedirect("crud-promociones?accion=listar");
    }
} 