<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.Producto" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="modelo.VarianteProducto" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

    String enlaceInicio = (usuario != null && "user".equals(usuario.getRol()))
        ? request.getContextPath() + "/panel-cliente"
        : request.getContextPath() + "/inicio";

    Producto producto = (Producto) request.getAttribute("producto");
    List<VarianteProducto> variantes = producto.getVariantes();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= producto.getNombre() %> - Detalle</title>
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

<!-- Navbar -->
<nav class="bg-white shadow p-3 mb-6">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="text-2xl font-bold text-red-700">MÍTIKAS</div>
        <div class="space-x-4">
            <a href="<%= enlaceInicio %>" class="text-gray-700 hover:text-red-700">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                                        <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-medium hover:text-red-700 transition">Mis Pedidos</a>

            <a href="<%= request.getContextPath() %>/userPage/carrito.jsp" class="text-gray-700 hover:text-red-700">Carrito</a>
            <% if (usuario != null) { %>
                <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 hover:text-red-700">Salir</a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="text-gray-700 hover:text-red-700">Iniciar sesión</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- Contenido -->
<div class="max-w-4xl mx-auto mt-10 p-4 bg-white rounded shadow">
    <div class="flex flex-col md:flex-row">
        <div class="md:w-1/2">
            <img src="imagenes/<%= producto.getImagen() %>" class="w-full h-auto object-cover rounded">
        </div>
        <div class="md:w-1/2 md:pl-6 mt-4 md:mt-0">
            <h1 class="text-2xl font-bold mb-2"><%= producto.getNombre() %></h1>
            <p class="mb-4 text-gray-700"><%= producto.getDescripcion() %></p>

            <form action="<%= request.getContextPath() %>/AgregarAlCarritoServlet" method="post" class="space-y-4 mt-4">
                <input type="hidden" name="idProducto" value="<%= producto.getId() %>">

                <label for="idVariante" class="block font-semibold">Tamaño:</label>
                <select name="idVariante" id="idVariante" class="border px-2 py-1 rounded w-full" required>
                    <% for (VarianteProducto v : variantes) { %>
                        <option value="<%= v.getId() %>"
                                data-precio="<%= v.getPrecioVenta() %>"
                                data-enpromo="<%= v.isEnPromocion() %>"
                                data-tipopromo="<%= v.getTipoPromocion() %>"
                                data-valorpromo="<%= v.getValorPromocion() %>"
                                data-nombrepromo="<%= v.getNombrePromocion() != null ? v.getNombrePromocion() : "" %>">
                            <%= v.getTamaño() %> - S/ <%= v.getPrecioVenta() %>
                            <%= v.isEnPromocion() ? "(Promo: " + v.getNombrePromocion() + ")" : "" %>
                        </option>
                    <% } %>
                </select>

                <div class="mt-2">
                    <span class="text-xl font-bold">Precio: </span>
                    <span id="precioPromo" class="text-xl font-bold text-red-600"></span>
                    <span id="precioNormal" class="text-lg text-gray-500 line-through ml-2"></span>
                    <div id="nombrePromo" class="text-sm text-blue-600 mt-1 font-medium"></div>
                </div>

                <label for="cantidad" class="block font-semibold">Cantidad:</label>
                <input type="number" name="cantidad" value="1" min="1" class="border px-2 py-1 rounded w-full" required>

                <button type="submit"
                        class="w-full bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 transition">
                    Añadir al carrito
                </button>
            </form>
        </div>
    </div>
</div>

  
<!-- Script -->
<script>
    const select = document.getElementById("idVariante");
    const precioPromo = document.getElementById("precioPromo");
    const precioNormal = document.getElementById("precioNormal");
    const nombrePromo = document.getElementById("nombrePromo");

    function actualizarPrecio() {
        const option = select.options[select.selectedIndex];
        const enPromo = option.getAttribute("data-enpromo") === "true";
        const tipoPromo = option.getAttribute("data-tipopromo");
        const valorPromo = parseFloat(option.getAttribute("data-valorpromo"));
        const nombrePromoTexto = option.getAttribute("data-nombrepromo");
        const precioOriginal = parseFloat(option.getAttribute("data-precio"));

        if (enPromo) {
            let precioFinal = tipoPromo === "porcentaje"
                ? precioOriginal * (1 - valorPromo / 100)
                : valorPromo;

            precioPromo.textContent = "S/ " + precioFinal.toFixed(2);
            precioNormal.textContent = "S/ " + precioOriginal.toFixed(2);
            nombrePromo.textContent = "Promoción: " + nombrePromoTexto;
        } else {
            precioPromo.textContent = "S/ " + precioOriginal.toFixed(2);
            precioNormal.textContent = "";
            nombrePromo.textContent = "";
        }
    }

    actualizarPrecio();
    select.addEventListener("change", actualizarPrecio);
</script>

</body>
</html>
