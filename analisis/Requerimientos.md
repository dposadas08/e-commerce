# ANÁLISIS DE REQUERIMIENTOS DEL SISTEMA E-COMMERCE

## 👨‍💻 Módulo de Usuarios

### Descripción:
Gestiona los datos personales y credenciales de los usuarios registrados en el sistema.

### CRUD y funcionalidades clave:
- Crear usuario (registro con validación de correo único y contraseña segura)
- Ver perfil de usuario.
- Actualizar perfil (nombre, correo, contraseña).
- Eliminar cuenta de usuario (baja lógica o eliminación física).
- Inicio de sesión (autenticación con validación de contraseña).
- Validación de roles (admin, cliente).
- Registro de fecha de creación automática.

## 🏠 Módulo de Direcciones

### Descripción:
Permite a los usuarios gestionar sus direcciones de envío y facturación.

### CRUD y funcionalidades clave:
- Agregar dirección al perfil de usuario
- Listar direcciones por usuario
- Editar dirección (ciudad, estado, país, etc.)
- Eliminar dirección
- Asociar dirección a pedidos

## 🛒 Módulo de Productos

### Descripción:
Administra la información de los productos ofrecidos en el e-commerce.

### CRUD y funcionalidades clave:
- Crear producto
- Listar productos (por página, categoría, búsqueda)
- Ver detalle de producto
- Actualizar información del producto
- Eliminar producto (o marcar como inactivo)
- Subir imágenes
- Control de stock por producto
- Registrar fecha de creación automática

## 🏷 Módulo de Categorías y Subcategorías

### Descripción:
Permite agrupar los productos y facilitar su búsqueda.

### CRUD y funcionalidades clave:
- Crear categoría/subcategoría
- Listar categorías y subcategorías
- Actualizar nombre o estado
- Eliminar (o desactivar)

## 📦 Módulo de Pedidos

### Descripción:
Gestiona los pedidos realizados por los usuarios, incluyendo su estado y dirección de envío.

### CRUD y funcionalidades clave:
- Crear pedido (asociar usuario, dirección, total, productos)
- Listar pedidos por usuario o administrador
- Ver detalle del pedido (incluye productos, dirección, estado)
- Actualizar estado del pedido (pendiente → pagado → enviado → entregado)
- Cancelar pedido (si aún no ha sido enviado)
- Cálculo automático del total del pedido

## 📋 Módulo de Detalles del Pedido

### Descripción:
Registra los productos comprados en cada pedido, incluyendo cantidades y precios unitarios.

### CRUD y funcionalidades clave:
- Crear detalles al generar un pedido
- Listar productos dentro de un pedido
- Consultar cantidad y precio por producto en pedido
- Actualización en caso de modificación del pedido (limitado según estado)
- No permite eliminar si el pedido está pagado o en proceso

## 💳 Módulo de Pagos

### Descripción:
Administra los pagos realizados por los pedidos, incluyendo método, estado y monto.

### CRUD y funcionalidades clave:
•	Registrar pago (automático tras confirmación del pedido)
•	Listar pagos por pedido o usuario
•	Actualizar estado del pago (pendiente, completado, fallido)
•	Ver historial de pagos
•	Validación de monto coincidente con el total del pedido
•	Registro de fecha de pago