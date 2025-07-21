<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.ItemCarrito" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;
    List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
    double total = 0;

    String enlaceInicio = (usuario != null && "user".equals(usuario.getRol()))
        ? request.getContextPath() + "/panel-cliente"
        : request.getContextPath() + "/inicio";
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Carrito de Compras</title>
        <script src="https://cdn.tailwindcss.com"></script>
         <!-- Fuente Jost desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&display=swap" rel="stylesheet">
       <style>
       
             body {
                font-family: 'Jost', sans-serif;
            }
        </style>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">

        <!-- Navbar -->
        <nav class="bg-white shadow p-3">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700">MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="<%= enlaceInicio %>" class="text-gray-700 font-medium hover:text-red-700 transition">Inicio</a>
                    <a href="../nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-medium hover:text-red-700 transition">Mis Pedidos</a>
                    <a href="carrito.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Carrito</a>
                    <% if (usuario != null && "user".equals(usuario.getRol())) { %>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>
                    <% } else { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Iniciar sesión</a>
                    <% } %>
                </div>
            </div>
                    </nav>

        <!-- Contenido -->
        <main class="flex-grow">
            <div class="max-w-6xl mx-auto px-4 py-12">
                <h2 class="text-3xl font-semibold text-center text-gray-800 mb-10" style="font-family: 'Jost', sans-serif;">Carrito de Compras</h2>

                <%
                    if (carrito != null && !carrito.isEmpty()) {
                %>
                <div class="overflow-x-auto">
                    <table class="min-w-full bg-white shadow-md rounded-lg overflow-hidden">
                        <thead class="bg-red-600 text-white">
                            <tr>
                                <th class="py-3 px-6">Imagen</th>
                                <th class="py-3 px-6">Producto</th>
                                <th class="py-3 px-6">Tamaño</th>
                                <th class="py-3 px-6">Precio</th>
                                <th class="py-3 px-6">Cantidad</th>
                                <th class="py-3 px-6">Subtotal</th>
                                <th class="py-3 px-6">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (ItemCarrito item : carrito) {
                                double subtotal = item.getSubtotal();
                                total += subtotal;
                            %>
                            <tr class="border-b">
                                <td class="py-4 px-6 text-center">
                                    <img src="<%= request.getContextPath() %>/imagenes/<%= item.getProducto().getImagen() %>"
                                         class="w-20 h-20 object-contain mx-auto rounded" />
                                </td>
                                <td class="py-4 px-6"><%= item.getProducto().getNombre() %></td>
                                <td class="py-4 px-6"><%= item.getVariante().getTamaño() %></td>
                                <td class="py-4 px-6">S/. <%= String.format("%.2f", item.getPrecioFinal()) %></td>
                                <td class="py-4 px-6 text-center">
                                    <form action="<%= request.getContextPath() %>/ActualizarCantidadServlet" method="post" class="flex items-center justify-center space-x-2">
                                        <input type="hidden" name="idProducto" value="<%= item.getProducto().getId() %>">
                                        <input type="hidden" name="idVariante" value="<%= item.getVariante().getId() %>">
                                        <input type="number" name="cantidad" value="<%= item.getCantidad() %>" min="1"
                                               class="w-16 text-center border border-gray-300 rounded px-2 py-1 text-sm" />
                                        <button type="submit" class="text-blue-600 hover:underline text-sm">Actualizar</button>
                                    </form>
                                </td>
                                <td class="py-4 px-6">S/. <%= String.format("%.2f", subtotal) %></td>
                                <td class="py-4 px-6 text-center">
                                    <form action="<%= request.getContextPath() %>/EliminarDelCarritoServlet" method="post">
                                        <input type="hidden" name="idProducto" value="<%= item.getProducto().getId() %>">
                                        <input type="hidden" name="idVariante" value="<%= item.getVariante().getId() %>">
                                        <button type="submit" class="text-red-600 hover:underline text-sm">Eliminar</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                        <tfoot>
                            <tr class="bg-gray-100">
                                <td colspan="5" class="py-4 px-6 text-right font-semibold text-lg">Total:</td>
                                <td class="py-4 px-6 font-bold text-red-600 text-lg" colspan="2">S/. <%= String.format("%.2f", total) %></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="flex justify-between mt-6">
                    <a href="<%= enlaceInicio %>"
                       class="inline-block bg-gray-300 text-gray-800 px-6 py-2 rounded hover:bg-gray-400 transition">
                        Seguir comprando
                    </a>

                    <div class="flex gap-4">
                        <form action="<%= request.getContextPath() %>/VaciarCarritoServlet" method="post">
                            <button type="submit" class="bg-yellow-400 text-gray-800 font-semibold px-6 py-2 rounded hover:bg-yellow-500 transition">
                                Vaciar carrito
                            </button>
                        </form>

                        <% if (usuario != null && "user".equals(usuario.getRol())) {%>
                        <form action="<%= request.getContextPath()%>/ProcesarCompraServlet" method="post">
                            <button type="submit" class="bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700 transition">
                                Procesar compra
                            </button>
                        </form>

                        <% } else {%>
                        <a href="<%= request.getContextPath()%>/login.jsp"
                           class="bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700 transition">
                            Inicia sesión para comprar
                        </a>
                        <% } %>

                    </div>
                </div>

                <% } else { %>
                <p class="text-center text-gray-500 text-lg">Tu carrito está vacío.</p>
                <div class="text-center mt-6">
                    <a href="<%= enlaceInicio %>"
                       class="inline-block bg-red-600 text-white px-6 py-2 rounded hover:bg-red-700 transition">
                        Ir a comprar
                    </a>
                </div>
                <% } %>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-red-700 text-white py-8 mt-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col md:flex-row justify-between items-center md:items-start space-y-6 md:space-y-0">
                    <div class="text-center md:text-left">
                        <h2 class="text-xl font-bold">MÍTIKAS</h2>
                        <p class="mt-2 text-sm">Pasión para difundir la artesania</p>
                    </div>
                    <div class="flex space-x-6">
                        <a href="#" class="hover:underline">Inicio</a>
                        <a href="#" class="hover:underline">Sobre Nosotros</a>
                        <a href="#" class="hover:underline">Ayuda</a>
                        <a href="#" class="hover:underline">Contacto</a>
                    </div>
                    <div class="flex space-x-4">
                        <!-- Facebook -->
                        <a href="#" aria-label="Facebook" class="hover:text-gray-300">
                            <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M22 12a10 10 0 10-11.5 9.87v-7h-3v-3h3v-2.3c0-3 1.8-4.7 4.6-4.7 1.3 0 2.7.24 2.7.24v3h-1.54c-1.52 0-2 1-2 2v2.5h3.4l-.54 3h-2.86v7A10 10 0 0022 12z"/></svg>
                        </a>
                        <!-- Instagram -->
                        <a href="#" aria-label="Instagram" class="hover:text-gray-300">
                            <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M7 2C4.8 2 3 3.8 3 6v12c0 2.2 1.8 4 4 4h10c2.2 0 4-1.8 4-4V6c0-2.2-1.8-4-4-4H7zm10 3a1 1 0 110 2 1 1 0 010-2zm-5 2c3.3 0 6 2.7 6 6s-2.7 6-6 6-6-2.7-6-6 2.7-6 6-6zm0 2a4 4 0 100 8 4 4 0 000-8z"/></svg>
                        </a>
                        <!-- Twitter -->
                        <a href="#" aria-label="Twitter" class="hover:text-gray-300">
                            <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M22 5.9a8.1 8.1 0 01-2.3.6 4 4 0 001.8-2.2 8.2 8.2 0 01-2.6 1 4.1 4.1 0 00-7 3.7 11.7 11.7 0 01-8.5-4.3 4.1 4.1 0 001.3 5.4 4 4 0 01-1.8-.5v.05a4.1 4.1 0 003.3 4 4 4 0 01-1.8.07 4.1 4.1 0 003.8 2.9A8.2 8.2 0 014 19.5a11.6 11.6 0 006.3 1.8c7.5 0 11.6-6.2 11.6-11.6 0-.2 0-.4 0-.6A8.3 8.3 0 0022 5.9z"/></svg>
                        </a>
                    </div>
                </div>
                <div class="mt-6 text-center text-sm text-gray-300">
                    &copy; 2025 Mitikas. Todos los derechos reservados.
                </div>
            </div>
        </footer>

    </body>
</html>
