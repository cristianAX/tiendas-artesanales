<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="java.util.List" %>

<%
    Categoria categoriaEditar = (Categoria) request.getAttribute("categoriaEditar");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Categorías</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">
       <!-- Narvbar -->

        <header class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
                <h1 class="text-xl font-bold text-red-700">Panel de Administración</h1>
                <nav class="space-x-4 text-sm text-gray-700">

                    <a href="<%= request.getContextPath() %>/crud-productos" class="hover:text-red-700">Productos</a>
                    <a href="<%= request.getContextPath() %>/categorias-crud" class="hover:text-red-700">Categorías</a>

                    <a href="<%= request.getContextPath() %>/pedidos" class="hover:text-red-700">Pedidos</a>
                    <a href="<%= request.getContextPath() %>/zonas-delivery" class="hover:text-red-700"> ZonaDelivery</a>

                    <a href="<%= request.getContextPath() %>/crud-promociones" class="hover:text-red-700"> Promociones</a>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>

                </nav>
            </div>
        </header>
        <br>
         <!-- Formulario -->

        <div class="max-w-3xl mx-auto bg-white p-6 rounded shadow-md mb-8">
            <h2 class="text-2xl font-bold mb-4">
                <%= (categoriaEditar != null) ? "Editar categoría" : "Registrar nueva categoría" %>
            </h2>
            <form action="<%= request.getContextPath() %>/categorias-crud" method="post" enctype="multipart/form-data">
                <% if (categoriaEditar != null) { %>
                <input type="hidden" name="id" value="<%= categoriaEditar.getId() %>">
                <% } %>

                <div>
                    <label class="block font-medium mb-1">Nombre de categoría:</label>
                    <input type="text" name="categoria" required
                           value="<%= (categoriaEditar != null) ? categoriaEditar.getCategoria() : "" %>"
                           class="w-full border border-gray-300 px-4 py-2 rounded">
                </div>
                <div>
                    <label class="block font-medium mb-1">Imagen:</label>
                    <input type="file" name="imagen" accept="image/*"
                           class="w-full border border-gray-300 px-4 py-2 rounded">
                </div>

                <% if (categoriaEditar != null && categoriaEditar.getImagen() != null && !categoriaEditar.getImagen().isEmpty()) { %>
                <div class="mt-2">
                    <p class="text-sm text-gray-700">Imagen actual:</p>
                    <img  src="<%= request.getContextPath() %>/imagenes/<%= categoriaEditar.getImagen() %>" 
                         class="w-32 h-32 object-cover border rounded shadow">
                </div>
                <% } %>

                <% if (categoriaEditar != null) { %>
                <input type="hidden" name="imagen_actual" value="<%= categoriaEditar.getImagen() %>">
                <% } %>

                <br>
                <button type="submit"
                        class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded">
                    <%= (categoriaEditar != null) ? "Actualizar" : "Registrar" %>
                </button>
            </form>
        </div>

        <!-- Tabla de categorías -->
        <div class="max-w-4xl mx-auto bg-white p-6 rounded shadow-md">
            <h2 class="text-xl font-bold mb-4">Lista de categorías</h2>
            <table class="w-full table-auto border border-gray-200">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2">Nombre</th>
                        <th class="px-4 py-2">Imagen</th>
                        <th class="px-4 py-2">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (categorias != null) {
                    for (Categoria c : categorias) { %>
                    <tr class="text-center border-t">
                        <td class="px-4 py-2"><%= c.getCategoria() %></td>
                        <td class="px-4 py-2">
                            <img  src="<%= request.getContextPath() %>/imagenes/<%= c.getImagen() %>"
                                 class="w-16 h-16 object-cover mx-auto rounded border">
                        </td>
                        <td class="px-4 py-2 space-x-2">
                            <a href="<%= request.getContextPath() %>/categorias-crud?accion=editar&id=<%= c.getId() %>"
                               class="text-blue-600 hover:underline">Editar</a>
                            <a href="<%= request.getContextPath() %>/categorias-crud?accion=eliminar&id=<%= c.getId() %>"
                               onclick="return confirm('¿Seguro que deseas eliminar esta categoría?');"
                               class="text-red-600 hover:underline">Eliminar</a>
                        </td>
                    </tr>
                    <% }} else { %>
                    <tr><td colspan="3" class="py-4 text-center">No hay categorías registradas.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </body>
</html>
