-- Script SQL COMPLETO para la Tienda de Ventas Artesanales
-- Base de datos: tienda_productos_artesania
-- Fecha: 14 de julio de 2025
-- IMPORTANTE: Este script elimina y recrea todas las tablas

USE tienda_productos_artesania;

-- ============================================
-- 0. ELIMINAR TODAS LAS TABLAS (en orden correcto por FK)
-- ============================================

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS detalle_pedido;
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS carrito;
DROP TABLE IF EXISTS promociones_variantes;
DROP TABLE IF EXISTS promociones;
DROP TABLE IF EXISTS variantes_producto;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS tarjetas_simuladas;
DROP TABLE IF EXISTS zonas_delivery;
DROP TABLE IF EXISTS metodosPago;
DROP TABLE IF EXISTS usuarios;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. RECREAR TODAS LAS TABLAS
-- ============================================

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60),
    apellidos VARCHAR(60),
    dni CHAR(8) UNIQUE,
    telefono VARCHAR(15),
    correo VARCHAR(80) UNIQUE,
    password VARCHAR(100),
    rol ENUM('user', 'admin') DEFAULT 'user'
);

CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    categoria VARCHAR(100),
    imagen VARCHAR(150)
);

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    imagen VARCHAR(150),
    idCategoria INT,
    activo BOOLEAN DEFAULT true,
    FOREIGN KEY (idCategoria) REFERENCES categorias(id)
);

CREATE TABLE variantes_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    tamaño VARCHAR(50),
    precio_venta DECIMAL(10,2),
    stock INT,
    activo BOOLEAN DEFAULT true,
    FOREIGN KEY (id_producto) REFERENCES productos(id)
);

CREATE TABLE promociones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo ENUM('porcentaje', 'precio_fijo') NOT NULL,
    valor DECIMAL(5,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

CREATE TABLE promociones_variantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_promocion INT NOT NULL,
    id_variante INT NOT NULL,
    UNIQUE (id_promocion, id_variante),
    FOREIGN KEY (id_promocion) REFERENCES promociones(id) ON DELETE CASCADE,
    FOREIGN KEY (id_variante) REFERENCES variantes_producto(id) ON DELETE CASCADE
);

CREATE TABLE carrito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idUsuario INT NOT NULL,
    idProducto INT NOT NULL,
    idVariante INT NOT NULL,
    cantidad INT NOT NULL,
    idPromocion INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(id),
    FOREIGN KEY (idProducto) REFERENCES productos(id),
    FOREIGN KEY (idVariante) REFERENCES variantes_producto(id),
    FOREIGN KEY (idPromocion) REFERENCES promociones(id)
);

CREATE TABLE metodosPago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metodo VARCHAR(50) NOT NULL
);

CREATE TABLE tarjetas_simuladas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_tarjeta CHAR(16),
    nombre_titular VARCHAR(100),
    fecha_expiracion CHAR(5),
    cvv CHAR(3),
    saldo DECIMAL(10,2),
    idUsuario INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(id)
);

CREATE TABLE zonas_delivery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    distrito VARCHAR(100),
    costo DECIMAL(10,2),
    dias_estimados INT,
    activo BOOLEAN DEFAULT true
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    nombre VARCHAR(80),
    apellido VARCHAR(80),
    direccion VARCHAR(100),
    idZonaDelivery INT,
    costo_envio DECIMAL(10,2),
    proceso ENUM('solicitud_recibida', 'en_preparacion', 'en_camino', 'entregado') DEFAULT 'solicitud_recibida',
    idUsuario INT,
    idMetodoPago INT,
    FOREIGN KEY (idUsuario) REFERENCES usuarios(id),
    FOREIGN KEY (idMetodoPago) REFERENCES metodosPago(id),
    FOREIGN KEY (idZonaDelivery) REFERENCES zonas_delivery(id)
);

CREATE TABLE detalle_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT,
    idProducto INT,
    idVariante INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    estado ENUM('confirmado', 'pendiente') DEFAULT 'confirmado',
    idPromocion INT NULL,
    FOREIGN KEY (idPedido) REFERENCES pedidos(id),
    FOREIGN KEY (idProducto) REFERENCES productos(id),
    FOREIGN KEY (idVariante) REFERENCES variantes_producto(id),
    FOREIGN KEY (idPromocion) REFERENCES promociones(id)
);

-- ============================================
-- 2. INSERTAR CATEGORÍAS
-- ============================================

