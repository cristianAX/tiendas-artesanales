<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.ZonaDelivery" %>

<%
 String modo = (String) request.getAttribute("modo");
if (modo == null) modo = "listar";


    ZonaDelivery zona = (ZonaDelivery) request.getAttribute("zona");
    if (zona == null) zona = new ZonaDelivery();

    List<ZonaDelivery> listaZonas = (List<ZonaDelivery>) request.getAttribute("listaZonas");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Zonas de Delivery</title>
        <script src="https://cdn.tailwindcss.com"></script>

        <style>
            table, th, td {
                border: 1px solid #ccc;
                border-collapse: collapse;
                padding: 8px;
            }
            form {
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body class="bg-gray-100 text-gray-800 font-sans">

        <header class="bg-white shadow mb-8">
            <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
                <h1 class="text-2xl font-bold text-red-700">Panel de Administración</h1>
                <nav class="space-x-4 text-sm text-gray-700">
                    <a href="<%= request.getContextPath() %>/crud-productos" class="hover:text-red-700">Productos</a>
                    <a href="<%= request.getContextPath() %>/categorias-crud" class="hover:text-red-700">Categorías</a>
                    <a href="<%= request.getContextPath() %>/pedidos" class="hover:text-red-700">Pedidos</a>
                    <a href="<%= request.getContextPath() %>/zonas-delivery" class="hover:text-red-700 font-semibold">ZonaDelivery</a>
                    <a href="<%= request.getContextPath() %>/crud-promociones" class="hover:text-red-700">Promociones</a>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>
                </nav>
            </div>
        </header>

        <div class="max-w-5xl mx-auto px-4">
            <h2 class="text-xl font-bold">Gestión de Zonas de Delivery</h2>
            <br>

            <% if ("form".equals(modo)) { %>
            <div class="bg-white p-6 rounded-lg shadow mb-8">
                <h3 class="text-lg font-bold mb-4"><%= zona.getId() > 0 ? "Editar Zona" : "Nueva Zona" %></h3>
                <form action="zonas-delivery" method="post" class="space-y-4">
                    <input type="hidden" name="id" value="<%= zona.getId() %>">

                    <div>
                        <label class="block font-medium">Distrito:</label>
                        <input type="text" name="distrito" value="<%= zona.getDistrito() != null ? zona.getDistrito() : "" %>"
                               class="w-full mt-1 px-3 py-2 border rounded" required>
                    </div>

                    <div>
                        <label class="block font-medium">Costo de Envío (S/):</label>
                        <input type="number" step="0.01" name="costo" value="<%= zona.getCosto() %>"
                               class="w-full mt-1 px-3 py-2 border rounded" required>
                    </div>

                    <div>
                        <label class="block font-medium">Días Estimados:</label>
                        <input type="number" name="diasEstimados" value="<%= zona.getDiasEstimados() %>"
                               class="w-full mt-1 px-3 py-2 border rounded" required>
                    </div>

                    <div class="flex gap-4">
                        <button type="submit"
                                class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">Guardar</button>
                        <a href="zonas-delivery" class="text-gray-600 hover:underline mt-2">Cancelar</a>
                    </div>
                </form>
            </div>
            <% } %>

            <% if (!"form".equals(modo)) { %>
            <div class="max-w-4xl mx-auto bg-white p-6 rounded shadow-md">
                
                <table class="min-w-full border text-left text-sm">
                    <thead class="bg-gray-100 font-semibold">
                        <tr>
                            <th class="px-4 py-2">ID</th>
                            <th class="px-4 py-2">Distrito</th>
                            <th class="px-4 py-2 ">Costo (S/)</th>
                            <th class="px-4 py-2">Días</th>
                            <th class="px-4 py-2 ">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaZonas != null) {
        for (ZonaDelivery z : listaZonas) { %>
                        <tr class="border-t hover:bg-gray-50">
                            <td class="px-4 py-2"><%= z.getId() %></td>
                            <td class="px-4 py-2"><%= z.getDistrito() %></td>
                            <td class="px-4 py-2">S/ <%= z.getCosto() %></td>
                            <td class="px-4 py-2"><%= z.getDiasEstimados() %></td>
                            <td class="px-4 py-2 space-x-2">
                                <a href="zonas-delivery?accion=editar&id=<%= z.getId() %>" class="text-blue-600 hover:underline">Editar</a>
                                <a href="zonas-delivery?accion=eliminar&id=<%= z.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('¿Eliminar distrito?')">Eliminar</a>
                            </td>
                        </tr>
                        <% }} else { %>
                        <tr>
                            <td colspan="5" class="px-4 py-4 text-center text-gray-500">No hay zonas registradas.</td>
                        </tr>
                        <% } %>
                    </tbody>

                </table>
            </div>

            <div class="mt-4">
                <a href="zonas-delivery?accion=nuevo" class="inline-block mt-4 bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">
                   +  Agregar nuevo distrito
                </a>
            </div>
            <% } %>

        </div>

    </body>

</html>
