package servlet;

import dao.CategoriaDao;
import modelo.Categoria;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/categorias-crud")
@MultipartConfig
public class CrudCategoria extends HttpServlet {

    CategoriaDao categoriaDao = new CategoriaDao();

    // Ruta permanente donde se guardarán las imágenes
    private static final String IMAGE_DIR = "C:/mitikas_uploads"; // Puedes cambiarla si quieres

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        if ("editar".equals(accion) && idStr != null) {
            int id = Integer.parseInt(idStr);
            Categoria c = categoriaDao.obtenerPorId(id);
            request.setAttribute("categoriaEditar", c);
        } else if ("eliminar".equals(accion) && idStr != null) {
            int id = Integer.parseInt(idStr);
            categoriaDao.eliminar(id);
        }

        request.setAttribute("categorias", categoriaDao.listar());
        request.getRequestDispatcher("adminPage/categoriasAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String nombre = request.getParameter("categoria");

        Part filePart = request.getPart("imagen");
        String imagenActual = request.getParameter("imagen_actual"); // desde input hidden
        String nombreArchivo = imagenActual;

        if (filePart != null && filePart.getSize() > 0) {
            nombreArchivo = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // Asegura que la carpeta exista
            File carpeta = new File(IMAGE_DIR);
            if (!carpeta.exists()) carpeta.mkdirs();

            // Guarda la imagen en la ruta permanente
            filePart.write(IMAGE_DIR + File.separator + nombreArchivo);
        }

        Categoria c = new Categoria();
        c.setCategoria(nombre);
        c.setImagen(nombreArchivo);

        if (idStr == null || idStr.isEmpty()) {
            categoriaDao.agregar(c);
        } else {
            c.setId(Integer.parseInt(idStr));
            categoriaDao.actualizar(c);
        }

        response.sendRedirect("categorias-crud");
    }
}
