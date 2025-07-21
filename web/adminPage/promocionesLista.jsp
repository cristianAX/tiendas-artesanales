<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Promocion" %>
<%@ page import="modelo.VarianteProducto" %>

<html>
<head>
    <title>Lista de Promociones</title>
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
    <div class="max-w-4xl mx-auto bg-white p-6 rounded shadow">
        <h1 class="text-2xl font-bold mb-4">Promociones Registradas</h1>
        <a href="crud-promociones?accion=nueva" class="bg-red-500 text-white px-3 py-1 rounded mb-4 inline-block">+ Nueva Promoción</a>
        <table class="w-full table-auto border">
            <thead class="bg-gray-200">
                <tr>
                    <th class="p-2 border">Nombre</th>
                    <th class="p-2 border">Tipo</th>
                    <th class="p-2 border">Valor</th>
                    <th class="p-2 border">Inicio</th>
                    <th class="p-2 border">Fin</th>
                    <th class="p-2 border">Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<modelo.Promocion> promociones = (List<modelo.Promocion>) request.getAttribute("promociones");
                    if (promociones != null && !promociones.isEmpty()) {
                        for (modelo.Promocion p : promociones) {
                %>
                <tr>
                    <td class="p-2 border"><%= p.getNombre() %></td>
                    <td class="p-2 border"><%= p.getTipo() %></td>
                    <td class="p-2 border"><%= p.getValor() %></td>
                    <td class="p-2 border"><%= p.getFechaInicio() %></td>
                    <td class="p-2 border"><%= p.getFechaFin() %></td>
                    <td class="p-2 border space-x-2">
                        <a href="crud-promociones?accion=editar&id=<%= p.getId() %>" class="text-blue-600 hover:underline">Editar</a>
                        <a href="crud-promociones?accion=eliminar&id=<%= p.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('¿Eliminar esta promoción?')">Eliminar</a>
                    </td>
                </tr>
                <tr>
    <td colspan="6" class="p-2 border bg-gray-50 text-sm">
        <strong>Variantes:</strong>
        <ul class="list-disc pl-6">
        <%
            List<modelo.VarianteProducto> vars = p.getVariantes();
            if (vars != null && !vars.isEmpty()) {
                for (modelo.VarianteProducto v : vars) {
        %>
            <li><%= v.getNombreProducto() %> - <%= v.getTamaño() %> - S/<%= v.getPrecioVenta() %></li>
        <%
                }
            } else {
        %>
            <li>No tiene variantes asociadas.</li>
        <%
            }
        %>
        </ul>
    </td>
</tr>

                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="6" class="p-2 border text-center">No hay promociones registradas.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