INSERT INTO categorias (categoria, imagen) VALUES
('Cerámica', 'ceramica.png'),
('Retablos', 'retablos.png'),
('Peluches', 'peluches.png'),
('Juegos', 'juegos.png'),
('Piscos', 'piscos.png'),
('Decoración', 'decoracion.png');

-- ============================================
-- 3. INSERTAR PRODUCTOS
-- ============================================

-- Productos de Cerámica (idCategoria = 1)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Torito de Pucará', 'Artesanía en cerámica, colores variados, altura 19 cm.', 'toritoPucara.png', 1, true),
('Ekeko de cerámica', 'Ekeko tradicional de cerámica ayacuchana, 16 cm.', 'ekeko.png', 1, true),
('Llamita con chuyo', 'Figura decorativa de llama con chuyo, altura 14 cm', 'llamita.png', 1, true);

-- Productos de Retablos (idCategoria = 2)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Retablo Nacimiento', 'Retablo ayacuchano tradicional, 13 x 22 cm.', 'retabloNacimiento.png', 2, true);

-- Productos de Peluches (idCategoria = 3)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Peluche de cuy macho', 'Peluche artesanal de cuy macho, altura 28 cm.', 'pelucheCuyMacho.png', 3, true);

-- Productos de Juegos (idCategoria = 4)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Ajedrez Incas vs. Españoles', 'Juego de mesa 36 x 36 cm.', 'ajedrez.png', 4, true);

-- Productos de Piscos (idCategoria = 5)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Pisco Tumi', 'Pisco para regalo, 50 ml, altura 21 cm.', 'piscoTumi.png', 5, true);

-- Productos de Decoración (idCategoria = 6)
INSERT INTO productos (nombre, descripcion, imagen, idCategoria, activo) VALUES
('Espejo Cuscajo Circular', 'Espejo decorativo circular, 32 cm de diámetro.', 'espejoCuscajo.png', 6, true);

-- ============================================
-- 4. INSERTAR VARIANTES DE PRODUCTOS
-- ============================================

-- Variantes para Torito de Pucará (id_producto = 1)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(1, 'Único', 37.00, 15, true);

-- Variantes para Ekeko de cerámica (id_producto = 2)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(2, 'Único', 48.00, 12, true);

-- Variantes para Llamita con chuyo (id_producto = 3)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(3, 'Único', 39.00, 20, true);

-- Variantes para Retablo Nacimiento (id_producto = 4)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(4, 'Único', 188.00, 5, true);

-- Variantes para Peluche de cuy macho (id_producto = 5)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(5, 'Único', 42.00, 25, true);

-- Variantes para Ajedrez Incas vs. Españoles (id_producto = 6)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(6, 'Único', 188.00, 8, true);

-- Variantes para Pisco Tumi (id_producto = 7)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(7, 'Único', 29.00, 30, true);

-- Variantes para Espejo Cuscajo Circular (id_producto = 8)
INSERT INTO variantes_producto (id_producto, tamaño, precio_venta, stock, activo) VALUES
(8, 'Único', 79.00, 10, true);

-- ============================================
-- 5. INSERTAR DATOS BÁSICOS ADICIONALES
-- ============================================

-- Métodos de pago
INSERT INTO metodosPago (metodo) VALUES
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Transferencia Bancaria'),
('Efectivo contra entrega');

-- Zonas de delivery
INSERT INTO zonas_delivery (distrito, costo, dias_estimados, activo) VALUES
('Lima Centro', 5.00, 1, true),
('San Isidro', 8.00, 1, true),
('Miraflores', 8.00, 1, true),
('Surco', 10.00, 2, true),
('La Molina', 12.00, 2, true),
('Callao', 15.00, 3, true);

-- Usuario administrador por defecto
INSERT INTO usuarios (nombre, apellidos, dni, telefono, correo, password, rol) VALUES
('Admin', 'Sistema', '12345678', '999888777', 'admin@tienda.com', 'admin123', 'admin');

-- Usuario cliente de prueba
INSERT INTO usuarios (nombre, apellidos, dni, telefono, correo, password, rol) VALUES
('Juan Carlos', 'Pérez García', '87654321', '987654321', 'cliente@email.com', 'cliente123', 'user');

-- ============================================
-- 6. VERIFICAR DATOS INSERTADOS
-- ============================================

