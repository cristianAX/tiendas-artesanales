<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.Categoria" %>
<%@ page import="java.util.List" %>
<%
   
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Inicio</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Swiper -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css" />
        <script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
        <!-- Fuente Jost desde Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Jost:wght@400;500;600&display=swap" rel="stylesheet">

        <!-- Estilo para las flechas grandes -->
        <style>
            .swiper-button-prev,
            .swiper-button-next {
                width: 40px;
                height: 40px;
                background-color: white;
                border-radius: 9999px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.3);
                color: black;
            }

            .swiper-button-prev::after,
            .swiper-button-next::after {
                font-size: 20px;
                font-weight: bold;
            }
            body {
                font-family: 'Jost', sans-serif;
            }
        </style>
    </head>
    <body class="bg-gray-100 ">
        <!-- Navbar -->
        <nav class="bg-white shadow p-3">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700"> MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="#" class="text-gray-700 font-medium hover:text-red-700 transition">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-medium hover:text-red-700 transition">Mis Pedidos</a>
                    <a href="userPage/carrito.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Carrito</a>
                    <a href="login.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Iniciar sesión</a>
                </div>
            </div>
        </nav>

        <!-- Slider principal -->
        <div class="swiper bannerSwiper w-full h-[370px] mb-8 rounded overflow-hidden">
            <div class="swiper-wrapper">
                <div class="swiper-slide">
                    <img src="img/HeaderArtesania1.jpg" class="w-full h-full object-cover" alt="Banner 1">
                </div>
                <div class="swiper-slide">
                    <img src="img/HeaderArtesania2.jpg" class="w-full h-full object-cover" alt="Banner 2">
                </div>
            </div>
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
        </div>
        <div class="max-w-6xl mx-auto px-4">

            <!--  Esta seccion muestra 3 productos  -->
            <h2 class="text-center text-3xl font-semibold text-orange-700 tracking-wide mb-8 mt-12" style="font-family: 'Jost', sans-serif;">Algunos de nuestros productos</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 p-6">
    <%
        int contador = 0;
        for (Producto p : productos) {
            if (contador >= 3) break;
            contador++;
    %>
    <a href="detalleProducto?id=<%= p.getId() %>" class="w-64 mx-auto bg-white shadow-md rounded-xl overflow-hidden hover:shadow-xl transition">
        <div class="w-full aspect-square overflow-hidden">
            <img src="imagenes/<%= p.getImagen() %>" alt="<%= p.getNombre() %>" class="w-full h-full object-cover">
        </div>
        <div class="p-3 text-center">
            <h2 class="text-lg font-bold text-gray-800"><%= p.getNombre() %></h2>
        </div>
    </a>
    <% } %>
</div>


            <!-- Carrusel de categorías -->
            <h2 class="text-center text-3xl font-semibold text-orange-700 tracking-wide mb-8 mt-12" style="font-family: 'Jost', sans-serif;">
                Categorías
            </h2>

           <div class="swiper mySwiper w-full py-6">
    <div class="swiper-wrapper">
        <% if (categorias != null) {
            for (Categoria c : categorias) { %>
            <div class="swiper-slide bg-white rounded-xl shadow-md hover:shadow-xl transition duration-300 flex flex-col items-center p-4"
                 style="width: 220px; box-sizing: border-box;">
                 
                <!-- Imagen circular -->
                <div class="w-40 h-40 rounded-full overflow-hidden mb-3 shadow">
                    <img src="<%= request.getContextPath() %>/imagenes/<%= c.getImagen() %>" 
                         class="w-full h-full object-cover hover:scale-105 transition-transform duration-300" 
                         alt="<%= c.getCategoria() %>">
                </div>

                <h3 class="text-base font-semibold text-center mb-2 text-gray-800"><%= c.getCategoria() %></h3>

                <form action="productos-por-categoria" method="get" class="w-full">
                    <input type="hidden" name="id" value="<%= c.getId() %>" />
                    <button type="submit"
                            class="w-full bg-red-600 text-white text-sm px-4 py-2 rounded-md border border-red-600
                                   hover:bg-white hover:text-red-600 transition duration-300 font-medium">
                        Ver productos
                    </button>
                </form>
            </div>
        <% }
        } %>
    </div>

    <!-- Flechas -->
    <div class="swiper-button-prev"></div>
    <div class="swiper-button-next"></div>
</div>

        </div>


        <section class="bg-white py-12 px-6 mt-8">
            <div class="max-w-7xl mx-auto flex flex-col md:flex-row justify-between items-start gap-10">

                <div class="md:w-1/2">
                    <h2 class="text-3xl font-semibold text-gray-900 mb-4 font-[Jost]">Beneficios</h2>
                    <p class="text-gray-800 text-lg font-[Jost]">
                        Compra online y disfruta de productos originales y únicos.
                        <span class="font-semibold text-gray-900">
Cada pieza que adquieres no solo es un producto, sino una historia hecha a mano con dedicación y tradición.                        </span>
                    </p>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 md:w-1/2 text-center">

                    <!-- Hecho a mano -->
                    <div class="flex flex-col items-center">
                        <svg class="w-14 h-14 mb-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M10.05 4.575a1.575 1.575 0 1 0-3.15 0v3m3.15-3v-1.5a1.575 1.575 0 0 1 3.15 0v1.5m-3.15 0 .075 5.925m3.075.75V4.575m0 0a1.575 1.575 0 0 1 3.15 0V15M6.9 7.575a1.575 1.575 0 1 0-3.15 0v8.175a6.75 6.75 0 0 0 6.75 6.75h2.018a5.25 5.25 0 0 0 3.712-1.538l1.732-1.732a5.25 5.25 0 0 0 1.538-3.712l.003-2.024a.668.668 0 0 1 .198-.471 1.575 1.575 0 1 0-2.228-2.228 3.818 3.818 0 0 0-1.12 2.687M6.9 7.575V12m6.27 4.318A4.49 4.49 0 0 1 16.35 15m.002 0h-.002" />
                        </svg>

                        <p class="text-sm font-semibold">Hecho a mano y con historia</p>
                    </div>

                    <!-- Apoyo comunidades -->
                    <div class="flex flex-col items-center">
                        <svg class="w-14 h-14 mb-2"  xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor" className="size-6">
                        <path strokeLinecap="round" strokeLinejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
                        </svg>

                        <p class="text-sm font-semibold">Apoyo a comunidades locales</p>
                    </div>

                    <!-- Envío en Lima -->
                    <div class="flex flex-col items-center">
                        <svg class="w-14 h-14 mb-2 text-gray-800" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M3 13l2-5h14l2 5v6a1 1 0 01-1 1h-1a2 2 0 01-4 0H9a2 2 0 01-4 0H4a1 1 0 01-1-1v-6z" />
                        <circle cx="7" cy="18" r="1.5" />
                        <circle cx="17" cy="18" r="1.5" />
                        </svg>
                        <p class="text-sm font-semibold">Envíos en<br>Lima</p>
                    </div>

                </div>
            </div>
        </section>


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

        <!-- Swiper JS -->
        <script src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Carrusel de categorías
                new Swiper('.mySwiper', {
                    slidesPerView: 3,
                    spaceBetween: 24,
                    navigation: {
                        nextEl: '.swiper-button-next',
                        prevEl: '.swiper-button-prev',
                    }
                });

                // Banner principal
                new Swiper('.bannerSwiper', {
                    loop: true,
                    autoplay: {
                        delay: 3000,
                    },
                    navigation: {
                        nextEl: '.swiper-button-next',
                        prevEl: '.swiper-button-prev',
                    }
                });
            });
        </script>

    </body>
</html>
