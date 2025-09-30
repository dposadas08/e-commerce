Algoritmo ModuloCategoria
    Definir idCategoria, i, fila Como Entero
    Definir id, nombre, descripcion, continuar Como Cadena
    
    Definir categorias Como Cadena
    Dimension categorias[20,4]
    
    Definir categoria Como Cadena
    Dimension categoria[4]
	
	idCategoria = 1
	
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
	//	8. Mostrar mensaje de categoría creada
	//	9. Preguntar si desea volver a agregar otra subcategoría, si es sí vuelve a registrar, caso contrario termina
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear categoría"
	Escribir "-------------------------------------"
	Repetir	
		Escribir "Ingrese nombre: "
		leer nombre 
		Escribir "Ingrese descripción: "
		leer descripcion
		crearCategoria(ConvertirATexto(idCategoria), nombre, descripcion, categorias)
		Escribir "*** Categoría creado con éxito ***"
		Escribir "-------------------------------------"
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
	//	6. Actualizar los datos de la categoria en la función
	//  7. Mostrar mensaje de categoria actualizado
	
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
	actualizarCategoria(id, nombre, descripcion, categorias)
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
		Escribir "Descripción: ", categoria[3]
		Escribir "Estado : ", categoria[4] 
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
			Escribir "Descripción: ", categorias[i,3]
			Escribir "Estado : ", categorias[i,4] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion