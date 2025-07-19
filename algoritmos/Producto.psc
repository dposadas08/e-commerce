Algoritmo ModuloProducto
	Definir i, fila Como Entero
	Definir idProducto, nombre, descripcion, precio, stock, imagen Como Cadena
	
	Definir productos Como Cadena
	Dimension productos[10,8]
	
	Definir producto Como Cadena
	Dimension producto[8]
	
	// -- CARGAR PRODUCTOS --
	cargarProductos(productos)
	
	// -- CREAR PRODUCTO --
	
	//- Lógica:
	//	Se requiere crear un producto ingresando los datos
	
	//- Algoritmo:
	//	1. Leer nombre
	//	2. Leer descripción
	//	3. Leer precio
	//	4. Leer stock
	//	5. Leer imagen 
	//	6. Crear fecha de registro en la función
	//	7. Crear el producto con los datos ingresados en la función
	//  8. Mostrar mensaje de producto creado
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear producto"
	Escribir "-------------------------------------"
	Escribir "Ingrese nombre: "
	leer nombre
	Escribir "Ingrese descripcion: "
	leer descripcion
	Escribir "Ingrese precio: "
	leer precio
	Escribir "Ingrese stock: "
	leer stock
	Escribir "Ingrese imagen: "
	leer imagen
	crearProducto(ConvertirATexto(generarId(productos,10)), nombre, descripcion, precio, stock, imagen, productos)
	Escribir "*** Producto creado con éxito ***"
	Escribir "-------------------------------------"
	
	// -- LISTAR PRODUCTOS --
	
	//- Lógica:
	//	Se requiere la lista de todos los productos registrados
	
	//- Algoritmo:
	//	1. Buscar todos los productos en la función
	//	2. Validar si el producto esta activo en la función
	//	3. Mostrar la lista de todos los productos activos
	
	//- Pseudocódigo en PSeint:
	Escribir "Listar productos"
	Escribir "-------------------------------------"
	listarProductos(productos)
	
	// -- VER PRODUCTO --
	
	//- Lógica:
	//	Se requiere mostrar al producto por id
	
	//- Algoritmo:
	//	1. Leer id de producto
	//	2. Buscar el producto por el id ingresado en la función
	// 	3. Validar si el producto existe
	//	4. Validar si el producto esta activo en la función
	//	5. Mostrar el producto encontrado
	
	//- Pseudocódigo en PSeint:
	Escribir "Ver producto"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del producto para mostrar: "
	leer idProducto
	fila = buscarProducto(idProducto, producto, productos)
	Mientras No (fila > 0) Hacer 
		Escribir "El producto no existe. Ingrese id del producto para mostrar: "
		leer idProducto
		fila = buscarProducto(idProducto, producto, productos)
	FinMientras
	Escribir "-------------------------------------"
	verProducto(idProducto, producto, productos)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR PRODUCTO --
	
	//- Lógica:
	//	Se requiere actualizar los datos del producto
	
	//- Algoritmo:
	//	1. Leer id
	//	2. Leer nombre
	//	3. Leer descripción
	//	4. Leer precio
	//	5. Leer stock
	//	6. Leer imagen 
	//	7. Buscar el producto por el id ingresado en la función
	// 	8. Validar si el producto existe 
	//	9. Actualizar los datos del producto en la función
	//  10. Mostrar mensaje de producto actualizado
	
	//- Pseudocódigo en PSeint:
	Escribir "Actualizar producto"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del producto para actualizar: "
	leer idProducto
	fila = buscarProducto(idProducto, producto, productos)
	Mientras No (fila > 0) Hacer 
		Escribir "El producto no existe. Ingrese id del producto para actualizar: "
		leer idProducto
		fila = buscarProducto(idProducto, producto, productos)
	FinMientras
	Escribir "Ingrese nombre: "
	leer nombre
	Escribir "Ingrese descripcion: "
	leer descripcion
	Escribir "Ingrese precio: "
	leer precio
	Escribir "Ingrese stock: "
	leer stock
	Escribir "Ingrese imagen: "
	leer imagen
	actualizarProducto(idProducto, nombre, descripcion, precio, stock, imagen, productos)
	Escribir "*** Producto actualizado con éxito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINIAR PRODUCTO --
	
	//- Lógica:
	//	Se requiere que los datos del usaurio se den de baja
	
	//- Algoritmo:
	//	1. Leer id de producto
	//	2. Buscar el producto por el id ingresado en la función
	// 	3. Validar si el producto existe
	//	4. Cambiar el estado del producto a inactivo si lo encuentra
	//  5. Mostrar mensaje de producto eliminado
	
	//- Pseudocódigo en PSeint:
	Escribir "Eliminar producto"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del producto para eliminar: "
	leer idProducto
	fila = buscarProducto(idProducto, producto, productos)
	Mientras No (fila > 0) Hacer 
		Escribir "El producto no existe. Ingrese id del producto para eliminar: "
		leer idProducto
		fila = buscarProducto(idProducto, producto, productos)
	FinMientras
	eliminarProducto(idProducto, productos)
	Escribir "*** Producto eliminado con éxito ***"
	Escribir "-------------------------------------"
