<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="style.css" />
    <title>Bienvenido</title>
  </head>

  <body>
    <div class="container" id="container">
      <!-- regsitro -->
      <div class="form-container sign-up">
        <form action="registro" method="post">
          <h1>Crea tu cuenta</h1>
          <span>Usa tu email para regsitrarte</span>
          <input type="text" name="nombre" placeholder="Nombre" required />
          <input type="text" name="apellidos" placeholder="Apellido" required />
          <input type="text" name="dni" placeholder="DNI" required />
          <input type="text" name="telefono" placeholder="Celular" required />
          <input type="email" name="correo" placeholder="Email" required />
          <input type="password" name="password" placeholder="Password" required />
          <button type="submit"> Registrar </button>
        </form>
      </div>

      <!-- login -->
      <div class="form-container sign-in">
        <form action="login" method="post">
          <h1> Iniciar sesión</h1>
          <br>
          <span> Ingresa tu email y contraseña </span>
          <input type="email" name="correo" placeholder="Email" required />
          <input type="password" name="password" placeholder="Password" required />
          <button type="submit"> Iniciar sesión </button>
          <% if (request.getAttribute("error") != null) { %>
            <p style="color:red;"><%= request.getAttribute("error") %></p>
          <% } %>
        </form>
      </div>

     
      <div class="toggle-container">
        <div class="toggle">
          <div class="toggle-panel toggle-left">
            <h1>Bienvenido de nuevo!</h1>
            <p><p>¡Te estábamos esperando! Inicia sesión para seguir donde lo dejaste.</p>
            <button class="hidden" id="login"> Iniciar sesión </button>
          </div>
          <div class="toggle-panel toggle-right">
            <h1>Hola!</h1>
            <p><p>¿Listo para unirte? Solo unos pasos y estarás dentro.</p>
            <button class="hidden" id="register">Registrarse</button>
          </div>
        </div>
      </div>
    </div>

    <script>
      const container = document.getElementById("container");
      const registerBtn = document.getElementById("register");
      const loginBtn = document.getElementById("login");

      registerBtn.addEventListener("click", () => {
        container.classList.add("active");
      });

      loginBtn.addEventListener("click", () => {
        container.classList.remove("active");
      });
    </script>
  </body>
</html>
