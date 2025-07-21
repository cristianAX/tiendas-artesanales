<%@ page import="modelo.Producto, modelo.Categoria, modelo.VarianteProducto, java.util.*" %>
<%
    String modo = (String) request.getAttribute("modo");
    if (modo == null) modo = "listar";
    boolean modoEdicion = request.getAttribute("modoEdicion") != null;
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Panel Administrador</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">
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

        <main class="max-w-5xl mx-auto p-6 bg-white shadow mt-6 rounded-lg w-full">

            <% if (modo.equals("listar")) { %>
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold">Listado de Productos</h2>
                <a href="crud-productos?accion=nuevo" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">+ Nuevo Producto</a>
            </div>

            <table class="min-w-full border text-left text-sm">
                <thead class="bg-gray-100 font-semibold">
                    <tr>
                        <th class="px-4 py-2">ID</th>
                        <th class="px-4 py-2">Nombre</th>
                        <th class="px-4 py-2">Imagen</th>
                        <th class="px-4 py-2">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Producto> productos = (List<Producto>) request.getAttribute("productos");
                        for (Producto p : productos) {
                    %>
                    <tr class="border-t hover:bg-gray-50">
                        <td class="px-4 py-2"><%= p.getId() %></td>
                        <td class="px-4 py-2"><%= p.getNombre() %></td>
                        <td class="px-4 py-2">
                            <img src="imagenes/<%= p.getImagen() %>" width="60" class="rounded">
                        </td>
                        <td class="px-4 py-2 space-x-2">
                            <a href="crud-productos?accion=ver&id=<%= p.getId() %>" class="text-blue-600 hover:underline">Ver</a>
                            <a href="crud-productos?accion=editar&id=<%= p.getId() %>" class="text-yellow-600 hover:underline">Editar</a>
                            <a href="crud-productos?accion=eliminar&id=<%= p.getId() %>" onclick="return confirm('¿Seguro que deseas eliminar?')" class="text-red-600 hover:underline">Eliminar</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <% } else if (modo.equals("form")) { 
                Producto producto = (Producto) request.getAttribute("producto");
                List<VarianteProducto> variantes = producto != null ? producto.getVariantes() : new ArrayList<>();
                List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
            %>

            <h2 class="text-xl font-bold mb-4"><%= modoEdicion ? "Editar Producto" : "Nuevo Producto" %></h2>

            <form action="crud-productos" method="post" enctype="multipart/form-data" class="space-y-4">
                <input type="hidden" name="accion" value="<%= modoEdicion ? "actualizar" : "guardar" %>">
                <% if (modoEdicion) { %>
                <input type="hidden" name="id" value="<%= producto.getId() %>">
                <input type="hidden" name="imagen_actual" value="<%= producto.getImagen() %>">
                <% } %>

                <div>
                    <label class="block font-medium mb-1">Nombre</label>
                    <% if (modoEdicion) { %>
                    <span class="text-red-600">*</span>
                    <span class="text-gray-500 text-xs ml-1">(No editable)</span>
                    <% } %>
                    <input name="nombre" value="<%= modoEdicion ? producto.getNombre() : "" %>" 
                           class="w-full border px-3 py-2 rounded"  
                           <%= modoEdicion ? "readonly" : "required" %>>

                </div>

                <div>
                    <label class="block font-medium mb-1">Descripción</label>
                    <textarea name="descripcion" class="w-full border px-3 py-2 rounded" required><%= modoEdicion ? producto.getDescripcion() : "" %></textarea>
                </div>

                <div>
                    <label class="block font-medium mb-1">Imagen</label>
                    <input type="file" name="imagen" accept="image/*" class="w-full border px-3 py-2 rounded" <%= modoEdicion ? "" : "required" %>>
                    <% if (modoEdicion) { %>
                    <p class="mt-2 text-sm text-gray-500">Imagen actual:</p>
                    <img src="imagenes/<%= producto.getImagen() %>" width="100" class="mt-1 rounded">
                    <% } %>
                </div>

                <div>
                    <label class="block font-medium mb-1">Categoría</label>
                    <% if (modoEdicion) { %>
                    <span class="text-red-600">*</span>
                    <span class="text-gray-500 text-xs ml-1">(No editable)</span>
                    <% } %>
                    <select  name="idCategoria" class="w-full border px-3 py-2 rounded" required>
                        <% for (Categoria c : categorias) { %>
                        <option value="<%= c.getId() %>" <%= (modoEdicion && producto.getIdCategoria() == c.getId()) ? "selected" : "" %>><%= c.getCategoria() %></option>
                        <% } %>
                    </select>

                </div>

                <div>
                    <label class="block font-medium mb-2">Variantes</label>

                    <div id="variantes" class="space-y-2">
                        <% if (modoEdicion) { %>
                        <span class="text-red-600">*</span>
                        <span class="text-gray-500 text-xs ml-1">(Solo el campo presentación es no editable)</span>
                        <% } %>
                        <% if (!variantes.isEmpty()) {
                    for (VarianteProducto v : variantes) { %>
                        <input type="hidden" name="idVariante[]" value="<%= v.getId() %>">

                        <div class="flex gap-2 items-center variante-item">
                            <input name="tamaño[]" value="<%= modoEdicion ? v.getTamaño() : "" %>" 
                                   class="border px-2 py-1 rounded w-1/4" required>


                            <input name="precio[]" value="<%= v.getPrecioVenta() %>" type="number" step="0.01" placeholder="Precio" class="border px-2 py-1 rounded w-1/4" required>
                            <input name="stock[]" value="<%= v.getStock() %>" type="number" placeholder="Stock" class="border px-2 py-1 rounded w-1/4" required>

                            <button type="button" onclick="this.parentElement.remove()" class="text-red-600 hover:underline">Quitar</button>

                        </div>
                        <% }} else { %>
                        <div class="flex gap-2 items-center variante-item">




                            <input name="tamaño[]" placeholder="presentacion" class="border px-2 py-1 rounded w-1/4" required>
                            <input name="precio[]" type="number" step="0.01" placeholder="Precio" class="border px-2 py-1 rounded w-1/4" required>
                            <input name="stock[]" type="number" placeholder="Stock" class="border px-2 py-1 rounded w-1/4" required>


                        </div>
                        <% } %>
                    </div>
                    <button type="button" onclick="agregarVariante()" class="mt-3 bg-yellow-600 hover:bg-yellow-700 text-white px-4 py-2 rounded">+ Añadir Variante</button>
                </div>

                <div class="pt-4">
                    <button type="submit" class="bg-green-600 text-white px-6 py-2 rounded hover:bg-green-700"><%= modoEdicion ? "Actualizar" : "Guardar" %></button>
                    <a href="crud-productos" class="ml-4 text-gray-600 hover:underline">Cancelar</a>
                </div>
            </form>

            <script>
                function agregarVariante() {
                    const div = document.createElement('div');
                    div.className = "flex gap-2 items-center variante-item mt-2";
                    div.innerHTML = `
                        <input name="tamaño[]" placeholder="Tamaño" class="border px-2 py-1 rounded w-1/4" required>
                        <input name="precio[]" type="number" step="0.01" placeholder="Precio" class="border px-2 py-1 rounded w-1/4" required>
                       
<input name="stock[]" type="number" placeholder="Stock" class="border px-2 py-1 rounded w-1/4" required>

 <button type="button" onclick="this.parentElement.remove()" class="text-red-600 hover:underline">Quitar</button>
                    `;
                    document.getElementById("variantes").appendChild(div);
                }
            </script>

            <% } else if (modo.equals("ver")) {
                Producto producto = (Producto) request.getAttribute("producto");
                List<VarianteProducto> variantes = (List<VarianteProducto>) request.getAttribute("variantes");
            %>

  <h2 class="text-2xl font-bold mb-4 text-gray-800">Detalles del producto: <span class="text-red-600"><%= producto.getNombre() %></span></h2>

  <div class="mb-6">
    <p class="text-gray-700 mb-2"><span class="font-semibold">Descripción:</span> <%= producto.getDescripcion() %></p>
    <div class="mt-4">
      <img src="imagenes/<%= producto.getImagen() %>" alt="<%= producto.getNombre() %>" class="rounded-md w-48 h-48 object-cover border border-gray-200 shadow">
    </div>
  </div>

  <div>
    <h3 class="text-lg font-semibold mb-2 text-gray-800">Variantes disponibles</h3>
    <ul class="space-y-2">
      <% for (VarianteProducto v : variantes) { %>
        <li class="flex justify-between bg-gray-50 p-3 rounded border text-sm text-gray-700">
          <span><%= v.getTamaño() %></span>
          <span>S/ <%= v.getPrecioVenta() %></span>
          <span class="text-gray-600">Stock: <%= v.getStock()%></span>
        </li>
      <% } %>
    </ul>
  </div>

  <a href="crud-productos" class="mt-6 inline-block bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 transition">
    Volver
  </a>


            <% } %>

        </main>
    </body>
</html>
