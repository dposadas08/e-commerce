Algoritmo ModuloCategoria
    Definir idCategoria, i, fila Como Entero
    Definir id, nombre, descripcion, continuar Como Cadena
    
    Definir categorias Como Cadena
    Dimension categorias[20,4]
    
    Definir categoria Como Cadena
    Dimension categoria[4]
	
	idCategoria = 1
	
	// -- CREAR CATEGOR�A --
	
	//- L�gica:
	//	Se requiere crear la categor�a y sus subcategor�as para el producto ingresando los datos
	
	//- Algoritmo:
	//	1. Leer nombre
	//	2. Leer descripci�n
	//	3. Listar productos existentes
	//	4. Leer id del producto
	//	5. Buscar el producto por el id ingresado en la funci�n
	//	6. Validar si el producto existe
	//	7. Crear la categor�a con los datos ingresados en la funci�n
	//	8. Mostrar mensaje de categor�a creada
	//	9. Preguntar si desea volver a agregar otra subcategor�a, si es s� vuelve a registrar, caso contrario termina
	
	//- Pseudoc�digo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear categor�a"
	Escribir "-------------------------------------"
	Repetir	
		Escribir "Ingrese nombre: "
		leer nombre 
		Escribir "Ingrese descripci�n: "
		leer descripcion
		crearCategoria(ConvertirATexto(idCategoria), nombre, descripcion, categorias)
		Escribir "*** Categor�a creado con �xito ***"
		Escribir "-------------------------------------"
		Escribir "�Desea crear otra categor�a? s/n:"
		leer continuar
		Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
			Escribir "Opci�n inv�lida. �Desea crear otra categor�a? s/n:"
			leer continuar
		FinMientras
		idCategoria = idCategoria + 1
	Hasta Que Minusculas(continuar) = 'n'
	Escribir "-------------------------------------"
	
	// -- LISTAR CATEGOR�AS --
	
	//- L�gica:
	//  Se requiere la lista de todas las categor�as registradas
	
	//- Algoritmo:
	//  1. Buscar todas las categor�as en la funci�n
	//  2. Validar si cada categor�a est� activa
	//  3. Mostrar la lista de todas las categor�as activas
	
	//- Pseudoc�digo en PSeint:
	Escribir "Listar categor�as"
	Escribir "-------------------------------------"
	listarCategorias(categorias)
	
	// -- VER CATEGOR�AS --
	
	//- L�gica:
	//  Se requiere mostrar la categor�a por id
	
	//- Algoritmo:
	//  1. Leer el id de la categor�a
	//  2. Buscar la categor�a por el id ingresado en la funci�n
	//  3. Validar si la categor�a existe
	//  4. Mostrar la categor�a encontrada

	//- Pseudoc�digo en PSeint:
	Escribir "Ver categor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categor�a para mostrar: "
	leer id
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categor�a no existe. Ingrese id de la categor�a para mostrar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	Escribir "-------------------------------------"
	verCategoria(id, categoria, categorias)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR CATEGOR�A --
	
	//- L�gica:
	//	Se requiere actualizar los datos de la categoria por id

	//- Algoritmo:
	//	1. Leer el id de la categor�a
	// 	2. Buscar la categoria por el id ingresado en la funci�n
	//	3. Validar si la categor�a existe
	//	4. Leer nombre
	//	5. Leer descripcion
	//	6. Actualizar los datos de la categoria en la funci�n
	//  7. Mostrar mensaje de categoria actualizado
	
	//- Pseudoc�digo en PSeint:
	Escribir "Actualizar categor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categor�a para actualizar: "
	leer id 
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categor�a no existe. Ingrese id de la categor�a para actualizar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	Escribir "Ingrese nombre: "
	leer nombre 
	Escribir "Ingrese descripci�n: "
	leer descripcion
	actualizarCategoria(id, nombre, descripcion, categorias)
	Escribir "*** Categor�a actualizada con �xito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINAR CATEGOR�A --
	
	//- L�gica:
	//	Se requiere que los datos de la categoria se den de baja por id
	
	//- Algoritmo:
	//	1. Leer el id de la categor�a
	// 	2. Buscar la categoria por el id ingresado en la funci�n
	//	3. Validar si la categor�a existe
	//	4. Cambiar el estado del categoria a inactivo si lo encuentra
	//  5. Mostrar mensaje de categoria eliminado
	
	//- Pseudoc�digo en PSeint:
	Escribir "Eliminar categor�a"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la categor�a para eliminar: "
	leer id
	fila = buscarCategoria(id, categoria, categorias)
	Mientras No (fila > 0) Hacer 
		Escribir "La categor�a no existe. Ingrese id de la categor�a para eliminar: "
		leer id
		fila = buscarCategoria(id, categoria, categorias)
	FinMientras
	eliminarCategoria(id, categorias)
	Escribir "*** Categor�a eliminada con �xito ***"
	Escribir "-------------------------------------"
FinAlgoritmo

// Funciones Modulares
Funcion crearCategoria(idCategoria, nombre, descripcion, categorias Por Referencia)
	categorias[ConvertirANumero(idCategoria),1] <- idCategoria
	categorias[ConvertirANumero(idCategoria),2] <- nombre
	categorias[ConvertirANumero(idCategoria),3] <- descripcion
	categorias[ConvertirANumero(idCategoria),4] <- "1"
FinFuncion

Funcion verCategoria(idCategoria, categoria Por Referencia, categorias Por Referencia)
	Definir fila Como Entero
	fila = buscarCategoria(idCategoria, categoria, categorias)
	Si fila > 0 Entonces
		Escribir "Id: ", categoria[1]
		Escribir "Nombre: ", categoria[2]
		Escribir "Descripci�n: ", categoria[3]
		Escribir "Estado : ", categoria[4] 
	SiNo
		Escribir " -> Categor�a no encontrada..."
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
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion actualizarCategoria(idCategoria, nombre, descripcion, categorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categorias[ConvertirANumero(idCategoria),1] <- idCategoria
			categorias[ConvertirANumero(idCategoria),2] <- nombre
			categorias[ConvertirANumero(idCategoria),3] <- descripcion
			categorias[ConvertirANumero(idCategoria),4] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarCategoria(idCategoria, categorias Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,1] = idCategoria Entonces
			categorias[i,4] <- "0"
		FinSi
	Fin Para
FinFuncion

Funcion listarCategorias(categorias Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 20 Con Paso 1
		Si categorias[i,4] = "1" Entonces
			Escribir "Id: ", categorias[i,1]
			Escribir "Nombre: ", categorias[i,2]
			Escribir "Descripci�n: ", categorias[i,3]
			Escribir "Estado : ", categorias[i,4] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion