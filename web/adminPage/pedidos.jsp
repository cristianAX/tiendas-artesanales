<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="modelo.Pedido, modelo.DetallePedido, modelo.Producto, modelo.VarianteProducto, java.util.List" %>
<%
    List<Pedido> pedidos = (List<Pedido>) request.getAttribute("pedidos");
%>
<%! 
    public String obtenerClaseProceso(String proceso) {
        switch (proceso) {
            case "solicitud_recibida": return "bg-yellow-200 text-yellow-800";
            case "en_preparacion": return "bg-orange-200 text-orange-800";
            case "en_camino": return "bg-blue-200 text-blue-800";
            case "entregado": return "bg-green-200 text-green-800";
            default: return "bg-gray-200 text-gray-800";
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pedidos - Admin</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">

        <!-- Navbar -->
        <header class="bg-white shadow">
            <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
                <h1 class="text-xl font-bold text-red-700">Panel de Administración</h1>
                <nav class="space-x-4 text-sm text-gray-700">
                    <a href="<%= request.getContextPath() %>/crud-productos" class="hover:text-red-700">Productos</a>
                    <a href="<%= request.getContextPath() %>/categorias-crud" class="hover:text-red-700">Categorías</a>
                    <a href="<%= request.getContextPath() %>/pedidos" class="hover:text-red-700">Pedidos</a>
                    <a href="<%= request.getContextPath() %>/zonas-delivery" class="hover:text-red-700">ZonaDelivery</a>
                    <a href="<%= request.getContextPath() %>/crud-promociones" class="hover:text-red-700">Promociones</a>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>
                </nav>
            </div>
        </header>

        <div class="px-8 mx-auto">
            <br>
            <h1 class="text-xl font-bold">Gestión de Pedidos</h1>
            <br>

            <table class="min-w-full bg-white rounded shadow text-sm">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2">ID</th>
                        <th class="px-4 py-2">Cliente</th>
                        <th class="px-4 py-2">Dirección</th>
                        <th class="px-4 py-2">Fecha</th>
                        <th class="px-4 py-2">Proceso</th>
                        <th class="px-4 py-2">Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Pedido p : pedidos) { %>
                    <tr class="border-t bg-gray-50">
                        <td class="px-4 py-2"><%= p.getId() %></td>
                        <td class="px-4 py-2"><%= p.getNombre() %> <%= p.getApellido() %></td>
                        <td class="px-4 py-2"><%= p.getDireccion() %></td>
                        <td class="px-4 py-2"><%= p.getFecha() %></td>
                        <td class="px-4 py-2">
                            <span class="px-3 py-1 rounded text-sm font-semibold <%= obtenerClaseProceso(p.getProceso()) %>">
                                <%= p.getProceso().replace("_", " ") %>
                            </span>
                        </td>
                        <td class="px-4 py-2">
                            <form action="actualizar-proceso" method="post" class="flex gap-2 items-center">
                                <input type="hidden" name="idPedido" value="<%= p.getId() %>">
                                <select name="nuevoProceso" class="border rounded px-2 py-1 text-sm">
                                    <option value="solicitud_recibida" <%= p.getProceso().equals("solicitud_recibida") ? "selected" : "" %>>Solicitud Recibida</option>
                                    <option value="en_preparacion" <%= p.getProceso().equals("en_preparacion") ? "selected" : "" %>>En preparación</option>
                                    <option value="en_camino" <%= p.getProceso().equals("en_camino") ? "selected" : "" %>>En camino</option>
                                    <option value="entregado" <%= p.getProceso().equals("entregado") ? "selected" : "" %>>Entregado</option>
                                </select>
                                <button type="submit" class="bg-red-600 text-white px-3 py-1 rounded hover:bg-red-700">Actualizar</button>
                            </form>
                            <button onclick="mostrarModal('modal<%= p.getId() %>')"     class="bg-blue-600 text-white text-xs px-3 py-1 my-[12px] rounded hover:bg-blue-700 transition duration-200">
                                >Ver detalles</button>
                        </td>
                    </tr>

                    <!-- Modal -->
                <div id="modal<%= p.getId() %>" class="hidden fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
                    <div class="bg-white rounded-lg shadow-lg w-full max-w-lg p-6 relative">
                        <button onclick="cerrarModal('modal<%= p.getId() %>')" class="absolute top-2 right-3 text-gray-500 hover:text-red-600 text-xl">&times;</button>
                        <h2 class="text-lg font-bold text-red-700 mb-2">Detalle del Pedido #<%= p.getId() %></h2>
                        <p class="text-sm text-gray-600">Fecha: <%= p.getFecha() %></p>
                        <p class="text-sm text-gray-600">Dirección: <%= p.getDireccion() %></p>
                        <ul class="list-disc ml-5 mt-3 space-y-1 text-gray-700 text-sm">
                            <% for (DetallePedido d : p.getDetalles()) {
                                Producto prod = d.getProducto();
                                VarianteProducto var = d.getVariante();
                            %>
                            <li>
                                <%= prod != null ? prod.getNombre() : "Producto desconocido" %>
                                <% if (var != null) { %> - Tamaño: <%= var.getTamaño() %> <% } %>
                                - Cantidad: <%= d.getCantidad() %>
                                - Subtotal: S/ <%= d.getSubtotal() %>
                            </li>
                            <% } %>
                        </ul>
                        <div class="mt-4 text-sm text-gray-800">
                            <strong>Método de entrega:</strong>
                            <% if (p.getIdZonaDelivery() != null) { %>
                            Delivery - Costo de envío: <span class="font-semibold">S/ <%= p.getCostoEnvio() %></span>
                            <% } else { %>
                            <span class="italic text-gray-600">Retiro en tienda</span>
                            <% } %>
                        </div>
                        <%
                            double total = 0;
                            for (DetallePedido d : p.getDetalles()) {
                                total += d.getSubtotal();
                            }
                            total += p.getCostoEnvio();
                        %>
                        <div class="mt-2 text-gray-800">
                            <strong>Total pagado:</strong> <span class="font-semibold">S/ <%= String.format("%.2f", total) %></span>
                        </div>
                    </div>
                </div>
                <% } %>
                </tbody>
            </table>
        </div>

        <script>
            function mostrarModal(id) {
                document.getElementById(id).classList.remove("hidden");
            }
            function cerrarModal(id) {
                document.getElementById(id).classList.add("hidden");
            }
        </script>
    </body>
</html>
