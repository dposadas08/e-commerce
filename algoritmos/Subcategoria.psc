Algoritmo ModuloSubcategoria
    Definir i, fila Como Entero
    Definir idSubcategoria, idCategoria, nombre, descripcion, continuar Como Cadena
    
    Definir subcategorias, categorias Como Cadena
    Dimension subcategorias[20,5]
    Dimension categorias[10,4]
    
    Definir subcategoria, subsubcategoria, categoria Como Cadena
    Dimension subcategoria[5] 
    Dimension categoria[4]
	
	// -- CARGAR CATEGOR�AS --
	cargarCategorias(categorias)
	
	// -- CARGAR SUBCATEGOR�AS --
	cargarSubcategorias(subcategorias)
	
	// -- CREAR SUBCATEGOR�A --
	
	//- L�gica:
	//	Se requiere crear una subcategor�a ingresando los datos
	
	//- Algoritmo:
	//	1. Leer nombre
	//	2. Leer descripci�n
	//	3. Listar categor�as
	//	4. Leer id de la categor�a
	//	5. Buscar la categor�a por el id ingresado en la funci�n
	//	6. Validar si la categor�a existe
	//	7. Crear la subcategor�a con los datos ingresados
	//	8. Mostrar mensaje de la subcategor�a creada
	
	//- Pseudoc�digo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear subcategor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese nombre: "
	leer nombre
	Escribir "Ingrese descripci�n: "
	leer descripcion
	Escribir "-------------------------------------"
	listarCategorias(categorias)
	Escribir "Ingrese id de la categor�a: "
	leer idCategoria
	fila = buscarCategoria(idCategoria, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categor�a no existe. Ingrese id de la categor�a: "
		leer idCategoria
		fila = buscarCategoria(idCategoria, categoria, categorias)
	FinMientras
	crearSubcategoria(ConvertirATexto(generarId(subcategorias,20)), nombre, descripcion, idCategoria, subcategorias)
	Escribir "*** Subcategor�a creada con �xito ***"
	Escribir "-------------------------------------"
	
	// -- LISTAR SUBCATEGOR�AS --
	Escribir "Listar subcategor�as"
	Escribir "-------------------------------------"
	listarSubcategorias(subcategorias)
	
	// -- VER SUBCATEGOR�A --
	
	//- L�gica:
	//  Se requiere mostrar la subcategor�a por id
	
	//- Algoritmo:
	//  1. Leer el id de la subcategor�a
	//  2. Buscar la subcategor�a por el id ingresado en la funci�n
	//  3. Validar si la subcategor�a existe
	//  4. Mostrar la subcategor�a encontrada
	
	//- Pseudoc�digo en PSeint:
	Escribir "Ver subcategor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la subcategor�a para mostrar: "
	leer idSubcategoria
	fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La subcategor�a no existe. Ingrese id de la subcategor�a para mostrar: "
		leer id
		fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	FinMientras
	Escribir "-------------------------------------"
	verSubcategoria(idSubcategoria, subcategoria, subcategorias)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR SUBCATEGOR�A --
	
	//- L�gica:
	//	Se requiere actualizar los datos de la subcategor�a por id
	
	//- Algoritmo:
	//	1. Leer el id de la subcategor�a
	// 	2. Buscar la subcategor�a por el id ingresado en la funci�n
	//	3. Validar si la subcategor�a existe
	//	4. Leer nombre
	//	5. Leer descripcion
	//	6. Listar las categor�as disponibles
	//	7. Leer id de la categor�a
	//	8. Buscar la categor�a por el id ingresado en la funci�n
	// 	9. Validar si la categor�a existe
	//	10. Actualizar los datos de la subcategor�a en la funci�n
	//  11. Mostrar mensaje de subcategor�a actualizado
	
	//- Pseudoc�digo en PSeint:
	Escribir "Actualizar subcategor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la subcategor�a para actualizar: "
	leer idSubcategoria 
	fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La subcategor�a no existe. Ingrese id de la subcategor�a para actualizar: "
		leer id
		fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	FinMientras
	Escribir "Ingrese nombre: "
	leer nombre 
	Escribir "Ingrese descripci�n: "
	leer descripcion
	Escribir "-------------------------------------"
	listarCategorias(categorias)
	Escribir "Ingrese id de la categor�a: "
	leer idCategoria
	fila = buscarCategoria(idCategoria, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categor�a no existe. Ingrese id de la categor�a: "
		leer idCategoria
		fila = buscarCategoria(idCategoria, categoria, categorias)
	FinMientras
	actualizarSubcategoria(idSubcategoria, nombre, descripcion, idCategoria, subcategorias)
	Escribir "*** Subcategor�a actualizada con �xito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINAR SUBCATEGOR�A --
	
	//- L�gica:
	//	Se requiere que los datos de la subcategor�a se den de baja por id
	
	//- Algoritmo:
	//	1. Leer el id de la subcategor�a
	// 	2. Buscar la subcategor�a por el id ingresado en la funci�n
	//	3. Validar si la subcategor�a existe
	//	4. Cambiar el estado del subcategor�a a inactivo si lo encuentra
	//  5. Mostrar mensaje de subcategor�a eliminado
	
	//- Pseudoc�digo en PSeint:
	Escribir "Eliminar subcategor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la subcategor�a para eliminar: "
	leer idSubcategoria
	fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La subcategor�a no existe. Ingrese id de la subcategor�a para eliminar: "
		leer idSubcategoria
		fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	FinMientras
	eliminarSubcategoria(idSubcategoria, subcategorias)
	Escribir "*** Subcategor�a eliminada con �xito ***"
	Escribir "-------------------------------------"
	listarSubcategorias(subcategorias)
FinAlgoritmo

// Funciones Modulares
Funcion crearSubcategoria(idSubcategoria, nombre, descripcion, idCategoria, subcategorias Por Referencia)
	subcategorias[ConvertirANumero(idSubcategoria),1] <- idSubcategoria
	subcategorias[ConvertirANumero(idSubcategoria),2] <- nombre
	subcategorias[ConvertirANumero(idSubcategoria),3] <- descripcion
	subcategorias[ConvertirANumero(idSubcategoria),4] <- idCategoria
	subcategorias[ConvertirANumero(idSubcategoria),5] <- "1"
FinFuncion

Funcion verSubcategoria(idSubcategoria, subcategoria Por Referencia, subcategorias Por Referencia)
	Definir fila Como Entero
	fila = buscarSubcategoria(idSubcategoria, subcategoria, subcategorias)
	Si fila > 0 Entonces
		Escribir "Id: ", subcategoria[1]
		Escribir "Nombre: ", subcategoria[2]
		Escribir "Descripcion: ", subcategoria[3]
		Escribir "Id categor�a: ", subcategoria[4]
		Escribir "Estado: ", subcategoria[5]
	SiNo
		Escribir " -> Subcategor�a no encontrada..."
	FinSi
FinFuncion

Funcion fila <- buscarSubcategoria(idSubcategoria, subcategoria Por Referencia, subcategorias Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 20 Con Paso 1
		Si subcategorias[i,1] = idSubcategoria Entonces
			subcategoria[1] <- subcategorias[i,1]
			subcategoria[2] <- subcategorias[i,2]
			subcategoria[3] <- subcategorias[i,3]
			subcategoria[4] <- subcategorias[i,4]
			subcategoria[5] <- subcategorias[i,5]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion actualizarSubcategoria(idSubcategoria, nombre, descripcion, idCategoria, subcategorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si subcategorias[i,1] = idSubcategoria Entonces
			subcategorias[ConvertirANumero(idSubcategoria),1] <- idSubcategoria
			subcategorias[ConvertirANumero(idSubcategoria),2] <- nombre
			subcategorias[ConvertirANumero(idSubcategoria),3] <- descripcion
			subcategorias[ConvertirANumero(idSubcategoria),4] <- idCategoria 
			subcategorias[ConvertirANumero(idSubcategoria),5] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarSubcategoria(idSubcategoria, subcategorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si subcategorias[i,1] = idSubcategoria Entonces
			subcategorias[i,5] <- "0"
		FinSi
	Fin Para
FinFuncion

Funcion listarSubcategorias(subcategorias Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 20 Con Paso 1
		Si subcategorias[i,5] = "1" Entonces
			Escribir "Id: ", subcategorias[i,1]
			Escribir "Nombre: ", subcategorias[i,2]
			Escribir "Descripci�n: ", subcategorias[i,3]
			Escribir "Id categor�a: ", subcategorias[i,4]
			Escribir "Estado: ", subcategorias[i,5] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

// Funciones Extra Modulares
Funcion fila <- buscarCategoria(idCategoria, categoria Por Referencia, categorias Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categoria[1] <- categorias[i,1]
			categoria[2] <- categorias[i,2]
			categoria[3] <- categorias[i,3]
			categoria[4] <- categorias[i,4]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion listarCategorias(categorias Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si categorias[i,4] = "1" Entonces
			Escribir "Id: ", categorias[i,1]
			Escribir "Nombre: ", categorias[i,2]
			Escribir "Descripci�n: ", categorias[i,3]
			Escribir "Estado: ", categorias[i,4]
			Escribir "-------------------------------------"
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

// Funciones de Persistencia
Funcion cargarCategorias(categorias Por Referencia)
	categorias[1,1] <- "1"
	categorias[1,2] <- "Perif�ricos"
	categorias[1,3] <- "Dispositivos como mouse inal�mbricos para mejorar la experiencia de uso"
	categorias[1,4] <- "1"
	
	categorias[2,1] <- "2"
	categorias[2,2] <- "Perif�ricos"
	categorias[2,3] <- "Teclados mec�nicos ideales para escritura y juegos con retroiluminaci�n RGB"
	categorias[2,4] <- "1"
	
	categorias[3,1] <- "3"
	categorias[3,2] <- "Monitores"
	categorias[3,3] <- "Monitores LED de alta definici�n, perfectos para trabajo o entretenimiento"
	categorias[3,4] <- "1"
	
	categorias[4,1] <- "4"
	categorias[4,2] <- "Audio"
	categorias[4,3] <- "Aud�fonos Bluetooth con micr�fono para llamadas y m�sica"
	categorias[4,4] <- "1"
	
	categorias[5,1] <- "5"
	categorias[5,2] <- "C�maras"
	categorias[5,3] <- "C�maras web en HD para videollamadas y grabaciones b�sicas"
	categorias[5,4] <- "1"
	
	categorias[6,1] <- "6"
	categorias[6,2] <- "Almacenamiento"
	categorias[6,3] <- "Discos SSD de 1TB para almacenamiento r�pido y eficiente"
	categorias[6,4] <- "1"
	
	categorias[7,1] <- "7"
	categorias[7,2] <- "Energ�a"
	categorias[7,3] <- "Fuentes de poder para PCs, con certificaci�n de eficiencia energ�tica"
	categorias[7,4] <- "1"
	
	categorias[8,1] <- "8"
	categorias[8,2] <- "Tarjetas Gr�ficas"
	categorias[8,3] <- "GPUs como la GTX 1660, ideales para gaming y tareas gr�ficas exigentes"
	categorias[8,4] <- "1"
FinFuncion

Funcion cargarSubcategorias(subcategorias Por Referencia)
	subcategorias[1,1] <- "1"
	subcategorias[1,2] <- "Mouse"
	subcategorias[1,3] <- "Subcategor�a para dispositivos apuntadores inal�mbricos"
	subcategorias[1,4] <- "1"
	subcategorias[1,5] <- "1"

	subcategorias[2,1] <- "2"
	subcategorias[2,2] <- "Teclados"
	subcategorias[2,3] <- "Subcategor�a para teclados mec�nicos y ergon�micos"
	subcategorias[2,4] <- "2"
	subcategorias[2,5] <- "1"

	subcategorias[3,1] <- "3"
	subcategorias[3,2] <- "LED Full HD"
	subcategorias[3,3] <- "Monitores de 24 pulgadas con resoluci�n Full HD"
	subcategorias[3,4] <- "3"
	subcategorias[3,5] <- "1"

	subcategorias[4,1] <- "4"
	subcategorias[4,2] <- "Aud�fonos Inal�mbricos"
	subcategorias[4,3] <- "Subcategor�a para auriculares Bluetooth con micr�fono"
	subcategorias[4,4] <- "4"
	subcategorias[4,5] <- "1"

	subcategorias[5,1] <- "5"
	subcategorias[5,2] <- "Webcams"
	subcategorias[5,3] <- "Subcategor�a para c�maras HD de videollamada"
	subcategorias[5,4] <- "5"
	subcategorias[5,5] <- "1"

	subcategorias[6,1] <- "6"
	subcategorias[6,2] <- "SSD"
	subcategorias[6,3] <- "Unidades de estado s�lido de 1TB con interfaz SATA III"
	subcategorias[6,4] <- "6"
	subcategorias[6,5] <- "1"

	subcategorias[7,1] <- "7"
	subcategorias[7,2] <- "Fuentes Modulares"
	subcategorias[7,3] <- "Fuentes de poder con dise�o modular y certificaci�n"
	subcategorias[7,4] <- "7"
	subcategorias[7,5] <- "1"

	subcategorias[8,1] <- "8"
	subcategorias[8,2] <- "GPU Gaming"
	subcategorias[8,3] <- "Tarjetas gr�ficas dedicadas para juegos y alto rendimiento"
	subcategorias[8,4] <- "8"
	subcategorias[8,5] <- "1"
FinFuncion