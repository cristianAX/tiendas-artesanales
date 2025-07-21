<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="modelo.Pedido, modelo.DetallePedido, modelo.Producto, modelo.VarianteProducto, java.util.List" %>
<%@ page import="modelo.Usuario" %>
<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;
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
        <title>Mis Pedidos</title>
        <script src="https://cdn.tailwindcss.com"></script>
         <!-- Fuente Jost desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&display=swap" rel="stylesheet">
       <style>
       
             body {
                font-family: 'Jost', sans-serif;
            }
        </style>
    </head>
    <body class="bg-gray-100">

        <!-- Navbar cliente -->
        <nav class="bg-white shadow p-3 mb-6">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700">MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="<%= request.getContextPath() %>/panel-cliente" class="text-gray-700 hover:text-red-700">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-semibold">Mis pedidos</a>

                    <a href="<%= request.getContextPath() %>/userPage/carrito.jsp" class="text-gray-700 hover:text-red-700">Carrito</a>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 hover:text-red-700">Salir</a>
                </div>
            </div>
        </nav>

        <div class="max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-6 text-center text-red-700">Mis Pedidos</h1>

            <% if (pedidos != null && !pedidos.isEmpty()) { %>
            <% for (Pedido p : pedidos) { 
                double total = 0;
                for (DetallePedido d : p.getDetalles()) {
                    total += d.getSubtotal();
                }
                total += p.getCostoEnvio();
            %>
            <div class="bg-white rounded shadow p-4 mb-6">
                <h2 class="text-lg font-bold text-gray-800">Pedido #<%= p.getId() %></h2>
                <p class="text-sm text-gray-600 mb-2">Fecha: <%= p.getFecha() %></p>
                <p class="text-sm text-gray-600 mb-2">Dirección: <%= p.getDireccion() %></p>
                <p class="text-sm text-gray-600 mb-2">
                    Estado: 
                    <span class="px-3 py-1 rounded text-sm font-semibold <%= obtenerClaseProceso(p.getProceso()) %>">
                        <%= p.getProceso().replace("_", " ") %>
                    </span>
                </p>

                <ul class="list-disc pl-6 text-gray-700 mt-2">
                    <% for (DetallePedido d : p.getDetalles()) { %>
                    <li>
                        <%= d.getProducto().getNombre() %>
                        <% if (d.getVariante() != null) { %> - Tamaño: <%= d.getVariante().getTamaño() %> <% } %>
                        - Cantidad: <%= d.getCantidad() %>
                        - Subtotal: S/ <%= String.format("%.2f", d.getSubtotal()) %>
                    </li>
                    <% } %>
                </ul>

                <% if (p.getIdZonaDelivery() != null) { %>
                <p class="mt-2 text-sm text-gray-700">Costo de envío: S/ <%= String.format("%.2f", p.getCostoEnvio()) %></p>
                <% } else { %>
                <p class="mt-2 text-sm text-gray-700 italic">Retiro en tienda</p>
                <% } %>

                <div class="mt-2 text-gray-800">
                    <strong>Total pagado:</strong> S/ <%= String.format("%.2f", total) %>
                </div>
            </div>
            <% } %>
            <% } else { %>
            <p class="text-center text-gray-600">No tienes pedidos registrados.</p>
            <% } %>
        </div>

    </body>
</html>
