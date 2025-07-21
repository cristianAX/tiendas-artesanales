<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Producto, modelo.Categoria, java.util.List" %>
<%@ page import="modelo.Usuario" %>

<%
    HttpSession sesion = request.getSession(false); // no crea una nueva sesión si no existe
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

    String enlaceInicio = (usuario != null && "user".equals(usuario.getRol()))
        ? request.getContextPath() + "/panel-cliente"
        : request.getContextPath() + "/inicio";


    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    Categoria categoria = (Categoria) request.getAttribute("categoria");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Productos - <%= categoria.getCategoria() %></title>
        <script src="https://cdn.tailwindcss.com"></script>
     <!-- Fuente Jost desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
         
            body {
                font-family: 'Jost', sans-serif;
            }
        </style>
    </head>
    
    
    <body  class="flex flex-col min-h-screen" >

    <!-- CONTENIDO PRINCIPAL -->
    <main class="flex-grow">
          <!-- Navbar -->
        <nav class="bg-white shadow p-3 mb-6">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700">MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="<%= enlaceInicio %>" class="text-gray-700 font-medium hover:text-red-700 transition">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-medium hover:text-red-700 transition">Mis Pedidos</a>

                    <a href="userPage/carrito.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Carrito</a>

                    <% if (usuario != null && "user".equals(usuario.getRol())) { %>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>
                    <% } else { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Iniciar sesión</a>
                    <% } %>
                </div>
            </div>
        </nav>
                

        <h1 class="text-center text-3xl font-semibold text-orange-700 tracking-wide mb-8 mt-12" style="font-family: 'Jost', sans-serif;">Productos de <%= categoria.getCategoria() %></h1>
<div class="max-w-7xl mx-auto px-4 py-6">

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% for (Producto p : productos) { %>
            <a href="detalleProducto?id=<%= p.getId() %>" class="w-64 mx-auto bg-white shadow-md rounded-xl overflow-hidden hover:shadow-xl transition">
                          <div class="w-full aspect-square overflow-hidden">

                <img src="<%= request.getContextPath() %>/imagenes/<%= p.getImagen() %>" class="w-full h-full object-cover" alt="<%= p.getNombre() %>">
                               </div>

                <div class="p-3 text-center">
                    <h2 class="text-lg font-bold text-gray-800"><%= p.getNombre() %></h2>
                </div>
            </a>
            <% } %>
        </div>
              </div>
  
     </main>
        <!-- Footer -->
        <footer class="bg-red-700 text-white py-8">
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
