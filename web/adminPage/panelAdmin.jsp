
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario" %>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || !"admin".equals(u.getRol())) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Panel Administrador</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">

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
    </body>
</html>
