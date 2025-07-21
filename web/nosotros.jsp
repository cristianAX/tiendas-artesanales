<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Usuario" %>

<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

    String enlaceInicio = (usuario != null && "user".equals(usuario.getRol()))
        ? request.getContextPath() + "/panel-cliente"
        : request.getContextPath() + "/inicio";

  
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Mítikas Artesanías</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Tailwind CDN -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Fuente Jost desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Jost', sans-serif;
            }
        </style>
    </head>
    <body class="bg-white text-gray-800">
        <!-- Navbar -->
        <nav class="bg-white shadow p-3">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700"> MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="<%= enlaceInicio %>" class="text-gray-700 hover:text-red-700">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 hover:text-red-700 transition">Mis Pedidos</a>

                    <a href="<%= request.getContextPath() %>/userPage/carrito.jsp" class="text-gray-700 hover:text-red-700">Carrito</a>
                    <% if (usuario != null) { %>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 hover:text-red-700">Salir</a>
                    <% } else { %>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="text-gray-700 hover:text-red-700">Iniciar sesión</a>
                    <% } %>
                </div>
            </div>
        </nav>
        <!-- Header con imagen -->
        <header class="w-full">
            <img src="img/HeaderArtesania1.jpg" alt="Mítikas" class="w-full h-64 object-cover">
        </header>

        <!-- Sección Nuestra Esencia -->
        <section class="max-w-3xl mx-auto px-6 py-12 text-center">
            <h2 class="text-3xl font-semibold text-orange-700 mb-6">Nuestra Esencia</h2>
            <p class="mb-4 text-lg leading-relaxed">
                En <strong>Mítikas Artesanías</strong>, vivimos con pasión la misión de <strong>difundir lo nuestro</strong>: el arte, la tradición y la identidad peruana. Cada producto que elaboramos nace del amor por nuestras raíces y la creatividad de manos artesanas que dan vida a piezas únicas, llenas de alma.
            </p>
            <p class="text-lg leading-relaxed">
                Con el tiempo, este compromiso nos ha llevado a convertirnos en una <strong>marca referente de la artesanía peruana</strong>, reconocida por ofrecer calidad, autenticidad y un fuerte vínculo con la cultura nacional.
            </p>
        </section>
        <!-- Sección Llévate un pedacito del Perú -->
        <section class="bg-orange-50 text-center px-6 py-12 text-gray-800">
            <h2 class="text-3xl font-semibold text-orange-700 mb-6">Llévate un pedacito del Perú</h2>
            <p class="mb-4 text-lg leading-relaxed max-w-3xl mx-auto">
                Desde Lima, Perú, te invitamos a llevarte algo más que un regalo: una conexión con nuestra historia.
                Nuestras <strong>decoraciones para el hogar</strong>, <strong>souvenirs</strong>, y hasta <strong>detalles para tus mascotas</strong>
                llevan consigo <strong>colores, texturas y símbolos que nos representan</strong>.
            </p>
            <div class="text-lg space-y-2 mt-6 max-w-2xl mx-auto">
                <p> <strong>Visítanos:</strong> Av. Aviación 5095, Tienda 78-79, Surco<br><span class="text-sm">(a una cuadra del Óvalo Higuereta)</span></p>
                <p> <strong>Teléfono:</strong> +51 991 799 759</p>
                <p> <strong>Correo:</strong> merybean87@gmail.com</p>
            </div>
        </section>


        <section class="bg-gray-50 px-6 py-16 text-gray-800">
            <h2 class="text-3xl font-semibold text-center text-orange-700 mb-10">  ¿Por qué elegirnos?</h2>

            <div class="max-w-6xl mx-auto space-y-10">

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 justify-center">
                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition text-center">
                        <svg class="w-10 h-10 mx-auto text-orange-700 mb-4" fill="none" stroke="currentColor" stroke-width="1.5"
                             viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M4.5 12.75l6-6 6 6M4.5 19.5l6-6 6 6" />
                        </svg>
                        <h3 class="text-lg font-semibold">Hecho a mano por artesanos peruanos</h3>
                        
                        
                        
                    </div>

                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition text-center">
                        <svg class="w-10 h-10 mx-auto text-orange-700 mb-4" fill="none" stroke="currentColor" stroke-width="1.5"
                             viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M12 3C7.03 3 3 7.03 3 12c0 1.21.27 2.36.74 3.4a.75.75 0 00.56.39 5.46 5.46 0 013.45 2.49.75.75 0 00.61.32h4.29a6.75 6.75 0 000-13.5z" />
                        </svg>
                        <h3 class="text-lg font-semibold">Diseños originales, llenos de identidad</h3>
                    </div>

                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition text-center">
                        <svg class="w-10 h-10 mx-auto text-orange-700 mb-4" fill="none" stroke="currentColor" stroke-width="1.5"
                             viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M4.318 6.318a4.5 4.5 0 016.364 0L12 7.636l1.318-1.318a4.5 4.5 0 116.364 6.364L12 21l-7.682-7.682a4.5 4.5 0 010-6.364z" />
                        </svg>
                        <h3 class="text-lg font-semibold">Atención cercana y personalizada</h3>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 justify-center max-w-3xl mx-auto">
                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition text-center">
                        <svg class="w-10 h-10 mx-auto text-orange-700 mb-4" fill="none" stroke="currentColor" stroke-width="1.5"
                             viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M20 12v7a2 2 0 01-2 2H6a2 2 0 01-2-2v-7m16 0V9a2 2 0 00-2-2h-3.5M20 12H4m16 0H4m0 0V9a2 2 0 012-2h3.5m0 0a2.5 2.5 0 115 0m-5 0a2.5 2.5 0 105 0" />
                        </svg>
                        <h3 class="text-lg font-semibold">Productos únicos, perfectos para regalo</h3>
                    </div>

                    <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition text-center">
                        <svg class="w-10 h-10 mx-auto text-orange-700 mb-4" fill="none" stroke="currentColor" stroke-width="1.5"
                             viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M12 12c2.5 1 3 3.5 3 3.5s-.5 3-3 3-3-3-3-3 0-2.5 3-3.5zm6-2a1.5 1.5 0 100-3 1.5 1.5 0 000 3zm-12 0a1.5 1.5 0 100-3 1.5 1.5 0 000 3zm9.5 5a1.5 1.5 0 100-3 1.5 1.5 0 000 3zm-7 0a1.5 1.5 0 100-3 1.5 1.5 0 000 3z" />
                        </svg>
                        <h3 class="text-lg font-semibold">Detalles artesanales también para tus mascotas</h3>
                    </div>
                </div>

            </div>
        </section>



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
