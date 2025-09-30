# 🛒 Proyecto: E-commerce API REST

Sistema backend **API REST** para gestión de un e-commerce, desarrollado con **Node.js**, **Express** y **PostgreSQL**.  
No incluye interfaz gráfica; está pensado para ser consumido por clientes como aplicaciones frontend o herramientas de prueba tipo **Postman**.

---

## ⚙️ Tecnologías utilizadas

- **Backend:** Node.js + Express  
- **Base de datos:** PostgreSQL + PL/pgSQL  
- **Driver PostgreSQL:** `pg`  
- **Autenticación:** JSON Web Tokens (JWT)  
- **Cifrado de contraseñas:** bcryptjs  
- **Fechas y horas:** luxon  
- **Validación de datos:** validator  
- **Cliente HTTP:** axios  
- **Variables de entorno:** dotenv  

---

## 📦 Dependencias

Asegúrate de instalar las siguientes dependencias con `npm install`:

- `axios` ^1.12.2  
- `bcryptjs` ^3.0.2  
- `dotenv` ^17.2.2  
- `express` ^5.1.0  
- `jsonwebtoken` ^9.0.2  
- `luxon` ^3.7.2  
- `pg` ^8.16.3  
- `validator` ^13.15.15  

---

## 🧩 Módulos del Sistema

### 👨‍💻 Módulo de Usuarios

Gestiona la información personal y de autenticación de los usuarios.

- Registro de usuarios con validación de email y contraseña segura  
- Inicio de sesión con autenticación JWT  
- Ver y actualizar perfil  
- Baja lógica de cuenta  
- Roles: administrador y cliente  
- Fecha de creación automática  

---

### 🏠 Módulo de Direcciones

Permite a los usuarios gestionar direcciones de envío y facturación.

- Agregar nuevas direcciones  
- Editar y eliminar (baja lógica)  
- Asociación con pedidos  
- Listado por usuario  

---

### 🛒 Módulo de Productos

Administra los productos disponibles en la tienda.

- Crear, listar, editar y eliminar productos (baja lógica)  
- Búsqueda y filtrado por categoría o nombre  
- Subida de imágenes  
- Control de stock  
- Registro de fecha de creación  

---

### 🏷️ Módulo de Categorías y Subcategorías

Organiza los productos en grupos jerárquicos.

- Crear y editar categorías y subcategorías  
- Eliminar (baja lógica)  
- Listado completo para filtrado  

---

### 📦 Módulo de Pedidos

Gestiona los pedidos realizados por los usuarios.

- Crear pedido (usuario, dirección, productos)  
- Ver detalle y estado del pedido  
- Listado por usuario y por admin  
- Cambiar estado (pendiente → pagado → enviado → entregado)  
- Cancelación si aún no se envía  
- Cálculo automático del total  

---

### 📋 Módulo de Detalles del Pedido

Registra los productos dentro de un pedido.

- Añadir automáticamente al generar pedido  
- Ver productos, cantidad y precio por pedido  
- Restringe modificaciones según el estado del pedido  

---

### 💳 Módulo de Pagos

Administra los pagos realizados por los usuarios.

- Registrar pago al confirmar pedido  
- Ver historial por usuario y pedido  
- Validar monto contra total del pedido  
- Actualizar estado del pago (pendiente, completado, fallido)  
- Registro de fecha de pago  

---

## ⚠️ Importante: Inicialización y Configuración

Antes de iniciar el backend, debes tener una base de datos PostgreSQL configurada correctamente.

### 1. Crear la base de datos

El sistema utiliza scripts SQL para definir la estructura de la base de datos y su lógica interna. Estos archivos se encuentran en la carpeta /db.
Archivos:

### 📂 Archivos:

- `create_tables.sql`  
  Contiene las instrucciones `CREATE TABLE` necesarias para definir todas las tablas relacionadas con los módulos del sistema.  
  Incluye claves primarias, claves foráneas, restricciones, tipos de datos, timestamps, etc.

- `create_functions.sql`  
  Contiene funciones y procedimientos almacenados en **PL/pgSQL** que implementan las operaciones **CRUD** (Crear, Leer, Actualizar y Eliminar) para las diferentes entidades del sistema.  
  Estas funciones encapsulan la lógica para:  
  - ➕ Insertar nuevos registros (usuarios, productos, pedidos, etc.)  
  - 🔍 Consultar datos específicos o listados  
  - ✏️ Actualizar registros existentes  
  - 🗑 Realizar bajas lógicas o eliminaciones según estado  
  - ⚙️ Controlar transacciones y validaciones internas (por ejemplo, control de stock, actualización de estados)

  
### 2. Configurar el archivo `.env`

Para que la aplicación pueda conectarse a la base de datos y configurar otros parámetros, crea un archivo `.env` en la raíz del proyecto con las siguientes variables:

DB_HOST= # Dirección del servidor PostgreSQL (ejemplo: localhost)
DB_PORT= # Puerto de conexión (por defecto 5432)
DB_USERNAME= # Usuario de la base de datos
DB_PASSWORD= # Contraseña del usuario
DB_DATABASE= # Nombre de la base de datos creada

PORT= # Puerto en el que correrá el servidor Node.js (ejemplo: 3000)

JWT_SECRET= # Clave secreta para la generación y validación de tokens JWT

> Asegúrate de completar estos valores con la configuración correspondiente a tu entorno de desarrollo o producción. 
---

## 📌 Notas finales

- Recuerda revisar los scripts SQL para entender la estructura y lógica interna.  
- Mantén las dependencias actualizadas según `package.json`.  
- Configura correctamente el `.env` para evitar problemas de conexión o seguridad.  
- Para producción, asegura manejar bien los secretos y la configuración.

---