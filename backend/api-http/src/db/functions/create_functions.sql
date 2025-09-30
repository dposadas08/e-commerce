-- ===============================
--        DROP DE FUNCIONES
-- ===============================
DO $$
DECLARE
    r RECORD;
BEGIN
	FOR r IN
		SELECT
			n.nspname AS schema,
			p.proname AS function_name,
			pg_get_function_identity_arguments(p.oid) AS args
		FROM pg_proc p
		JOIN pg_namespace n ON p.pronamespace = n.oid
		WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
	LOOP
		EXECUTE format('DROP FUNCTION IF EXISTS %I.%I(%s) CASCADE;',
					   r.schema, r.function_name, r.args);
	END LOOP;
END $$;

-- ======================================
--      CREACIÓN DE FUNCIONES (CRUD)
-- ======================================

-- --------------------
-- >> Tabla: USUARIO <<
-- --------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_usuario(
  p_nombre VARCHAR,
  p_apellido VARCHAR,
  p_dni CHAR(8),
  p_correo VARCHAR,
  p_password VARCHAR,
  p_rol VARCHAR
)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
	fecha_registro TIMESTAMP, 
	activo BOOLEAN
) 
LANGUAGE plpgsql
AS $$ 
BEGIN
  RETURN QUERY
    INSERT INTO usuario(nombre, apellido, dni, correo, password, rol)
    VALUES (p_nombre, p_apellido, p_dni, p_correo, p_password, p_rol)
    RETURNING 
      usuario.usuario_id,
      usuario.nombre,
      usuario.apellido,
      usuario.dni,
      usuario.correo,
      usuario.password,
      usuario.rol,
      usuario.fecha_registro,
      usuario.activo;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_usuarios()
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
	fecha_registro TIMESTAMP, 
	activo BOOLEAN
) 
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY 
    SELECT u.usuario_id, u.nombre, u.apellido, u.dni, u.correo, u.password, u.rol, u.fecha_registro, u.activo 
    FROM usuario u
    WHERE u.estado = '1'
		ORDER BY u.usuario_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_usuario_por_id(p_usuario_id INT)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
	fecha_registro TIMESTAMP, 
	activo BOOLEAN
) 
AS $$
BEGIN
	RETURN QUERY 
     SELECT u.usuario_id, u.nombre, u.apellido, u.dni, u.correo, u.password, u.rol, u.fecha_registro, u.activo 
     FROM usuario u
    WHERE u.usuario_id = p_usuario_id AND u.estado = '1';
