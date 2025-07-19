Algoritmo ModuloCategoria
    Definir idCategoria, idSubcategoria, i, fila Como Entero
    Definir id, idProducto, nombre, descripcion, continuar Como Cadena
    
    Definir categorias, subcategorias, productos Como Cadena
    Dimension categorias[20,5]
    Dimension subcategorias[20,5]
    Dimension productos[10,8]
    
    Definir categoria, subcategoria, producto Como Cadena
    Dimension categoria[5]
    Dimension subcategoria[5]
    Dimension producto[8]
	
	idCategoria = 1
	idSubcategoria = 1
	
	// -- CARGAR PRODUCTOS --
	cargarProductos(productos)
	
	// -- CREAR CATEGORÍA --
	
	//- Lógica:
	//	Se requiere crear la categoría y sus subcategorías para el producto ingresando los datos
	
	//- Algoritmo:
	//	1. Leer nombre
	//	2. Leer descripción
	//	3. Listar productos existentes
	//	4. Leer id del producto
	//	5. Buscar el producto por el id ingresado en la función
	//	6. Validar si el producto existe
	//	7. Crear la categoría con los datos ingresados en la función
	//	8. Agregar subcategoría
	//	9. Leer nombre
	//	10. Leer descripción
	//	11. Crear la subcategoría con los datos ingresados en la función
	//	12. Mostrar mensaje de subcategoría creada
	//	13. Preguntar si desea volver a agregar otra subcategoría, si es sí vuelve a registrar, caso contrario sigue la secuencia
	//	14. Mostrar mensaje de categoría creada
	//	15. Preguntar si desea volver a agregar otra subcategoría, si es sí vuelve a registrar, caso contrario termina
	//  16. Mostrar mensaje de categoría creada
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear categoría"
	Escribir "-------------------------------------"
	Repetir	
		Escribir "Ingrese nombre: "
		leer nombre 
		Escribir "Ingrese descripción: "
		leer descripcion
		Escribir "-------------------------------------"
		listarProductos(productos)
		Escribir "Ingrese id del producto: "
		leer idProducto
		fila = buscarProducto(idProducto, producto, productos)
		Mientras No (fila > 0) Hacer 
			Escribir "El producto no existe. Ingrese id del producto: "
			leer idProducto
			fila = buscarProducto(idProducto, producto, productos)
		FinMientras
		crearCategoria(ConvertirATexto(idCategoria), nombre, descripcion, idProducto, categorias)
		Escribir "*** Categoría creado con éxito ***"
		Escribir "-------------------------------------"
		Escribir "Crear Subcategoría"
		Escribir "-------------------------------------"
		Repetir
			Escribir "Ingrese nombre: "
			leer nombre 
			Escribir "Ingrese descripción: "
			leer descripcion
			crearSubcategoria(ConvertirATexto(idSubcategoria), nombre, descripcion, ConvertirATexto(idCategoria), subcategorias)
			Escribir "*** Subcategoría creado con éxito ***"
			Escribir "-------------------------------------"
			Escribir "¿Desea agregar otra subcategoría? s/n:"
			leer continuar
			Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
				Escribir "Opción inválida. ¿Desea agregar otra subcategoría? s/n:"
				leer continuar
			FinMientras
			idSubcategoria = idSubcategoria + 1
		Hasta Que Minusculas(continuar) = 'n'
		Escribir "¿Desea crear otra categoría? s/n:"
		leer continuar
		Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
			Escribir "Opción inválida. ¿Desea crear otra categoría? s/n:"
			leer continuar
		FinMientras
		idCategoria = idCategoria + 1
	Hasta Que Minusculas(continuar) = 'n'
	Escribir "-------------------------------------"
	
	// -- LISTAR CATEGORÍAS --
	
	//- Lógica:
	//  Se requiere la lista de todas las categorías registradas
	
	//- Algoritmo:
	//  1. Buscar todas las categorías en la función
	//  2. Validar si cada categoría está activa
	//  3. Mostrar la lista de todas las categorías activas
	
	//- Pseudocódigo en PSeint:
	Escribir "Listar categorías"
	Escribir "-------------------------------------"
	listarCategorias(categorias)
	
	// -- VER CATEGORÍAS --
	
	//- Lógica:
	//  Se requiere mostrar la categoría por id
	
	//- Algoritmo:
	//  1. Leer el id de la categoría
	//  2. Buscar la categoría por el id ingresado en la función
	//  3. Validar si la categoría existe
	//  4. Mostrar la categoría encontrada

	//- Pseudocódigo en PSeint:
	Escribir "Ver categoría"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categoría para mostrar: "
	leer id
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categoría no existe. Ingrese id de la categoría para mostrar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	Escribir "-------------------------------------"
	verCategoria(id, categoria, categorias)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR CATEGORÍA --
	
	//- Lógica:
	//	Se requiere actualizar los datos de la categoria por id

	//- Algoritmo:
	//	1. Leer el id de la categoría
	// 	2. Buscar la categoria por el id ingresado en la función
	//	3. Validar si la categoría existe
	//	4. Leer nombre
	//	5. Leer descripcion
	//	6. Listar productos disponibles
	//	7. Leer id del producto
	//	8. Buscar el producto por el id ingresado en la función
	// 	9. Validar si el producto existe
	//	10. Actualizar los datos de la categoria en la función
	//  11. Mostrar mensaje de categoria actualizado
	
	//- Pseudocódigo en PSeint:
	Escribir "Actualizar categoría"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categoría para actualizar: "
	leer id 
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categoría no existe. Ingrese id de la categoría para actualizar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	Escribir "Ingrese nombre: "
	leer nombre 
	Escribir "Ingrese descripción: "
	leer descripcion
	Escribir "-------------------------------------"
	listarProductos(productos)
	Escribir "Ingrese id del producto: "
	leer idProducto
	fila = buscarProducto(idProducto, producto, productos)
	Mientras No (fila > 0) Hacer 
		Escribir "El producto no existe. Ingrese id del producto: "
		leer idProducto
		fila = buscarProducto(idProducto, producto, productos)
	FinMientras
	actualizarCategoria(id, nombre, descripcion, idProducto, categorias)
	Escribir "*** Categoría actualizada con éxito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINAR CATEGORÍA --
	
	//- Lógica:
	//	Se requiere que los datos de la categoria se den de baja por id
	
	//- Algoritmo:
	//	1. Leer el id de la categoría
	// 	2. Buscar la categoria por el id ingresado en la función
	//	3. Validar si la categoría existe
	//	4. Cambiar el estado del categoria a inactivo si lo encuentra
	//  5. Mostrar mensaje de categoria eliminado
	
	//- Pseudocódigo en PSeint:
	Escribir "Eliminar categoría"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categoría para eliminar: "
	leer id
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categoría no existe. Ingrese id de la categoría para eliminar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	eliminarCategoria(id, categorias)
	Escribir "*** Categoría eliminada con éxito ***"
	Escribir "-------------------------------------"
