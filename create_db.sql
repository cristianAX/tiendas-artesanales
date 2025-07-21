CREATE DATABASE IF NOT EXISTS tienda_productos_artesania;
USE tienda_productos_artesania;

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
    FOREIGN KEY (idCategoria) REFERENCES categorias(id)
);

CREATE TABLE variantes_producto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    tamaño VARCHAR(50),
    precio_venta DECIMAL(10,2),
    stock INT,
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

create TABLE zonas_delivery (
    id INT AUTO_INCREMENT PRIMARY KEY,
    distrito VARCHAR(100),
    costo DECIMAL(10,2),
    dias_estimados INT
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME,
    nombre VARCHAR(80),
    apellido VARCHAR(80),
    direccion VARCHAR(100),
    idZonaDelivery INT,
	costo_envio DECIMAL(10,2),
proceso ENUM('solicitud_recibida', 'en_preparacion', 'en_camino', 'entregado' ) DEFAULT 'solicitud_recibida',
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
    FOREIGN KEY (idPedido) REFERENCES pedidos(id),
    FOREIGN KEY (idProducto) REFERENCES productos(id),
    FOREIGN KEY (idVariante) REFERENCES variantes_producto(id)
);


ALTER TABLE productos ADD COLUMN activo BOOLEAN DEFAULT true;
ALTER TABLE variantes_producto ADD COLUMN activo BOOLEAN DEFAULT true;
ALTER TABLE zonas_delivery ADD COLUMN activo BOOLEAN DEFAULT true;

-- Añadir columna idPromocion a la tabla detalle_pedido si no existe
ALTER TABLE detalle_pedido
ADD COLUMN idPromocion INT NULL,
ADD CONSTRAINT fk_detalle_pedido_promocion
FOREIGN KEY (idPromocion) REFERENCES promociones(id);

