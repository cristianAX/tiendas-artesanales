package servlet;

import dao.CategoriaDao;
import dao.ProductoDao;
import dao.VarianteDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import modelo.Producto;
import modelo.VarianteProducto;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/crud-productos")
@MultipartConfig // permite recibir archivos
public class CrudProductos extends HttpServlet {

    ProductoDao productoDao = new ProductoDao();
    VarianteDao varianteDao = new VarianteDao();
    CategoriaDao categoriaDao = new CategoriaDao();

    // Ruta donde se guardarán las imágenes
    private static final String UPLOAD_DIR = "C:/mitikas_uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                request.setAttribute("categorias", categoriaDao.listar());
                request.setAttribute("modo", "form");
                break;

            case "ver":
                int id = Integer.parseInt(request.getParameter("id"));
                Producto producto = productoDao.obtenerPorIdConVariantes(id);
                request.setAttribute("producto", producto);
                request.setAttribute("variantes", producto.getVariantes());
                request.setAttribute("modo", "ver");
                break;

            case "editar":
                int idEdit = Integer.parseInt(request.getParameter("id"));
                Producto productoEdit = productoDao.obtenerPorIdConVariantes(idEdit);
                request.setAttribute("producto", productoEdit);
                request.setAttribute("categorias", categoriaDao.listar());
                request.setAttribute("modo", "form");
                request.setAttribute("modoEdicion", true);
                break;

            case "eliminar":
                String idStr = request.getParameter("id");

                if (idStr == null || idStr.trim().isEmpty()) {
                    System.out.println("ID de producto no recibido para eliminar");
                    response.sendRedirect("crud-productos");
                    return;
                }

                try {
                    int idDel = Integer.parseInt(idStr);
                    productoDao.eliminar(idDel);
                    System.out.println("Producto y variantes eliminados correctamente");
                } catch (NumberFormatException e) {
                    System.out.println("ID inválido: " + idStr);
                }

                response.sendRedirect("crud-productos");
                return;

            case "listar":
            default:
                request.setAttribute("productos", productoDao.listarSoloProductos());
                request.setAttribute("modo", "listar");
                break;
        }

        request.getRequestDispatcher("/adminPage/productosAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        Part filePart = request.getPart("imagen");
        String imagenActual = request.getParameter("imagen_actual");
        String nombreArchivo = imagenActual;

        // Ruta de guardado
        String uploadPath = "C:/mitikas_uploads";

        if (filePart != null && filePart.getSize() > 0) {
            // Obtiene el nombre original
            nombreArchivo = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + nombreArchivo);
        }

        // Demás datos
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
            int idCategoria = Integer.parseInt(request.getParameter("idCategoria"));

        String[] tamaños = request.getParameterValues("tamaño[]");
        String[] precios = request.getParameterValues("precio[]");
        String[] stocks = request.getParameterValues("stock[]");

        List<VarianteProducto> variantes = new ArrayList<>();
        for (int i = 0; i < tamaños.length; i++) {
            VarianteProducto v = new VarianteProducto();
            v.setTamaño(tamaños[i]);
            v.setPrecioVenta(Double.parseDouble(precios[i]));
            v.setStock(Integer.parseInt(stocks[i]));

            variantes.add(v);
        }

        if ("guardar".equals(accion)) {

            Producto p = new Producto();
            p.setNombre(nombre);
            p.setDescripcion(descripcion);
            p.setImagen(nombreArchivo);
            p.setIdCategoria(idCategoria);

            int idGenerado = productoDao.guardar(p);
            for (VarianteProducto v : variantes) {
                v.setIdProducto(idGenerado);
                varianteDao.guardar(v);
            }

        } else if ("actualizar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));

            Producto p = new Producto();
            p.setId(id);
            p.setNombre(nombre);
            p.setDescripcion(descripcion);
            p.setImagen(nombreArchivo);
        p.setIdCategoria(idCategoria);
            p.setVariantes(variantes); 

            productoDao.actualizar(p); //  Este ya hace todo (actualiza producto y variantes)

        }

        response.sendRedirect("crud-productos");
    }

}
