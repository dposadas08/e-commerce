-- =============================
--        DROP DE TABLAS
-- =============================
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS pago CASCADE;
DROP TABLE IF EXISTS cupon CASCADE;
DROP TABLE IF EXISTS detalle_pedido CASCADE;
DROP TABLE IF EXISTS producto CASCADE;
DROP TABLE IF EXISTS subcategoria CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS direccion CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

-- =============================
--      CREACIÓN DE TABLAS
-- =============================

-- --------------------
-- >> Tabla: USUARIO <<
-- --------------------
CREATE TABLE usuario (
  usuario_id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  dni CHAR(8) UNIQUE NOT NULL,
  correo VARCHAR(200) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  rol VARCHAR(20) NOT NULL CHECK (rol IN ('cliente', 'administrador')),
  fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- ----------------------
-- >> Tabla: DIRECCIÓN <<
-- ----------------------
CREATE TABLE direccion (
  direccion_id SERIAL PRIMARY KEY,
  direccion TEXT NOT NULL,
  ciudad VARCHAR(100) NOT NULL,
  provincia VARCHAR(100) NOT NULL,
  codigo_postal VARCHAR(20),
  pais VARCHAR(100) NOT NULL,
  fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  usuario_id INT NOT NULL REFERENCES usuario(usuario_id),
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- ----------------------
-- >> Tabla: CATEGORÍA <<
-- ----------------------
CREATE TABLE categoria (
  categoria_id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- -------------------------
-- >> Tabla: SUBCATEGORÍA <<
-- -------------------------
CREATE TABLE subcategoria (
  subcategoria_id SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  categoria_id INT NOT NULL REFERENCES categoria(categoria_id),
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- ---------------------
-- >> Tabla: PRODUCTO <<
-- ---------------------
CREATE TABLE producto (
  producto_id SERIAL PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  imagen_url VARCHAR(255),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  subcategoria_id INT NOT NULL REFERENCES subcategoria(subcategoria_id),
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- ------------------
-- >> Tabla: CUPÓN <<
-- ------------------
CREATE TABLE cupon (
  cupon_id SERIAL PRIMARY KEY,
  codigo VARCHAR(255) NOT NULL UNIQUE,
  porcentaje_descuento NUMERIC(5, 2) NOT NULL CHECK (porcentaje_descuento >= 0 AND porcentaje_descuento <= 100),
  fecha_expiracion TIMESTAMP NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT TRUE,
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- -------------------
-- >> Tabla: PEDIDO <<
-- -------------------
CREATE TABLE pedido (
  pedido_id SERIAL PRIMARY KEY,
  numero_documento VARCHAR(30) UNIQUE NOT NULL,
  usuario_id INT NOT NULL REFERENCES usuario(usuario_id),
  direccion_id INT NOT NULL REFERENCES direccion(direccion_id),
  estado_pedido VARCHAR(20) NOT NULL DEFAULT 'pendiente' CHECK (estado_pedido IN ('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado')),
  codigo_cupon VARCHAR(255) UNIQUE DEFAULT NULL,
  cupon_id INT REFERENCES cupon(cupon_id) DEFAULT NULL,
  subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
  descuento_aplicado DECIMAL(10, 2) DEFAULT 0,
  total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
  fecha_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- ------------------------------
-- >> Tabla: DETALLE DE PEDIDO <<
-- ------------------------------
CREATE TABLE detalle_pedido (
  detalle_pedido_id SERIAL PRIMARY KEY,
  pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
  producto_id INT NOT NULL REFERENCES producto(producto_id),
  cantidad INT NOT NULL CHECK (cantidad >= 0),
  precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- -----------------
-- >> Tabla: PAGO <<
-- -----------------
CREATE TABLE pago (
  pago_id SERIAL PRIMARY KEY,
  pedido_id INT NOT NULL REFERENCES pedido(pedido_id),
  metodo_pago VARCHAR(20) DEFAULT NULL CHECK (metodo_pago IN ('tarjeta_credito', 'tarjeta_debito', 'paypal', 
  'transferencia', 'mercado_pago', 'cripto', 'apple_pay', 'google_pay', 'pago_contra_entrega', 'otro')),
  estado_pago VARCHAR(20) DEFAULT 'pendiente' CHECK (estado_pago IN ('pendiente', 'completado', 'fallido',
  'cancelado', 'reembolsado')),
  fecha_pago TIMESTAMP DEFAULT NULL,
  monto DECIMAL(10, 2) DEFAULT 0 CHECK (monto >= 0),
  estado CHAR(1) NOT NULL DEFAULT '1' CHECK (estado IN ('0', '1'))
);

-- =============================
--       INSERCIÓN DE DATOS
-- =============================

-- ------------------------
-- >> Inserción: USUARIO <<
-- ------------------------
INSERT INTO usuario (nombre, apellido, dni, correo, password, rol)
VALUES 
('Ana', 'Admin', '12345678', 'ana.admin@example.com', '$2b$10$1dUQEnq.1QuNmj4EWIeSVOFOZrTkwY1WiKg2aCurUisBy5MtmehgG', 'administrador'),
('Carlos', 'Cliente', '23456789', 'carlos.cliente@example.com', '$2b$10$1dUQEnq.1QuNmj4EWIeSVOFOZrTkwY1WiKg2aCurUisBy5MtmehgG', 'cliente'),
('Lucía', 'Lopez', '34567890', 'lucia.lopez@example.com', '$2b$10$1dUQEnq.1QuNmj4EWIeSVOFOZrTkwY1WiKg2aCurUisBy5MtmehgG', 'cliente');

-- --------------------------
-- >> Inserción: DIRECCIÓN <<
-- --------------------------
INSERT INTO direccion (direccion, ciudad, provincia, codigo_postal, pais, usuario_id)
VALUES
('Av. Siempre Viva 742', 'Lima', 'Lima', '15001', 'Perú', 2),
('Calle Falsa 123', 'Arequipa', 'Arequipa', '04001', 'Perú', 3);

-- --------------------------
-- >> Inserción: CATEGORÍA <<
-- --------------------------
INSERT INTO categoria (nombre, descripcion)
VALUES
('Ropa', 'Ropa para hombre y mujer'),
('Calzado', 'Zapatos, zapatillas y botas'),
('Accesorios', 'Mochilas, gorras y más');

-- -----------------------------
-- >> Inserción: SUBCATEGORÍA <<
-- -----------------------------
INSERT INTO subcategoria (nombre, descripcion, categoria_id)
VALUES
('Camisetas', 'Todo tipo de camisetas', 1),
('Zapatillas', 'Zapatillas deportivas', 2),
('Mochilas', 'Mochilas escolares y de viaje', 3);

-- -------------------------
-- >> Inserción: PRODUCTO <<
-- -------------------------
INSERT INTO producto (nombre, descripcion, precio, stock, imagen_url, subcategoria_id)
VALUES
('Camiseta Blanca', 'Camiseta de algodón blanca talla M', 19.99, 50, 'https://example.com/camiseta.jpg', 1),
('Zapatillas Deportivas', 'Zapatillas para correr talla 42', 49.99, 30, 'https://example.com/zapatillas.jpg', 2),
('Mochila Escolar', 'Mochila resistente para estudiantes', 29.99, 20, 'https://example.com/mochila.jpg', 3);

-- ----------------------
-- >> Inserción: CUPÓN <<
-- ----------------------
INSERT INTO cupon (codigo, porcentaje_descuento, fecha_expiracion, activo)
VALUES
('DESC10', 10.00, '2025-12-31 23:59:59', TRUE),
('VERANO25', 25.00, '2025-09-30 23:59:59', FALSE),
('INACTIVO50', 50.00, '2025-10-15 23:59:59', TRUE);

-- -----------------------
-- >> Inserción: PEDIDO <<
-- -----------------------
INSERT INTO pedido (numero_documento, usuario_id, direccion_id, estado_pedido, codigo_cupon, cupon_id, subtotal, descuento_aplicado, total)
VALUES
('BOL-20250918-00010', 2, 1, 'pagado', 'VERANO25', 2, 89.97, 22.49, 67.48),
('BOL-20250918-00011', 3, 2, 'pendiente', NULL, NULL, 29.99, 0, 29.99);

-- ----------------------------------
-- >> Inserción: DETALLE DE PEDIDO <<
-- ----------------------------------
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario)
VALUES
(1, 1, 2, 19.99), -- 2 camisetas
(1, 2, 1, 49.99), -- 1 par de zapatillas
(2, 3, 1, 29.99);  -- 1 mochila

-- ---------------------
-- >> Inserción: PAGO <<
-- ---------------------
INSERT INTO pago (pedido_id, metodo_pago, estado_pago, monto, fecha_pago)
VALUES
(1, 'tarjeta_credito', 'completado', 69.98, '2025-09-15 14:30:00'),
(2, 'paypal', 'pendiente', 29.99, '2025-09-16 10:00:00');