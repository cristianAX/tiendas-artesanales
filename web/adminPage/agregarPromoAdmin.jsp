<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.VarianteProducto" %>
<html>
    <head>

        <title>Crear Promoción</title>

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
        <div class="max-w-3xl mx-auto bg-white p-6 rounded shadow">
            <h1 class="text-2xl font-bold mb-4">Nueva Promoción</h1>
            <form action="crud-promociones" method="post" class="space-y-4">
                <input type="hidden" name="accion" value="guardar" />
                <label class="block">Nombre:
                    <input name="nombre" class="border w-full p-2" required />
                </label>
                <label class="block">Tipo:
                    <select name="tipo" class="border w-full p-2" required>
                        <option value="porcentaje">% Descuento</option>
                        <option value="precio_fijo">Precio fijo</option>
                    </select>
                </label>
                <label class="block">Valor:
                    <input name="valor" type="number" step="0.01" class="border w-full p-2" required />
                </label>
                <label class="block">Fecha Inicio:
                    <input name="fecha_inicio" type="date" class="border w-full p-2" required />
                </label>
                <label class="block">Fecha Fin:
                    <input name="fecha_fin" type="date" class="border w-full p-2" required />
                </label>

                <h2 class="text-lg font-semibold">Selecciona variantes a aplicar:</h2>
                <div class="grid grid-cols-2 gap-2 max-h-60 overflow-y-scroll border p-2">
                    <%
                        List<VarianteProducto> variantes = (List<VarianteProducto>) request.getAttribute("variantes");
                        if (variantes != null && !variantes.isEmpty()) {
                            for (VarianteProducto v : variantes) {
                    %>
                    <label class="flex items-center space-x-2">
                        <input 
                            type="checkbox" 
                            name="variantes" 
                            value="<%= v.getId() %>" 
                            class="accent-blue-600"
                            <%= v.isEnPromocion() ? "disabled" : "" %> 
                            />
                        <span class="<%= v.isEnPromocion() ? "text-gray-400 line-through" : "" %>">
                            <span><%= v.getNombreProducto() %> - <%= v.getTamaño() %> - S/<%= v.getPrecioVenta() %>
                                <%= v.isEnPromocion() ? "(Ya en promoción)" : "" %>

                            </span>

                    </label>
                    <%
                            }
                        } else {
                    %>
                    <p>No hay variantes disponibles.</p>
                    <%
                        }
                    %>
                </div>

                <button type="submit" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Crear Promoción</button>
            </form>
        </div>
    </body>
</html>