FinAlgoritmo

// Funciones Modulares
Funcion listarProductos(productos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,8] = "1" Entonces
			Escribir "Id: ", productos[i,1]
			Escribir "Nombre: ", productos[i,2]
			Escribir "Descripcion: ", productos[i,3]
			Escribir "Precio: ", productos[i,4]
			Escribir "Stock: ", productos[i,5]
			Escribir "Imagen: ", productos[i,6]
			Escribir "Fecha de creación: ", productos[i,7]
			Escribir "Estado: ", productos[i,8] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

Funcion crearProducto(idProducto, nombre, descripcion, precio, stock, imagen, productos Por Referencia)
	productos[ConvertirANumero(idProducto),1] <- idProducto
	productos[ConvertirANumero(idProducto),2] <- nombre
	productos[ConvertirANumero(idProducto),3] <- descripcion
	productos[ConvertirANumero(idProducto),4] <- precio
	productos[ConvertirANumero(idProducto),5] <- stock
	productos[ConvertirANumero(idProducto),6] <- imagen
	productos[ConvertirANumero(idProducto),7] <- formatearFechaHoraISO(FechaActual(), HoraActual())
	productos[ConvertirANumero(idProducto),8] <- "1"
FinFuncion

Funcion verProducto(idProducto, producto Por Referencia, productos Por Referencia)
	Definir fila Como Entero
	fila = buscarProducto(idProducto, producto, productos)
	Si fila > 0 Entonces
		Escribir "Id: ", producto[1]
		Escribir "Nombre: ", producto[2]
		Escribir "Descripcion: ", producto[3]
		Escribir "Precio: ", producto[4]
		Escribir "Stock: ", producto[5]
		Escribir "Imagen: ", producto[6]
		Escribir "Fecha de creación: ", producto[7]
		Escribir "Estado: ", producto[8] 
	SiNo
		Escribir " -> Producto no encontrado..."
	FinSi
FinFuncion

Funcion fila <- buscarProducto(idProducto, producto Por Referencia, productos Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,1] = idProducto Entonces
			producto[1] <- productos[i,1]
			producto[2] <- productos[i,2]
			producto[3] <- productos[i,3]
			producto[4] <- productos[i,4]
			producto[5] <- productos[i,5]
			producto[6] <- productos[i,6]
			producto[7] <- productos[i,7]
			producto[8] <- productos[i,8]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion actualizarProducto(idProducto, nombre, descripcion, precio, stock, imagen, productos Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,1] = idProducto Entonces
			productos[ConvertirANumero(idProducto),1] <- idProducto
			productos[ConvertirANumero(idProducto),2] <- nombre
			productos[ConvertirANumero(idProducto),3] <- descripcion
			productos[ConvertirANumero(idProducto),4] <- precio
			productos[ConvertirANumero(idProducto),5] <- stock
			productos[ConvertirANumero(idProducto),6] <- imagen
			productos[ConvertirANumero(idProducto),8] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarProducto(idProducto, productos Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,1] = idProducto Entonces
			productos[i,8] = "0"
		FinSi
	Fin Para
FinFuncion

// Componentes
Funcion id <- generarId(matriz Por Referencia, elementos)
	Definir id, i Como Entero
	id = 0
	Para i <- 1 Hasta elementos Con Paso 1
		Si No (matriz[i,1] = "") Entonces
			id = id + 1
		FinSi
	FinPara
	id = id + 1
FinFuncion

