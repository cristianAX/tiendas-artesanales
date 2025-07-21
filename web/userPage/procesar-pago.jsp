<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="modelo.ZonaDelivery" %>
<%@ page import="modelo.MetodoPago" %>
<%@ page import="modelo.Usuario" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sesion = request.getSession(false);
    Usuario usuario = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;
    List<ZonaDelivery> zonas = (List<ZonaDelivery>) request.getAttribute("zonas");
    List<MetodoPago> metodos = (List<MetodoPago>) request.getAttribute("metodosPago");
    double totalCompra = (request.getAttribute("totalCompra") != null) ? (double) request.getAttribute("totalCompra") : 0.0;

    String tipoEntregaSel = request.getParameter("tipoEntrega");
    String direccionSel = request.getParameter("direccion");
    String idZonaSel = request.getParameter("idZona");
    String metodoSel = request.getParameter("idMetodoPago");

    String numTarjeta = request.getParameter("numeroTarjeta");
    String nomTitular = request.getParameter("nombreTitular");
    String fechaExp = request.getParameter("fechaExpiracion");
    String cvv = request.getParameter("cvv");

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Detalles de Pago</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100 min-h-screen flex flex-col">

        <!-- Navbar -->
        <nav class="bg-white shadow p-3">
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <div class="text-2xl font-bold text-red-700">MÍTIKAS</div>
                <div class="space-x-4">
                    <a href="<%= request.getContextPath() %>/panel-cliente" class="text-gray-700 font-medium hover:text-red-700 transition">Inicio</a>
                    <a href="nosotros.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Sobre nosotros</a>
                    <a href="<%= request.getContextPath() %>/mis-pedidos" class="text-gray-700 font-medium hover:text-red-700 transition">Mis Pedidos</a>
                    <a href="<%= request.getContextPath() %>//userPage/carrito.jsp" class="text-gray-700 font-medium hover:text-red-700 transition">Carrito</a>
                    <a href="<%= request.getContextPath() %>/logout" class="text-gray-700 font-medium hover:text-red-700 transition">Salir</a>
                </div>
                   </div>
        </nav>

        <!-- Contenido -->
        <main class="flex-grow">
            <div class="max-w-3xl mx-auto bg-white shadow-md rounded px-8 py-10 mt-8 mb-12">
                <h2 class="text-2xl font-bold mb-6 text-gray-800 text-center">Detalles de Entrega y Pago</h2>

                <% if (error != null) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 text-center">
                    <strong>Error:</strong> <%= error %>
                </div>
                <% } %>

                <% if (usuario != null) { %>
                <p class="mb-4 text-gray-700 text-center font-medium text-lg">
                    Cliente: <span class="text-red-700 font-bold"><%= usuario.getNombre() %> <%= usuario.getApellidos() %></span>
                </p>
                <% } %>

                <form action="<%= request.getContextPath() %>/FinalizarCompraServlet" method="post">
                    <!-- Tipo de entrega -->
                    <div class="mb-4">
                        <label class="block font-medium mb-1">Tipo de Entrega:</label>
                        <select name="tipoEntrega" id="tipoEntrega" class="w-full px-3 py-2 border rounded" required>
                            <option value="">--- Seleccionar ---</option>
                            <option value="local" <%= "local".equals(tipoEntregaSel) ? "selected" : "" %>>Entrega en Local</option>
                            <option value="domicilio" <%= "domicilio".equals(tipoEntregaSel) ? "selected" : "" %>>Entrega a Domicilio</option>
                        </select>
                    </div>

                    <!-- Dirección local -->
                    <div id="direccionLocal" class="mb-4 hidden">
                        <p class="text-gray-700 text-sm">
                            Dirección del Local:
                            <span class="font-semibold">
                                Av. Aviación 5095, Galería Nuevo Polvos Rosados – Tienda 78 y 79 (frente a la estación Cabitos)
                            </span>
                        </p>
                    </div>

                    <!-- Zona y dirección para domicilio -->
                    <div id="zonaDomicilio" class="mb-4 hidden">
                        <label class="block font-medium">Distrito:</label>
                        <select name="idZona" id="zonaSelect" class="w-full mt-1 px-3 py-2 border rounded">
                            <option value="">--- Seleccionar ---</option>
                            <% if (zonas != null) { for (ZonaDelivery z : zonas) { %>
                            <option value="<%= z.getId() %>" 
                                    data-costo="<%= z.getCosto() %>" 
                                    data-dias="<%= z.getDiasEstimados() %>"
                                    <%= (idZonaSel != null && idZonaSel.equals(String.valueOf(z.getId()))) ? "selected" : "" %>>
                                <%= z.getDistrito() %>
                            </option>
                            <% } } %>
                        </select>

                        <p id="estimacionEntrega" class="text-sm text-blue-600 mt-2 hidden">
                            El pedido se entregará en aproximadamente <span id="diasEntrega"></span> días.
                        </p>
                    </div>

                    <div id="direccionExacta" class="mb-4 hidden">
                        <label class="block font-medium">Dirección Exacta:</label>
                        <input type="text" name="direccion" value="<%= direccionSel != null ? direccionSel : "" %>" class="w-full mt-1 px-3 py-2 border rounded" placeholder="Calle, número, referencia..." />
                    </div>

                    <!-- Métodos de pago -->
                    <div class="mb-4">
                        <label class="block font-medium mb-1">Método de Pago:</label>
                        <select name="idMetodoPago" id="metodoPago" class="w-full px-3 py-2 border rounded" required>
                            <option value="">--- Seleccionar ---</option>
                            <% if (metodos != null) { for (MetodoPago metodo : metodos) { %>
                            <option value="<%= metodo.getId() %>" <%= metodoSel != null && metodoSel.equals(String.valueOf(metodo.getId())) ? "selected" : "" %>>
                                <%= metodo.getMetodo() %>
                            </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Datos de tarjeta -->
                    <div id="datosTarjeta" class="mt-4 hidden border p-4 rounded bg-gray-50">
                        <label class="block mb-2 font-semibold">Número de Tarjeta:</label>
                        <input type="text" name="numeroTarjeta" maxlength="16" class="w-full px-3 py-2 border rounded mb-3" placeholder="Ej: 4111111111111111" value="<%= numTarjeta != null ? numTarjeta : "" %>">

                        <label class="block mb-2 font-semibold">Nombre del Titular:</label>
                        <input type="text" name="nombreTitular" class="w-full px-3 py-2 border rounded mb-3" placeholder="Como figura en la tarjeta" value="<%= nomTitular != null ? nomTitular : "" %>">

                        <div class="flex gap-4">
                            <div class="w-1/2">
                                <label class="block mb-2 font-semibold">Fecha Expiración:</label>
                                <input type="text" name="fechaExpiracion" class="w-full px-3 py-2 border rounded" placeholder="MM/AA" value="<%= fechaExp != null ? fechaExp : "" %>">
                            </div>
                            <div class="w-1/2">
                                <label class="block mb-2 font-semibold">CVV:</label>
                                <input type="text" name="cvv" maxlength="3" class="w-full px-3 py-2 border rounded" placeholder="Ej: 123" value="<%= cvv != null ? cvv : "" %>">
                            </div>
                        </div>
                    </div>

                    <!-- Total con envío -->
                    <div class="bg-gray-100 p-4 rounded mt-6 text-right">
                        <p class="text-lg">
                            Subtotal productos: <span class="font-semibold text-gray-800">S/. <span id="subtotalBase">0.00</span></span>
                        </p>
                        <p class="text-green-600 font-semibold mt-1 hidden" id="filaEnvio">
                            Envío a domicilio: + S/. <span id="envioVisual">0.00</span>
                        </p>
                        <p class="text-xl font-bold text-red-700 mt-2">
                            Total a pagar: S/. <span id="totalFinal">0.00</span>
                        </p>
                    </div>

                    <!-- Botón -->
                    <div class="text-center mt-8">
                        <button type="submit"
                                class="bg-red-600 text-white px-8 py-3 rounded hover:bg-red-700 transition">
                            Finalizar Compra
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-red-700 text-white py-8 mt-12">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col md:flex-row justify-between items-center md:items-start space-y-6 md:space-y-0">
                    <div class="text-center md:text-left">
                        <h2 class="text-xl font-bold">MÍTIKAS</h2>
                        <p class="mt-2 text-sm">Pasión para difundir la artesanía</p>
                    </div>
                    <div class="flex space-x-6">
                        <a href="#" class="hover:underline">Inicio</a>
                        <a href="#" class="hover:underline">Sobre Nosotros</a>
                        <a href="#" class="hover:underline">Ayuda</a>
                        <a href="#" class="hover:underline">Contacto</a>
                    </div>
                    <div class="flex space-x-4">
                        <a href="#" aria-label="Facebook" class="hover:text-gray-300"><svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M22 12a10 10 0 10-11.5 9.87v-7h-3v-3h3v-2.3c0-3 1.8-4.7 4.6-4.7 1.3 0 2.7.24 2.7.24v3h-1.54c-1.52 0-2 1-2 2v2.5h3.4l-.54 3h-2.86v7A10 10 0 0022 12z"/></svg></a>
                        <a href="#" aria-label="Instagram" class="hover:text-gray-300"><svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M7 2C4.8 2 3 3.8 3 6v12c0 2.2 1.8 4 4 4h10c2.2 0 4-1.8 4-4V6c0-2.2-1.8-4-4-4H7zm10 3a1 1 0 110 2 1 1 0 010-2zm-5 2c3.3 0 6 2.7 6 6s-2.7 6-6 6-6-2.7-6-6 2.7-6 6-6zm0 2a4 4 0 100 8 4 4 0 000-8z"/></svg></a>
                        <a href="#" aria-label="Twitter" class="hover:text-gray-300"><svg class="w-6 h-6 fill-current" viewBox="0 0 24 24"><path d="M22 5.9a8.1 8.1 0 01-2.3.6 4 4 0 001.8-2.2 8.2 8.2 0 01-2.6 1 4.1 4.1 0 00-7 3.7 11.7 11.7 0 01-8.5-4.3 4.1 4.1 0 001.3 5.4 4 4 0 01-1.8-.5v.05a4.1 4.1 0 003.3 4 4 4 0 01-1.8.07 4.1 4.1 0 003.8 2.9A8.2 8.2 0 014 19.5a11.6 11.6 0 006.3 1.8c7.5 0 11.6-6.2 11.6-11.6 0-.2 0-.4 0-.6A8.3 8.3 0 0022 5.9z"/></svg></a>
                    </div>
                </div>
                <div class="mt-6 text-center text-sm text-gray-300">
                    &copy; 2025 Mitikas. Todos los derechos reservados.
                </div>
            </div>
        </footer>

        <script>
            const tipoEntrega = document.getElementById("tipoEntrega");
            const zonaDomicilio = document.getElementById("zonaDomicilio");
            const zonaSelect = document.getElementById("zonaSelect");
            const direccionExacta = document.getElementById("direccionExacta");
            const direccionLocal = document.getElementById("direccionLocal");
            const metodoPago = document.getElementById("metodoPago");
            const datosTarjeta = document.getElementById("datosTarjeta");
            const costoEnvioValor = document.getElementById("envioVisual");
            const filaEnvio = document.getElementById("filaEnvio");
            const estimacion = document.getElementById("estimacionEntrega");
            const spanDias = document.getElementById("diasEntrega");

            let subtotalCompra = <%= totalCompra %>;
            document.getElementById("subtotalBase").textContent = subtotalCompra.toFixed(2);
            document.getElementById("totalFinal").textContent = subtotalCompra.toFixed(2);

            function mostrarElementosEntrega() {
                const valor = tipoEntrega.value;
                if (valor === "domicilio") {
                    zonaDomicilio.classList.remove("hidden");
                    direccionExacta.classList.remove("hidden");
                    direccionLocal.classList.add("hidden");
                    filaEnvio.classList.remove("hidden");
                    actualizarCosto();
                } else {
                    zonaDomicilio.classList.add("hidden");
                    direccionExacta.classList.add("hidden");
                    direccionLocal.classList.remove("hidden");
                    filaEnvio.classList.add("hidden");
                    estimacion.classList.add("hidden");
                    document.getElementById("totalFinal").textContent = subtotalCompra.toFixed(2);
                }
            }

            tipoEntrega.addEventListener("change", mostrarElementosEntrega);
            zonaSelect.addEventListener("change", actualizarCosto);

            function actualizarCosto() {
                const selected = zonaSelect.options[zonaSelect.selectedIndex];
                const costo = selected.getAttribute("data-costo") || "0.00";
                const dias = selected.getAttribute("data-dias") || null;
                const costoFloat = parseFloat(costo);
                costoEnvioValor.textContent = costoFloat.toFixed(2);
                const totalConEnvio = subtotalCompra + costoFloat;
                document.getElementById("totalFinal").textContent = totalConEnvio.toFixed(2);
                if (dias) {
                    spanDias.textContent = dias;
                    estimacion.classList.remove("hidden");
                } else {
                    estimacion.classList.add("hidden");
                }
            }

            metodoPago.addEventListener("change", function () {
                const texto = metodoPago.options[metodoPago.selectedIndex].text.toLowerCase();
                if (texto.includes("tarjeta")) {
                    datosTarjeta.classList.remove("hidden");
                } else {
                    datosTarjeta.classList.add("hidden");
                }
            });

            if ("<%= tipoEntregaSel %>" === "domicilio") {
                mostrarElementosEntrega();
            }
            if ("<%= metodoSel %>" === "1") {
                datosTarjeta.classList.remove("hidden");
            }
        </script>

    </body>
</html>