-- Consultar categorías insertadas
SELECT 'CATEGORÍAS INSERTADAS:' as TABLA;
SELECT id, categoria, imagen FROM categorias ORDER BY id;

-- Consultar productos insertados
SELECT 'PRODUCTOS INSERTADOS:' as TABLA;
SELECT p.id, p.nombre, p.descripcion, p.imagen, c.categoria as categoria, p.activo 
FROM productos p 
INNER JOIN categorias c ON p.idCategoria = c.id 
ORDER BY p.id;

-- Consultar variantes insertadas
SELECT 'VARIANTES INSERTADAS:' as TABLA;
SELECT v.id, p.nombre as producto, v.tamaño, v.precio_venta, v.stock, v.activo
FROM variantes_producto v
INNER JOIN productos p ON v.id_producto = p.id
ORDER BY v.id;

-- Consultar métodos de pago
SELECT 'MÉTODOS DE PAGO:' as TABLA;
SELECT * FROM metodosPago;

-- Consultar zonas de delivery
SELECT 'ZONAS DE DELIVERY:' as TABLA;
SELECT * FROM zonas_delivery WHERE activo = true;

-- Consultar usuarios
SELECT 'USUARIOS CREADOS:' as TABLA;
SELECT id, nombre, apellidos, correo, rol FROM usuarios;

-- ============================================
-- 7. CONSULTAS ÚTILES PARA VERIFICACIÓN
-- ============================================

-- Productos por categoría
SELECT 'PRODUCTOS POR CATEGORÍA:' as CONSULTA;
SELECT c.categoria, COUNT(p.id) as total_productos
FROM categorias c
LEFT JOIN productos p ON c.id = p.idCategoria AND p.activo = true
GROUP BY c.id, c.categoria
ORDER BY c.categoria;

-- Resumen de stock total
SELECT 'STOCK TOTAL POR PRODUCTO:' as CONSULTA;
SELECT p.nombre, SUM(v.stock) as stock_total, AVG(v.precio_venta) as precio_promedio
FROM productos p
INNER JOIN variantes_producto v ON p.id = v.id_producto
WHERE p.activo = true AND v.activo = true
GROUP BY p.id, p.nombre
ORDER BY p.nombre;

-- Valor total del inventario
SELECT 'VALOR TOTAL DEL INVENTARIO:' as CONSULTA;
SELECT SUM(v.stock * v.precio_venta) as valor_total_inventario
FROM productos p
INNER JOIN variantes_producto v ON p.id = v.id_producto
WHERE p.activo = true AND v.activo = true;

-- ============================================
-- NOTAS IMPORTANTES PARA CONFIGURACIÓN:
-- ============================================

/*
✅ PASOS PARA COMPLETAR LA CONFIGURACIÓN:

1. **COPIAR IMÁGENES**:
   Copiar archivos desde:
   
   📁 CATEGORÍAS:
   DESDE: C:\Users\jackd\Downloads\Tienda_Ventas_Artesanales (3)\Tienda_Ventas_Artesanales\extra\Categorias\img\
   HACIA: [Directorio de imágenes de tu aplicación web]
   
   Archivos a copiar:
   - ceramica.png
   - retablos.png
   - peluches.png
   - juegos.png
   - piscos.png
   - decoracion.png
   
   📁 PRODUCTOS:
   DESDE: C:\Users\jackd\Downloads\Tienda_Ventas_Artesanales (3)\Tienda_Ventas_Artesanales\extra\Productos\img\
   HACIA: [Directorio de imágenes de tu aplicación web]
   
   Archivos a copiar:
   - toritoPucara.png
   - ekeko.png
   - llamita.png
   - retabloNacimiento.png
   - pelucheCuyMacho.png
   - ajedrez.png
   - piscoTumi.png
   - espejoCuscajo.png

2. **CONFIGURAR DIRECTORIO DE IMÁGENES**:
   Asegúrate de que tu aplicación Java apunte al directorio correcto.
   Revisa el archivo de configuración: CrudCategoria.java y CrudProductos.java
   
3. **CREDENCIALES DE ACCESO**:
   - Admin: admin@tienda.com / admin123
   - Cliente: cliente@email.com / cliente123

4. **EJECUCIÓN**:
   Este script recrea completamente la base de datos.
   ⚠️ ADVERTENCIA: Eliminará todos los datos existentes.

5. **VERIFICACIÓN**:
   Después de ejecutar, revisar las consultas de verificación incluidas.
*/