Funcion fecha <- formatearFechaHoraISO(fechaActual, horaActual)
    Definir dia, mes, anio, hora, min Como Entero
    Definir sDia, sMes, sHora, sMin, fecha Como Cadena
	
	anio = trunc(fechaActual/10000)
	mes = trunc(fechaActual/100)%100
	dia = fechaActual%100
	
	hora = trunc(horaActual/10000)
	min = trunc(horaActual/100)%100
	
    Si dia < 10 Entonces
        sDia <- "0" + ConvertirATexto(dia)
	SiNo
		sDia <- ConvertirATexto(dia)
    FinSi
	
    Si mes < 10 Entonces
        sMes <- "0" + ConvertirATexto(mes)
    SiNo
		sMes <- ConvertirATexto(mes)
    FinSi
	
    Si hora < 10 Entonces
        sHora <- "0" + ConvertirATexto(hora)
    Sino
        sHora <- ConvertirATexto(hora)
    FinSi
	
    Si minutos < 10 Entonces
        sMin <- "0" + ConvertirATexto(min)
    Sino
        sMin <- ConvertirATexto(min)
    FinSi
	
    fecha <- ConvertirATexto(anio) + "-" + sMes + "-" + sDia + " " + sHora + ":" + sMin 
FinFuncion

// Funciones de Persistencia
Funcion cargarProductos(productos Por Referencia)
	productos[1,1] <- "1"
	productos[1,2] <- "Mouse Inalambrico"
	productos[1,3] <- "Mouse ergonomico Bluetooth"
	productos[1,4] <- "19.99"
	productos[1,5] <- "150"
	productos[1,6] <- "img/mouse.jpg"
	productos[1,7] <- "2025-07-10 14:23"
	productos[1,8] <- "1"
	
	productos[2,1] <- "2"
	productos[2,2] <- "Teclado Mecanico"
	productos[2,3] <- "Teclado RGB con switches"
	productos[2,4] <- "49.95"
	productos[2,5] <- "85"
	productos[2,6] <- "img/teclado.jpg"
	productos[2,7] <- "2025-07-11 09:15"
	productos[2,8] <- "1"
	
	productos[3,1] <- "3"
	productos[3,2] <- "Monitor LED 24"
	productos[3,3] <- "Monitor Full HD HDMI"
	productos[3,4] <- "129.99"
	productos[3,5] <- "40"
	productos[3,6] <- "img/monitor.jpg"
	productos[3,7] <- "2025-07-11 11:05"
	productos[3,8] <- "1"
	
	productos[4,1] <- "4"
	productos[4,2] <- "Audifonos Bluetooth"
	productos[4,3] <- "Audifonos con microfono"
	productos[4,4] <- "34.50"
	productos[4,5] <- "70"
	productos[4,6] <- "img/audifonos.jpg"
	productos[4,7] <- "2025-07-12 08:47"
	productos[4,8] <- "1"
	
	productos[5,1] <- "5"
	productos[5,2] <- "Camara Web HD"
	productos[5,3] <- "Camara 720p para video"
	productos[5,4] <- "25.00"
	productos[5,5] <- "30"
	productos[5,6] <- "img/camara.jpg"
	productos[5,7] <- "2025-07-13 10:00"
	productos[5,8] <- "0"
	
	productos[6,1] <- "6"
	productos[6,2] <- "Disco Duro SSD 1TB"
	productos[6,3] <- "SSD SATA III para alta velocidad"
	productos[6,4] <- "79.99"
	productos[6,5] <- "120"
	productos[6,6] <- "img/ssd.jpg"
	productos[6,7] <- "2025-07-14 12:30"
	productos[6,8] <- "1"
	
	productos[7,1] <- "7"
	productos[7,2] <- "Fuente de Poder 600W"
	productos[7,3] <- "Fuente modular con certificación 80+"
	productos[7,4] <- "65.00"
	productos[7,5] <- "55"
	productos[7,6] <- "img/fuente.jpg"
	productos[7,7] <- "2025-07-14 15:45"
	productos[7,8] <- "1"
	
	productos[8,1] <- "8"
	productos[8,2] <- "Tarjeta Grafica GTX 1660"
	productos[8,3] <- "GPU para gaming con 6GB VRAM"
	productos[8,4] <- "249.99"
	productos[8,5] <- "20"
	productos[8,6] <- "img/grafica.jpg"
	productos[8,7] <- "2025-07-15 09:10"
	productos[8,8] <- "1"
FinFuncion