FinAlgoritmo

// Funciones Modulares
Funcion crearCategoria(idCategoria, nombre, descripcion, idProducto, categorias Por Referencia)
	categorias[ConvertirANumero(idCategoria),1] <- idCategoria
	categorias[ConvertirANumero(idCategoria),2] <- nombre
	categorias[ConvertirANumero(idCategoria),3] <- descripcion
	categorias[ConvertirANumero(idCategoria),4] <- idProducto
	categorias[ConvertirANumero(idCategoria),5] <- "1"
FinFuncion

Funcion verCategoria(idCategoria, categoria Por Referencia, categorias Por Referencia)
	Definir fila Como Entero
	fila = buscarCategoria(idCategoria, categoria, categorias)
	Si fila > 0 Entonces
		Escribir "Id: ", categoria[1]
		Escribir "Nombre: ", categoria[2]
		Escribir "Descripcion: ", categoria[3]
		Escribir "Precio: ", categoria[4]
		Escribir "Stock: ", categoria[5]
	SiNo
		Escribir " -> Categoría no encontrada..."
	FinSi
FinFuncion

Funcion fila <- buscarCategoria(idCategoria, categoria Por Referencia, categorias Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categoria[1] <- categorias[i,1]
			categoria[2] <- categorias[i,2]
			categoria[3] <- categorias[i,3]
			categoria[4] <- categorias[i,4]
			categoria[5] <- categorias[i,5]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion actualizarCategoria(idCategoria, nombre, descripcion, idProducto, categorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categorias[ConvertirANumero(idCategoria),1] <- idCategoria
			categorias[ConvertirANumero(idCategoria),2] <- nombre
			categorias[ConvertirANumero(idCategoria),3] <- descripcion
			categorias[ConvertirANumero(idCategoria),4] <- idProducto 
			categorias[ConvertirANumero(idCategoria),5] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarCategoria(idCategoria, categorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categorias[i,5] <- "0"
		FinSi
	Fin Para
FinFuncion

Funcion listarCategorias(categorias Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,5] = "1" Entonces
			Escribir "Id: ", categorias[i,1]
			Escribir "Nombre: ", categorias[i,2]
			Escribir "Descripción: ", categorias[i,3]
			Escribir "Id producto : ", categorias[i,4]
			Escribir "Estado : ", categorias[i,5] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

// Funciones Extra Modulares
Funcion crearSubcategoria(idSubcategoria, nombre, descripcion, idCategoria, subcategoria Por Referencia)
	subcategoria[ConvertirANumero(idSubcategoria),1] <- idSubcategoria
	subcategoria[ConvertirANumero(idSubcategoria),2] <- nombre
	subcategoria[ConvertirANumero(idSubcategoria),3] <- descripcion
	subcategoria[ConvertirANumero(idSubcategoria),4] <- idCategoria
	subcategoria[ConvertirANumero(idSubcategoria),5] <- "1"
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

Funcion listarProductos(productos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,8] = "1" Entonces
			Escribir "Id: ", productos[i,1]
			Escribir "Nombre: ", productos[i,2]
			Escribir "Descripción: ", productos[i,3]
			Escribir "Precio: S/. ", productos[i,4]
			Escribir "Stock: ", productos[i,5]
//			Escribir "Imagen: ", productos[i,6]
//			Escribir "Fecha de creación: ", productos[i,7]
//			Escribir "Estado: ", productos[i,8] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

// Funciones de Persistencia
Funcion cargarProductos(productos Por Referencia)
	// Producto 1
	productos[1,1] <- "1"
	productos[1,2] <- "Mouse Inalambrico"
	productos[1,3] <- "Mouse ergonomico Bluetooth"
	productos[1,4] <- "19.99"
	productos[1,5] <- "150"
	productos[1,6] <- "img/mouse.jpg"
	productos[1,7] <- "2025-07-10 14:23"
	productos[1,8] <- "1"
	
	// Producto 2
	productos[2,1] <- "2"
	productos[2,2] <- "Teclado Mecanico"
	productos[2,3] <- "Teclado RGB con switches"
	productos[2,4] <- "49.95"
	productos[2,5] <- "85"
	productos[2,6] <- "img/teclado.jpg"
	productos[2,7] <- "2025-07-11 09:15"
	productos[2,8] <- "1"
	
	// Producto 3
	productos[3,1] <- "3"
	productos[3,2] <- "Monitor LED 24"
	productos[3,3] <- "Monitor Full HD HDMI"
	productos[3,4] <- "129.99"
	productos[3,5] <- "40"
	productos[3,6] <- "img/monitor.jpg"
	productos[3,7] <- "2025-07-11 11:05"
	productos[3,8] <- "1"
	
	// Producto 4
	productos[4,1] <- "4"
	productos[4,2] <- "Audifonos Bluetooth"
	productos[4,3] <- "Audifonos con microfono"
	productos[4,4] <- "34.50"
	productos[4,5] <- "70"
	productos[4,6] <- "img/audifonos.jpg"
	productos[4,7] <- "2025-07-12 08:47"
	productos[4,8] <- "1"
	
	// Producto 5
	productos[5,1] <- "5"
	productos[5,2] <- "Camara Web HD"
	productos[5,3] <- "Camara 720p para video"
	productos[5,4] <- "25.00"
	productos[5,5] <- "30"
	productos[5,6] <- "img/camara.jpg"
	productos[5,7] <- "2025-07-13 10:00"
	productos[5,8] <- "0"
	
	// Producto 6
	productos[6,1] <- "6"
	productos[6,2] <- "Disco Duro SSD 1TB"
	productos[6,3] <- "SSD SATA III para alta velocidad"
	productos[6,4] <- "79.99"
	productos[6,5] <- "120"
	productos[6,6] <- "img/ssd.jpg"
	productos[6,7] <- "2025-07-14 12:30"
	productos[6,8] <- "1"
	
	// Producto 7
	productos[7,1] <- "7"
	productos[7,2] <- "Fuente de Poder 600W"
	productos[7,3] <- "Fuente modular con certificación 80+"
	productos[7,4] <- "65.00"
	productos[7,5] <- "55"
	productos[7,6] <- "img/fuente.jpg"
	productos[7,7] <- "2025-07-14 15:45"
	productos[7,8] <- "1"
	
	// Producto 8
	productos[8,1] <- "8"
	productos[8,2] <- "Tarjeta Grafica GTX 1660"
	productos[8,3] <- "GPU para gaming con 6GB VRAM"
	productos[8,4] <- "249.99"
	productos[8,5] <- "20"
	productos[8,6] <- "img/grafica.jpg"
	productos[8,7] <- "2025-07-15 09:10"
	productos[8,8] <- "1"
FinFuncion