END
$$
LANGUAGE plpgsql;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_usuarios_por_campo(p_json JSON)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
  fecha_registro TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'usuario' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "usuario"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('u.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       u.usuario_id,
       u.nombre,
       u.apellido,
       u.dni,
       u.correo,
       u.password,
       u.rol,
       u.fecha_registro,
       u.activo
     FROM usuario u
     WHERE %s AND u.estado = ''1''
     ORDER BY u.usuario_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_usuario(
  p_usuario_id INT,
  p_nombre VARCHAR,
  p_apellido VARCHAR,
  p_dni CHAR(8),
  p_correo VARCHAR,
  p_password VARCHAR,
  p_rol VARCHAR,
	p_activo BOOLEAN
)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
	fecha_registro TIMESTAMP, 
	activo BOOLEAN
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE usuario u
    SET nombre   = p_nombre,
        apellido = p_apellido,
        dni      = p_dni,
        correo   = p_correo,
        password = p_password,
        rol      = p_rol,
        activo   = p_activo
    WHERE u.usuario_id = p_usuario_id
    RETURNING 
			u.usuario_id,
			u.nombre,
			u.apellido,
			u.dni,
			u.correo,
			u.password,
			u.rol,
			u.fecha_registro,
			u.activo;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_usuario_por_id(p_usuario_id INT, p_json JSON)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
  fecha_registro TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN 
    SELECT * FROM json_object_keys(p_json)
  LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'usuario' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "usuario"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN 
    SELECT * FROM json_object_keys(p_json)
  LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE usuario u
     SET %s
     WHERE u.usuario_id = $1
     RETURNING 
       u.usuario_id,
       u.nombre,
       u.apellido,
       u.dni,
       u.correo,
       u.password,
       u.rol,
       u.fecha_registro,
       u.activo',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_usuario_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_usuario(p_usuario_id INT)
RETURNS TABLE (
  usuario_id INT,
  nombre VARCHAR,
  apellido VARCHAR,
  dni CHAR(8),
  correo VARCHAR,
  password VARCHAR,
  rol VARCHAR,
	fecha_registro TIMESTAMP, 
	activo BOOLEAN
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE usuario u
    SET estado = '0'
    WHERE u.usuario_id = p_usuario_id
    RETURNING
      u.usuario_id,
      u.nombre,
      u.apellido,
      u.dni,
      u.correo,
      u.password,
      u.rol,
			u.fecha_registro,
			u.activo;
END
$$;

-- -----------------------
-- >> Tabla: DIRECCIÓN <<
-- -----------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_direccion(
  p_direccion TEXT,
  p_ciudad VARCHAR,
  p_provincia VARCHAR,
  p_codigo_postal VARCHAR,
  p_pais VARCHAR,
  p_usuario_id INT
)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO direccion(direccion, ciudad, provincia, codigo_postal, pais, usuario_id)
    VALUES (p_direccion, p_ciudad, p_provincia, p_codigo_postal, p_pais, p_usuario_id)
    RETURNING 
      direccion.direccion_id, 
      direccion.direccion, 
      direccion.ciudad, 
      direccion.provincia, 
      direccion.codigo_postal, 
      direccion.pais, 
      direccion.fecha_registro, 
      direccion.usuario_id, 
      direccion.activo;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_direcciones()
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY 
    SELECT d.direccion_id, d.direccion, d.ciudad, d.provincia, d.codigo_postal, d.pais,
           d.fecha_registro, d.usuario_id, d.activo
    FROM direccion d
    WHERE d.estado = '1'
		ORDER BY d.direccion_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_direccion_por_id(p_direccion_id INT)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY 
    SELECT d.direccion_id, d.direccion, d.ciudad, d.provincia, d.codigo_postal, d.pais,
           d.fecha_registro, d.usuario_id, d.activo
    FROM direccion d
    WHERE d.direccion_id = p_direccion_id AND d.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_direcciones_por_campo(p_json JSON)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'direccion' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "direccion"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('d.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       d.direccion_id,
       d.direccion,
       d.ciudad,
       d.provincia,
       d.codigo_postal,
       d.pais,
       d.fecha_registro,
       d.usuario_id,
       d.activo
     FROM direccion d
     WHERE %s AND d.estado = ''1''
     ORDER BY d.direccion_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_direccion(
  p_direccion_id INT,
  p_direccion TEXT,
  p_ciudad VARCHAR,
  p_provincia VARCHAR,
  p_codigo_postal VARCHAR,
  p_pais VARCHAR,
  p_usuario_id INT,
  p_activo BOOLEAN
)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE direccion d
    SET direccion     = p_direccion,
        ciudad        = p_ciudad,
        provincia     = p_provincia,
        codigo_postal = p_codigo_postal,
        pais          = p_pais,
        usuario_id    = p_usuario_id,
        activo        = p_activo
    WHERE d.direccion_id = p_direccion_id
    RETURNING 
      d.direccion_id, d.direccion, d.ciudad, d.provincia, d.codigo_postal, 
      d.pais, d.fecha_registro, d.usuario_id, d.activo;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_direccion_por_id(p_direccion_id INT, p_json JSON)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'direccion' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "direccion"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE direccion d
     SET %s
     WHERE d.direccion_id = $1
     RETURNING 
       d.direccion_id, d.direccion, d.ciudad, d.provincia, d.codigo_postal,
       d.pais, d.fecha_registro, d.usuario_id, d.activo',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_direccion_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_direccion(p_direccion_id INT)
RETURNS TABLE (
  direccion_id INT,
  direccion TEXT,
  ciudad VARCHAR,
  provincia VARCHAR,
  codigo_postal VARCHAR,
  pais VARCHAR,
  fecha_registro TIMESTAMP,
  usuario_id INT,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE direccion d
    SET estado = '0'
    WHERE d.direccion_id = p_direccion_id
    RETURNING 
      d.direccion_id, d.direccion, d.ciudad, d.provincia, d.codigo_postal,
      d.pais, d.fecha_registro, d.usuario_id, d.activo;
END
$$;

-- ---------------------
-- >> Tabla: PRODUCTO <<
-- ---------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_producto(
  p_nombre VARCHAR,
  p_descripcion TEXT,
  p_precio DECIMAL,
  p_stock INT,
  p_imagen_url VARCHAR,
  p_subcategoria_id INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  subcategoria_id INT,
  fecha_creacion TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO producto(nombre, descripcion, precio, stock, imagen_url, subcategoria_id)
    VALUES (p_nombre, p_descripcion, p_precio, p_stock, p_imagen_url, p_subcategoria_id)
    RETURNING 
      producto.producto_id, 
      producto.nombre, 
      producto.descripcion, 
      producto.precio, 
      producto.stock, 
      producto.imagen_url, 
      producto.subcategoria_id,
      producto.fecha_creacion;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_productos()
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  subcategoria_id INT,
  fecha_creacion TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT p.producto_id, p.nombre, p.descripcion, p.precio, p.stock,
           p.imagen_url, p.subcategoria_id, p.fecha_creacion
    FROM producto p
    WHERE p.estado = '1'
		ORDER BY p.producto_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_producto_por_id(p_producto_id INT)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  subcategoria_id INT,
  fecha_creacion TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT p.producto_id, p.nombre, p.descripcion, p.precio, p.stock,
           p.imagen_url, p.subcategoria_id, p.fecha_creacion
    FROM producto p
    WHERE p.producto_id = p_producto_id AND p.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_productos_por_campo(p_json JSON)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  fecha_creacion TIMESTAMP,
  subcategoria_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'producto' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "producto"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('p.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       p.producto_id,
       p.nombre,
       p.descripcion,
       p.precio,
       p.stock,
       p.imagen_url,
       p.fecha_creacion,
       p.subcategoria_id
     FROM producto p
     WHERE %s AND p.estado = ''1''
     ORDER BY p.producto_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_producto(
  p_producto_id INT,
  p_nombre VARCHAR,
  p_descripcion TEXT,
  p_precio DECIMAL,
  p_stock INT,
  p_imagen_url VARCHAR,
  p_subcategoria_id INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  subcategoria_id INT,
  fecha_creacion TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE producto p
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        precio = p_precio,
        stock = p_stock,
        imagen_url = p_imagen_url,
        subcategoria_id = p_subcategoria_id
    WHERE p.producto_id = p_producto_id
    RETURNING 
      p.producto_id, p.nombre, p.descripcion, p.precio, p.stock,
      p.imagen_url, p.subcategoria_id, p.fecha_creacion;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_producto_por_id(p_producto_id INT, p_json JSON)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  fecha_creacion TIMESTAMP,
  subcategoria_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'producto' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "producto"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE producto p
     SET %s
     WHERE p.producto_id = $1
     RETURNING 
       p.producto_id, p.nombre, p.descripcion, p.precio,
       p.stock, p.imagen_url, p.fecha_creacion, p.subcategoria_id',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_producto_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_producto(p_producto_id INT)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
  subcategoria_id INT,
  fecha_creacion TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE producto p
    SET estado = '0'
    WHERE p.producto_id = p_producto_id
    RETURNING 
      p.producto_id, p.nombre, p.descripcion, p.precio, p.stock,
      p.imagen_url, p.subcategoria_id, p.fecha_creacion;
END
$$;

-- 8. PAGE BY CATEGORY
CREATE OR REPLACE FUNCTION paginar_productos_por_categoria(
	p_categoria TEXT,
	p_pagina INT,
	p_tamano_pagina INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
	catergoria VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT p.producto_id, p.nombre, p.descripcion, p.precio, p.stock, p.imagen_url, c.nombre
		FROM producto p
		INNER JOIN subcategoria s ON s.subcategoria_id = p.subcategoria_id
		INNER JOIN categoria c ON c.categoria_id = s.subcategoria_id
		WHERE (p_categoria IS NULL OR LOWER(c.nombre) = LOWER(p_categoria)) AND p.estado = '1'
		ORDER BY p.producto_id
		LIMIT p_tamano_pagina
		OFFSET (p_pagina - 1) * p_tamano_pagina;
END
$$;

-- 9. PAGE BY SUBCATEGORY
CREATE OR REPLACE FUNCTION paginar_productos_por_subcategoria(
	p_subcategoria TEXT,
	p_pagina INT,
	p_tamano_pagina INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR,
	subcatergoria VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT p.producto_id, p.nombre, p.descripcion, p.precio, p.stock, p.imagen_url, s.nombre
		FROM producto p
		INNER JOIN subcategoria s ON s.subcategoria_id = p.subcategoria_id
		WHERE (p_subcategoria IS NULL OR LOWER(s.nombre) = LOWER(p_subcategoria)) AND p.estado = '1'
		ORDER BY p.producto_id
		LIMIT p_tamano_pagina
		OFFSET (p_pagina - 1) * p_tamano_pagina;
END
$$;

-- 10. PAGE BY SEARCH
CREATE OR REPLACE FUNCTION paginar_productos_por_busqueda(
	p_busqueda TEXT,
	p_pagina INT,
	p_tamano_pagina INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  precio DECIMAL,
  stock INT,
  imagen_url VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT 
			p.producto_id, p.nombre, p.descripcion, p.precio, p.stock, p.imagen_url
		FROM producto p
		WHERE (p_busqueda IS NULL OR p.nombre ILIKE p_busqueda) AND p.estado = '1'
		ORDER BY p.producto_id
		LIMIT p_tamano_pagina
		OFFSET (p_pagina - 1) * p_tamano_pagina;
END
$$;

-- ------------------
-- >> Tabla: CUPÓN <<
-- ------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_cupon(
  p_codigo VARCHAR,
  p_porcentaje_descuento NUMERIC,
  p_fecha_expiracion TIMESTAMP
)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO cupon(codigo, porcentaje_descuento, fecha_expiracion)
    VALUES (p_codigo, p_porcentaje_descuento, p_fecha_expiracion)
    RETURNING 
      cupon.cupon_id, 
      cupon.codigo, 
      cupon.porcentaje_descuento, 
      cupon.fecha_expiracion, 
      cupon.activo;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_cupones()
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT c.cupon_id, c.codigo, c.porcentaje_descuento, c.fecha_expiracion, c.activo
    FROM cupon c
    WHERE c.estado = '1'
    ORDER BY c.cupon_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_cupon_por_id(p_cupon_id INT)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT c.cupon_id, c.codigo, c.porcentaje_descuento, c.fecha_expiracion, c.activo
    FROM cupon c
    WHERE c.cupon_id = p_cupon_id AND c.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_cupones_por_campo(p_json JSON)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'cupon' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "cupon"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('c.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       c.cupon_id,
       c.codigo,
       c.porcentaje_descuento,
       c.fecha_expiracion,
       c.activo
     FROM cupon c
     WHERE %s AND c.estado = ''1''
     ORDER BY c.cupon_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_cupon(
  p_cupon_id INT,
  p_codigo VARCHAR,
  p_porcentaje_descuento NUMERIC,
  p_fecha_expiracion TIMESTAMP,
  p_activo BOOLEAN
)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE cupon c
    SET codigo = p_codigo,
        porcentaje_descuento = p_porcentaje_descuento,
        fecha_expiracion = p_fecha_expiracion,
        activo = p_activo
    WHERE c.cupon_id = p_cupon_id
    RETURNING c.cupon_id, c.codigo, c.porcentaje_descuento, c.fecha_expiracion, c.activo;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_cupon_por_id(p_cupon_id INT, p_json JSON)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'cupon' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "cupon"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE cupon c
     SET %s
     WHERE c.cupon_id = $1
     RETURNING c.cupon_id, c.codigo, c.porcentaje_descuento, c.fecha_expiracion, c.activo',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_cupon_id;
END
$$;


-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_cupon(p_cupon_id INT)
RETURNS TABLE (
  cupon_id INT,
  codigo VARCHAR,
  porcentaje_descuento NUMERIC,
  fecha_expiracion TIMESTAMP,
  activo BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE cupon c
    SET estado = '0'
    WHERE c.cupon_id = p_cupon_id
    RETURNING c.cupon_id, c.codigo, c.porcentaje_descuento, c.fecha_expiracion, c.activo;
END
$$;

-- ----------------------
-- >> Tabla: CATEGORÍA <<
-- ----------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_categoria(
  p_nombre VARCHAR,
  p_descripcion TEXT
)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO categoria(nombre, descripcion)
    VALUES (p_nombre, p_descripcion)
    RETURNING 
      categoria.categoria_id, 
      categoria.nombre, 
      categoria.descripcion;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_categorias()
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT c.categoria_id, c.nombre, c.descripcion
    FROM categoria c
    WHERE c.estado = '1'
		ORDER BY c.categoria_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_categoria_por_id(p_categoria_id INT)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT c.categoria_id, c.nombre, c.descripcion
    FROM categoria c
    WHERE c.categoria_id = p_categoria_id AND c.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_categorias_por_campo(p_json JSON)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'categoria' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "categoria"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('c.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       c.categoria_id,
       c.nombre,
       c.descripcion
     FROM categoria c
     WHERE %s AND c.estado = ''1''
     ORDER BY c.categoria_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_categoria(
  p_categoria_id INT,
  p_nombre VARCHAR,
  p_descripcion TEXT
)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE categoria c
    SET nombre = p_nombre,
        descripcion = p_descripcion
    WHERE c.categoria_id = p_categoria_id
    RETURNING c.categoria_id, c.nombre, c.descripcion;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_categoria_por_id(p_categoria_id INT, p_json JSON)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'categoria' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "categoria"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE categoria c
     SET %s
     WHERE c.categoria_id = $1
     RETURNING c.categoria_id, c.nombre, c.descripcion',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_categoria_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_categoria(p_categoria_id INT)
RETURNS TABLE (
  categoria_id INT,
  nombre VARCHAR,
  descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE categoria c
    SET estado = '0'
    WHERE c.categoria_id = p_categoria_id
    RETURNING c.categoria_id, c.nombre, c.descripcion;
END
$$;

-- -------------------------
-- >> Tabla: SUBCATEGORÍA <<
-- -------------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_subcategoria(
  p_nombre VARCHAR,
  p_descripcion TEXT,
  p_categoria_id INT
)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO subcategoria(nombre, descripcion, categoria_id)
    VALUES (p_nombre, p_descripcion, p_categoria_id)
    RETURNING 
      subcategoria.subcategoria_id, 
      subcategoria.nombre, 
      subcategoria.descripcion, 
      subcategoria.categoria_id;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_subcategorias()
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT s.subcategoria_id, s.nombre, s.descripcion, s.categoria_id
    FROM subcategoria s
    WHERE s.estado = '1'
		ORDER BY s.subcategoria_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_subcategoria_por_id(p_subcategoria_id INT)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT s.subcategoria_id, s.nombre, s.descripcion, s.categoria_id
    FROM subcategoria s
    WHERE s.subcategoria_id = p_subcategoria_id AND s.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_subcategorias_por_campo(p_json JSON)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'subcategoria' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "subcategoria"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('s.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       s.subcategoria_id,
       s.nombre,
       s.descripcion,
       s.categoria_id
     FROM subcategoria s
     WHERE %s AND s.estado = ''1''
     ORDER BY s.subcategoria_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_subcategoria(
  p_subcategoria_id INT,
  p_nombre VARCHAR,
  p_descripcion TEXT,
  p_categoria_id INT
)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE subcategoria s
    SET nombre       = p_nombre,
        descripcion  = p_descripcion,
        categoria_id = p_categoria_id
    WHERE s.subcategoria_id = p_subcategoria_id
    RETURNING s.subcategoria_id, s.nombre, s.descripcion, s.categoria_id;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_subcategoria_por_id(p_subcategoria_id INT, p_json JSON)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'subcategoria' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "subcategoria"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE subcategoria s
     SET %s
     WHERE s.subcategoria_id = $1
     RETURNING s.subcategoria_id, s.nombre, s.descripcion, s.categoria_id',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_subcategoria_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_subcategoria(p_subcategoria_id INT)
RETURNS TABLE (
  subcategoria_id INT,
  nombre VARCHAR,
  descripcion TEXT,
  categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE subcategoria s
    SET estado = '0'
    WHERE s.subcategoria_id = p_subcategoria_id
    RETURNING s.subcategoria_id, s.nombre, s.descripcion, s.categoria_id;
END
$$;

-- -------------------
-- >> Tabla: PEDIDO <<
-- -------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_pedido(
  p_numero_documento VARCHAR,
  p_usuario_id INT,
  p_direccion_id INT,
  p_subtotal DECIMAL,
  p_total DECIMAL,
  p_estado_pedido VARCHAR DEFAULT 'pendiente',
  p_codigo_cupon VARCHAR DEFAULT NULL,
  p_cupon_id INT DEFAULT NULL,
  p_descuento_aplicado DECIMAL DEFAULT 0
)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO pedido (
      numero_documento,
      usuario_id,
      direccion_id,
      estado_pedido,
      codigo_cupon,
      cupon_id,
      subtotal,
      descuento_aplicado,
      total
    )
    VALUES (
      p_numero_documento,
      p_usuario_id,
      p_direccion_id,
      p_estado_pedido,
      p_codigo_cupon,
      p_cupon_id,
      p_subtotal,
      p_descuento_aplicado,
      p_total
    )
    RETURNING 
      pedido.pedido_id,
      pedido.numero_documento,
      pedido.usuario_id,
      pedido.direccion_id,
      pedido.estado_pedido,
      pedido.codigo_cupon,
      pedido.cupon_id,
      pedido.subtotal,
      pedido.descuento_aplicado,
      pedido.total,
      pedido.fecha_pedido;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_pedidos()
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.pedido_id,
      p.numero_documento,
      p.usuario_id,
      p.direccion_id,
      p.estado_pedido,
      p.codigo_cupon,
      p.cupon_id,
      p.subtotal,
      p.descuento_aplicado,
      p.total,
      p.fecha_pedido
    FROM pedido p
    WHERE p.estado = '1'
    ORDER BY p.pedido_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_pedido_por_id(p_pedido_id INT)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT
      p.pedido_id,
      p.numero_documento,
      p.usuario_id,
      p.direccion_id,
      p.estado_pedido,
      p.codigo_cupon,
      p.cupon_id,
      p.subtotal,
      p.descuento_aplicado,
      p.total,
      p.fecha_pedido
    FROM pedido p
    WHERE p.pedido_id = p_pedido_id AND p.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_pedidos_por_campo(p_json JSON)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'pedido' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "pedido"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('p.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       p.pedido_id,
       p.numero_documento,
       p.usuario_id,
       p.direccion_id,
       p.estado_pedido,
       p.codigo_cupon,
       p.cupon_id,
       p.subtotal,
       p.descuento_aplicado,
       p.total,
       p.fecha_pedido
     FROM pedido p
     WHERE %s AND p.estado = ''1''
     ORDER BY p.pedido_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_pedido(
  p_pedido_id INT,
  p_numero_documento VARCHAR,
  p_usuario_id INT,
  p_direccion_id INT,
  p_subtotal DECIMAL,
  p_total DECIMAL,
  p_estado_pedido VARCHAR DEFAULT 'pendiente',
  p_codigo_cupon VARCHAR DEFAULT NULL,
  p_cupon_id INT DEFAULT NULL,
  p_descuento_aplicado DECIMAL DEFAULT 0
)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE pedido p
    SET
      numero_documento    = p_numero_documento,
      usuario_id          = p_usuario_id,
      direccion_id        = p_direccion_id,
      estado_pedido       = p_estado_pedido,
      codigo_cupon        = p_codigo_cupon,
      cupon_id            = p_cupon_id,
      subtotal            = p_subtotal,
      descuento_aplicado  = p_descuento_aplicado,
      total               = p_total
    WHERE p.pedido_id = p_pedido_id
    RETURNING
      p.pedido_id,
      p.numero_documento,
      p.usuario_id,
      p.direccion_id,
      p.estado_pedido,
      p.codigo_cupon,
      p.cupon_id,
      p.subtotal,
      p.descuento_aplicado,
      p.total,
      p.fecha_pedido;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_pedido_por_id(p_pedido_id INT, p_json JSON)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'pedido' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "pedido"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE pedido p
     SET %s
     WHERE p.pedido_id = $1
     RETURNING 
       p.pedido_id, p.numero_documento, p.usuario_id, p.direccion_id,
       p.estado_pedido, p.codigo_cupon, p.cupon_id, p.subtotal,
       p.descuento_aplicado, p.total, p.fecha_pedido',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_pedido_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_pedido(p_pedido_id INT)
RETURNS TABLE (
  pedido_id INT,
  numero_documento VARCHAR,
  usuario_id INT,
  direccion_id INT,
  estado_pedido VARCHAR,
  codigo_cupon VARCHAR,
  cupon_id INT,
  subtotal DECIMAL,
  descuento_aplicado DECIMAL,
  total DECIMAL,
  fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE pedido p
    SET estado = '0'
    WHERE p.pedido_id = p_pedido_id
    RETURNING
      p.pedido_id,
      p.numero_documento,
      p.usuario_id,
      p.direccion_id,
      p.estado_pedido,
      p.codigo_cupon,
      p.cupon_id,
      p.subtotal,
      p.descuento_aplicado,
      p.total,
      p.fecha_pedido;
END
$$;

-- 8. SCALAR - DOCUMENT NUMBER (último nÚmero de pedido)
CREATE OR REPLACE FUNCTION obtener_ultimo_numero_pedido()
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
DECLARE
  ultimo_numero VARCHAR;
BEGIN
  SELECT p.numero_documento
  INTO ultimo_numero
  FROM pedido p
  ORDER BY p.pedido_id DESC
  LIMIT 1;
  RETURN ultimo_numero;
END
$$;

-- ------------------------------
-- >> Tabla: DETALLE DE PEDIDO <<
-- ------------------------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_detalle_pedido(
  p_pedido_id INT,
  p_producto_id INT,
  p_cantidad INT,
  p_precio_unitario DECIMAL
)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO detalle_pedido(pedido_id, producto_id, cantidad, precio_unitario)
    VALUES (p_pedido_id, p_producto_id, p_cantidad, p_precio_unitario)
    RETURNING 
      detalle_pedido.detalle_pedido_id, 
      detalle_pedido.pedido_id, 
      detalle_pedido.producto_id, 
      detalle_pedido.cantidad, 
      detalle_pedido.precio_unitario;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_detalles_pedido()
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT d.detalle_pedido_id, d.pedido_id, d.producto_id, d.cantidad, d.precio_unitario
    FROM detalle_pedido d
    WHERE d.estado = '1'
		ORDER BY d.detalle_pedido_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_detalle_pedido_por_id(p_detalle_pedido_id INT)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT d.detalle_pedido_id, d.pedido_id, d.producto_id, d.cantidad, d.precio_unitario
    FROM detalle_pedido d
    WHERE d.detalle_pedido_id = p_detalle_pedido_id AND d.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_detalles_pedido_por_campo(p_json JSON)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'detalle_pedido' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "detalle_pedido"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('d.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       d.detalle_pedido_id,
       d.pedido_id,
       d.producto_id,
       d.cantidad,
       d.precio_unitario
     FROM detalle_pedido d
     WHERE %s AND d.estado = ''1''
     ORDER BY d.detalle_pedido_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_detalle_pedido(
  p_detalle_pedido_id INT,
  p_pedido_id INT,
  p_producto_id INT,
  p_cantidad INT,
  p_precio_unitario DECIMAL
)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE detalle_pedido d
    SET pedido_id      = p_pedido_id,
        producto_id    = p_producto_id,
        cantidad       = p_cantidad,
        precio_unitario= p_precio_unitario
    WHERE d.detalle_pedido_id = p_detalle_pedido_id
    RETURNING d.detalle_pedido_id, d.pedido_id, d.producto_id, d.cantidad, d.precio_unitario;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_detalle_pedido_por_id(p_detalle_pedido_id INT, p_json JSON)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    SELECT column_name INTO field_name
    FROM information_schema.columns
    WHERE table_name = 'detalle_pedido' AND column_name = json_key;
    IF field_name IS NULL OR json_key = 'estado' THEN
      RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "detalle_pedido"', json_key;
    END IF;
  END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'UPDATE detalle_pedido d
     SET %s
     WHERE d.detalle_pedido_id = $1
     RETURNING 
       d.detalle_pedido_id, d.pedido_id, d.producto_id,
       d.cantidad, d.precio_unitario',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_detalle_pedido_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_detalle_pedido(p_detalle_pedido_id INT)
RETURNS TABLE (
  detalle_pedido_id INT,
  pedido_id INT,
  producto_id INT,
  cantidad INT,
  precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE detalle_pedido d
    SET estado = '0'
    WHERE d.detalle_pedido_id = p_detalle_pedido_id
    RETURNING d.detalle_pedido_id, d.pedido_id, d.producto_id, d.cantidad, d.precio_unitario;
END
$$;

-- 8. READ PRODUCT DETAILS BY ORDER ID
CREATE OR REPLACE FUNCTION obtener_detalles_producto_por_pedido_id(
	p_pedido_id INT
)
RETURNS TABLE (
  producto_id INT,
  nombre VARCHAR,
  cantidad INT,
  precio_unitario DECIMAL,
  subtotal DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT 
		  d.producto_id, p.nombre, d.cantidad, d.precio_unitario,
		  (d.cantidad * d.precio_unitario) AS subtotal
		FROM detalle_pedido d
		INNER JOIN producto p ON d.producto_id = p.producto_id
		WHERE d.pedido_id = p_pedido_id AND d.estado = '1'
		ORDER BY d.detalle_pedido_id;
END
$$;

-- -----------------
-- >> Tabla: PAGO <<
-- -----------------

-- 1. CREATE
CREATE OR REPLACE FUNCTION registrar_pago(
  p_pedido_id INT,
  p_metodo_pago VARCHAR DEFAULT NULL,
  p_estado_pago VARCHAR DEFAULT 'pendiente',
  p_fecha_pago TIMESTAMP DEFAULT NULL,
  p_monto DECIMAL DEFAULT 0 
)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    INSERT INTO pago(pedido_id, metodo_pago, estado_pago, fecha_pago, monto)
    VALUES (p_pedido_id, p_metodo_pago, p_estado_pago, p_fecha_pago, p_monto)
    RETURNING 
      pago.pago_id, 
      pago.pedido_id, 
      pago.metodo_pago, 
      pago.estado_pago, 
      pago.fecha_pago, 
      pago.monto;
END
$$;

-- 2. READ
CREATE OR REPLACE FUNCTION obtener_pagos()
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT p.pago_id, p.pedido_id, p.metodo_pago, p.estado_pago, p.fecha_pago, p.monto
    FROM pago p
    WHERE p.estado = '1'
		ORDER BY p.pago_id;
END
$$;

-- 3. READ BY ID
CREATE OR REPLACE FUNCTION obtener_pago_por_id(p_pago_id INT)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    SELECT p.pago_id, p.pedido_id, p.metodo_pago, p.estado_pago, p.fecha_pago, p.monto
    FROM pago p
    WHERE p.pago_id = p_pago_id AND p.estado = '1';
END
$$;

-- 4. READ BY FIELD
CREATE OR REPLACE FUNCTION obtener_pagos_por_campo(p_json JSON)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  where_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para filtrar';
  END IF;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
		SELECT column_name INTO field_name
		FROM information_schema.columns
		WHERE table_name = 'pago' AND column_name = json_key;
		IF field_name IS NULL OR json_key = 'estado' THEN
			RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "pago"', json_key;
		END IF;
	END LOOP;
  FOR json_key IN SELECT * FROM json_object_keys(p_json) LOOP
    json_value := p_json ->> json_key;
    IF where_clause <> '' THEN
      where_clause := where_clause || ' AND ';
    END IF;
    where_clause := where_clause || format('p.%I = %L', json_key, json_value);
  END LOOP;
  sql_query := format(
    'SELECT
       p.pago_id,
       p.pedido_id,
       p.metodo_pago,
       p.estado_pago,
       p.fecha_pago,
       p.monto
     FROM pago p
     WHERE %s AND p.estado = ''1''
     ORDER BY p.pago_id',
    where_clause
  );
  RETURN QUERY EXECUTE sql_query;
END
$$;

-- 5. UPDATE
CREATE OR REPLACE FUNCTION actualizar_pago(
  p_pago_id INT,
  p_pedido_id INT,
  p_metodo_pago VARCHAR,
  p_estado_pago VARCHAR,
  p_fecha_pago TIMESTAMP,
  p_monto DECIMAL
)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE pago p
    SET pedido_id   = p_pedido_id,
        metodo_pago = p_metodo_pago,
        estado_pago = p_estado_pago,
        fecha_pago = p_fecha_pago,
        monto      = p_monto
    WHERE p.pago_id = p_pago_id
    RETURNING p.pago_id, p.pedido_id, p.metodo_pago, p.estado_pago, p.fecha_pago, p.monto;
END
$$;

-- 6. UPDATE FIELD BY ID
CREATE OR REPLACE FUNCTION actualizar_campo_pago_por_id(p_pago_id INT, p_json JSON)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
DECLARE
  sql_query TEXT;
  json_key TEXT;
  json_value TEXT;
  field_name TEXT;
  set_clause TEXT := '';
BEGIN
  IF p_json IS NULL OR p_json::text = '{}' THEN
    RAISE EXCEPTION 'El parámetro JSON está vacío o no se proporcionaron campos para actualizar';
  END IF;
  FOR json_key IN 
		SELECT * FROM json_object_keys(p_json)
  LOOP
		SELECT column_name INTO field_name
		FROM information_schema.columns
		WHERE table_name = 'pago' AND column_name = json_key;
		IF field_name IS NULL OR json_key = 'estado' THEN
			RAISE EXCEPTION 'El campo "%" es inválido o no se encuentra en la tabla "pago"', json_key;
		END IF;
	END LOOP;
  FOR json_key IN 
		SELECT * FROM json_object_keys(p_json)
  LOOP
    json_value := p_json ->> json_key;
    IF set_clause <> '' THEN
      set_clause := set_clause || ', ';
    END IF;
    set_clause := set_clause || format('%I = %L', json_key, json_value);
  END LOOP;
	sql_query := format(
    'UPDATE pago p 
		 SET %s
     WHERE p.pago_id = $1
     RETURNING p.pago_id, p.pedido_id, p.metodo_pago, p.estado_pago, p.fecha_pago, p.monto',
    set_clause
  );
  RETURN QUERY EXECUTE sql_query USING p_pago_id;
END
$$;

-- 7. DELETE (soft delete)
CREATE OR REPLACE FUNCTION eliminar_pago(p_pago_id INT)
RETURNS TABLE (
  pago_id INT,
  pedido_id INT,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
    UPDATE pago p
    SET estado = '0'
    WHERE p.pago_id = p_pago_id
    RETURNING p.pago_id, p.pedido_id, p.metodo_pago, p.estado_pago, p.fecha_pago, p.monto;
END
$$;

-- 8. READ HISTORY BY USER
CREATE OR REPLACE FUNCTION obtener_historial_pagos_usuario_id(
	p_usuario_id INT
)
RETURNS TABLE (
  pago_id INT,
  numero_documento VARCHAR,
  metodo_pago VARCHAR,
  estado_pago VARCHAR,
  fecha_pago TIMESTAMP,
  monto DECIMAL,
	pedido_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
		SELECT 
			pa.pago_id, pe.numero_documento, pa.metodo_pago, 
			pa.estado_pago, pa.fecha_pago, pa.monto, pe.pedido_id 
		FROM pago pa
		INNER JOIN pedido pe ON pe.pedido_id = pa.pedido_id
		INNER JOIN usuario u ON u.usuario_id = pe.usuario_id
		WHERE u.usuario_id = p_usuario_id AND pa.estado = '1'
		ORDER BY pa.pago_id;
END
$$;