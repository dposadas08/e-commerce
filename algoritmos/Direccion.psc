Algoritmo ModuloDireccion
    Definir idDireccion, i, fila, filas Como Entero
    Definir id, idUsuario, continuar, direccionCasa, ciudad, provincia, pais, codigoPostal Como Cadena
	
    Definir direcciones, usuarios Como Cadena
    Dimension direcciones[10,8]
    Dimension usuarios[10,9]
	
    Definir direccion, usuario Como Cadena
    Dimension direccion[8]
    Dimension usuario[9]

	idDireccion = 1 
	
	// -- CARGAR USUARIOS --
	cargarUsuarios(usuarios)

	// -- CREAR DIRECCI�N --
	
	//- L�gica:
	//	Se requiere crear la direcci�n del usuario ingresando los datos
	
	//- Algoritmo:
	//	1. Listar usuarios existentes
	//	2. Leer ID del usuario
	//	3. Buscar el usuario por el id ingresado en la funci�n
	//	4. Validar si el usuario existe 
	//	5. Agregar direcci�n
	//	6. Leer direcci�n
	//	7. Leer ciudad
	//	8. Leer provincia
	//	9. Leer c�digo postal
	//	10. Leer pa�s
	//	11. Crear la direcci�n con los datos ingresados en la funci�n
	//	12. Mostrar mensaje de direcci�n creada
	//	13. Preguntar si desea volver a agregar otra direcci�n, si es s� vuelve a registrar, caso contrario sigue la secuencia
	//	14. Preguntar si desea elegir otro usuario para agregar direcciones, si es s� vuelve a registrar, caso contrario termina

	
	//- Pseudoc�digo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear direcci�n"
	Escribir "-------------------------------------"
	Repetir	
		listarUsuarios(usuarios)
		Escribir "Ingrese id del usuario: "
		leer idUsuario
		fila = buscarUsuario(idUsuario, usuario, usuarios)
		Mientras No (fila > 0) Hacer 
			Escribir "El usuario no existe. Ingrese id del usuario: "
			leer idUsuario
			fila = buscarUsuario(idUsuario, usuario, usuarios)
		FinMientras
		Repetir
			Escribir "Ingrese direcci�n: "
			leer direccionCasa  
			Escribir "Ingrese ciudad: "
			leer ciudad 
			Escribir "Ingrese provincia: "
			leer provincia 
			Escribir "Ingrese c�digo postal: "
			leer codigoPostal
			Escribir "Ingrese pa�s: "
			leer pais
			crearDireccion(ConvertirATexto(idDireccion), idUsuario, direccionCasa, ciudad, provincia, codigoPostal, pais, direcciones)
			Escribir "*** Direcci�n creado con �xito ***"
			Escribir "-------------------------------------"
			Escribir "�Desea agregar otra direcci�n al usuario? s/n:"
			leer continuar
			Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
				Escribir "Opci�n inv�lida. �Desea agregar otra direcci�n al usuario? s/n:"
				leer continuar
			FinMientras
			idDireccion = idDireccion + 1
		Hasta Que Minusculas(continuar) = 'n' 
		Escribir "�Desea elegir otro usuario? s/n:"
		leer continuar
		Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
			Escribir "Opci�n inv�lida. �Desea elegir otro usuario? s/n:"
			leer continuar
		FinMientras
	Hasta Que Minusculas(continuar) = 'n'
	Escribir "-------------------------------------"
	
	// -- LISTAR DIRECCIONES --
	
	//- L�gica:
	//	Se requiere la lista de todos las direcciones registrados
	
	//- Algoritmo:
	//	1. Buscar todos las direcciones en la funci�n
	//	2. Validar si la direcci�n esta activo en la funci�n
	//	3. Mostrar la lista de todos las direcciones activas
	
	//- Pseudoc�digo en PSeint:
	Escribir "Listar direcciones"
	Escribir "-------------------------------------"
	listarDirecciones(direcciones)
	
	// -- VER DIRECCI�N --
	
	//- L�gica:
	//	Se requiere mostrar al direcci�n por id
	
	//- Algoritmo:
	//	1. Leer id de direcci�n
	//	2. Buscar la direcci�n por el id ingresado en la funci�n
	//	3. Validar si la direcci�n existe 
	//	4. Validar si la direcci�n esta activa en la funci�n
	//	5. Mostrar la direcci�n encontrada
	
	//- Pseudoc�digo en PSeint:
	Escribir "Ver direcci�n"
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la direcci�n para mostrar: "
	leer id
	fila = buscarDireccion(id, direccion, direcciones)
	Mientras No (fila > 0) Hacer 
		Escribir "La direcci�n no existe. Ingrese id de la direcci�n para mostrar: "
		leer id
		fila = buscarDireccion(id, direccion, direcciones)
	FinMientras
	Escribir "-------------------------------------"
	verDireccion(id, direccion, direcciones)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR DIRECCI�N --
	
	//- L�gica:
	//	Se requiere actualizar los datos de la direcci�n existente por ID del usuario
	
	//- Algoritmo:
	//	1. Listar los usuarios existentes
	//	2. Leer el id del usuario
	//	3. Buscar el usuario por el id ingresado en la funci�n
	//	4. Validar si el usuario existe y si tiene direcciones
	//	5. Listar las direcciones del usuario
	//	6. Leer id de la direcci�n
	//	7. Buscar la direcci�n por el id ingresado en la funci�n
	//	8. Validar si la direcci�n existe
	//	9. Leer direcci�n
	//	10. Leer ciudad
	//	11. Leer provincia
	//	12. Leer c�digo postal
	//	13. Leer pa�s
	//	14. Actualizar los datos de la direcci�n en la funci�n
	//	15. Mostrar mensaje de direcci�n actualizada
	
	//- Pseudoc�digo en PSeint:
	Escribir "Actualizar direcci�n"
	Escribir "-------------------------------------" 
	listarUsuarios(usuarios)
	Escribir "Ingrese id del usuario: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0 y filas > 0) Hacer 
		fila = buscarUsuario(idUsuario, usuario, usuarios)
		Si fila = 0 Entonces
			Escribir "El usuario no existe. Ingrese id del usuario: "
			leer idUsuario
			fila = buscarUsuario(idUsuario, usuario, usuarios)
		FinSi
		filas = contarDirecciones(idUsuario, direcciones)
		Si fila > 0 y filas = 0 Entonces
			Escribir "El usuario no tiene direcciones. Ingrese id del usuario: "
			leer idUsuario
			filas = contarDirecciones(idUsuario, direcciones)
		FinSi
	FinMientras
	Escribir "-------------------------------------"
	listarDireccionesPorIdUsuario(idUsuario, direcciones)
	Escribir "Ingrese id de la direcci�n para actualizar: "
	leer id
	existe = existeDireccion(idUsuario, id, direcciones)
	Mientras No existe Hacer	
		Escribir "Id inv�lida. Ingrese id de la direcci�n para actualizar:"
		leer id
		existe = existeDireccion(idUsuario, id, direcciones)
	FinMientras
	Escribir "Ingrese direcci�n: "
	leer direccionCasa  
	Escribir "Ingrese ciudad: "
	leer ciudad 
	Escribir "Ingrese provincia: "
	leer provincia 
	Escribir "Ingrese c�digo postal: "
	leer codigoPostal
	Escribir "Ingrese pa�s: "
	leer pais
	actualizarDireccion(id, idUsuario, direccionCasa, ciudad, provincia, codigoPostal, pais, direcciones)
	Escribir "*** Direcci�n actualizada con �xito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINAR DIRECCI�N --
	
	//- L�gica:
	//	Se requiere que los datos de la direcci�n se den de baja por id
	
	//- Algoritmo:
	//	1. Leer id de direccion
	//	2. Buscar el direccion por el id ingresado en la funci�n
	//	3. Validar si la categor�a existe
	//	4. Cambiar el estado del direccion a inactivo si lo encuentra
	//  5. Mostrar mensaje de direccion eliminado
	
	//- Pseudoc�digo en PSeint:
	Escribir "Eliminar direcci�n"
	Escribir "-------------------------------------"
	listarUsuarios(usuarios)
	Escribir "Ingrese id del usuario: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0 y filas > 0) Hacer 
		fila = buscarUsuario(idUsuario, usuario, usuarios)
		Si fila = 0 Entonces
			Escribir "El usuario no existe. Ingrese id del usuario: "
			leer idUsuario
			fila = buscarUsuario(idUsuario, usuario, usuarios)
		FinSi
		filas = contarDirecciones(idUsuario, direcciones)
		Si fila > 0 y filas = 0 Entonces
			Escribir "El usuario no tiene direcciones. Ingrese id del usuario: "
			leer idUsuario
			filas = contarDirecciones(idUsuario, direcciones)
		FinSi
	FinMientras
	listarDireccionesPorIdUsuario(idUsuario, direcciones)
	Escribir "-------------------------------------"
	Escribir "Ingrese id de la direcci�n para eliminar: "
	leer id
	existe = existeDireccion(idUsuario, id, direcciones)
	Mientras No existe Hacer	
		Escribir "Id inv�lida. Ingrese id de la direcci�n para eliminar:"
		leer id
		existe = existeDireccion(idUsuario, id, direcciones)
	FinMientras
	eliminarDireccion(id, direcciones)
	Escribir "*** Direcci�n eliminada con �xito ***"
	Escribir "-------------------------------------"
FinAlgoritmo

// Funciones Modulares
Funcion crearDireccion(idDireccion, idUsuario, direccion, ciudad, provincia, codigoPostal, pais, direcciones Por Referencia)
	direcciones[ConvertirANumero(idDireccion),1] <- idDireccion
	direcciones[ConvertirANumero(idDireccion),2] <- idUsuario
	direcciones[ConvertirANumero(idDireccion),3] <- direccion
	direcciones[ConvertirANumero(idDireccion),4] <- ciudad
	direcciones[ConvertirANumero(idDireccion),5] <- provincia
	direcciones[ConvertirANumero(idDireccion),6] <- codigoPostal
	direcciones[ConvertirANumero(idDireccion),7] <- pais
	direcciones[ConvertirANumero(idDireccion),8] <- "1"
FinFuncion

Funcion verDireccion(idDireccion, direccion Por Referencia, direcciones Por Referencia)
	Definir fila Como Entero
	fila = buscarDireccion(idDireccion, direccion, direcciones)
	Si fila > 0 Entonces
		Escribir "Id: ", direccion[1]
		Escribir "Id usuario: ", direccion[2]
		Escribir "Direcci�n: ", direccion[3]
		Escribir "Ciudad: ", direccion[4]
		Escribir "Provincia: ", direccion[5]
		Escribir "C�digo postal: ", direccion[6]
		Escribir "Pa�s: ", direccion[7]
		Escribir "Estado: ", direccion[8] 
	SiNo
		Escribir " -> Direcci�n no encontrada..."
	FinSi
FinFuncion

Funcion fila <- buscarDireccion(idDireccion, direccion Por Referencia, direcciones Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,1] = idDireccion Entonces
			direccion[1] <- direcciones[i,1]
			direccion[2] <- direcciones[i,2]
			direccion[3] <- direcciones[i,3]
			direccion[4] <- direcciones[i,4]
			direccion[5] <- direcciones[i,5]
			direccion[6] <- direcciones[i,6]
			direccion[7] <- direcciones[i,7]
			direccion[8] <- direcciones[i,8]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

Funcion actualizarDireccion(idDireccion, idUsuario, direccion, ciudad, provincia, codigoPostal, pais, direcciones Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,1] = idDireccion Entonces
			direcciones[ConvertirANumero(idDireccion),1] <- idDireccion
			direcciones[ConvertirANumero(idDireccion),2] <- idUsuario
			direcciones[ConvertirANumero(idDireccion),3] <- direccion
			direcciones[ConvertirANumero(idDireccion),4] <- ciudad
			direcciones[ConvertirANumero(idDireccion),5] <- provincia
			direcciones[ConvertirANumero(idDireccion),6] <- codigoPostal
			direcciones[ConvertirANumero(idDireccion),7] <- pais
			direcciones[ConvertirANumero(idDireccion),8] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarDireccion(idDireccion, direcciones Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,1] = idDireccion Entonces
			direcciones[i,8] <- "0"
		FinSi
	Fin Para
FinFuncion

Funcion listarDirecciones(direcciones Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Escribir "Id: ", direcciones[i,1]
			Escribir "Id usuario: ", direcciones[i,2]
			Escribir "Direcci�n: ", direcciones[i,3]
			Escribir "Ciudad: ", direcciones[i,4]
			Escribir "Provincia: ", direcciones[i,5]
			Escribir "C�digo postal: ", direcciones[i,6]
			Escribir "Pa�s: ", direcciones[i,7]
			Escribir "Estado: ", direcciones[i,8] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

Funcion listarDireccionesPorIdUsuario(idUsuario, direcciones Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Si direcciones[i,2] = idUsuario Entonces
				Escribir direcciones[i,1], ". ", direcciones[i,3], " ", direcciones[i,6], ", ", direcciones[i,5], ", ", direcciones[i,4], ", " direcciones[i,7]
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion existe <- existeDireccion(idUsuario, idDireccion, direcciones Por Referencia)
	Definir i Como Entero
	Definir existe Como Logico
	existe = Falso
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Si direcciones[i,2] = idUsuario Entonces
				Si direcciones[i,1] = idDireccion Entonces 
					existe = Verdadero
				FinSi
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion filas <- contarDirecciones(idUsuario, direcciones Por Referencia)
	Definir filas, i Como Entero
	filas = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Si direcciones[i,2] = idUsuario Entonces 
				filas = filas + 1
			FinSi
		FinSi
	Fin Para
FinFuncion

// Funciones Extra Modulares
// Usuario
Funcion listarUsuarios(usuarios Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,9] = "1" Entonces
			Escribir "Id: ", usuarios[i,1]
			Escribir "Nombre: ", usuarios[i,2]
			Escribir "Apellido: ", usuarios[i,3]
			Escribir "Dni: ", usuarios[i,4]
			Escribir "Correo: ", usuarios[i,5]
//			Escribir "Contrase�a: ", usuarios[i,6]
//			Escribir "Fecha de registro: ", usuarios[i,7]
//			Escribir "Tipo de usuario: ", usuarios[i,8]
//			Escribir "Estado: ", usuarios[i,9]
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

Funcion fila <- buscarUsuario(idUsuario, usuario Por Referencia, usuarios Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,1] = idUsuario Entonces
			usuario[1] <- usuarios[i,1]
			usuario[2] <- usuarios[i,2]
			usuario[3] <- usuarios[i,3]
			usuario[4] <- usuarios[i,4]
			usuario[5] <- usuarios[i,5]
			usuario[6] <- usuarios[i,6]
			usuario[7] <- usuarios[i,7]
			usuario[8] <- usuarios[i,8]
			usuario[9] <- usuarios[i,9]
			fila = fila + 1
		FinSi
	Fin Para
FinFuncion

// Funciones de Persistencia
Funcion cargarUsuarios(usuarios Por Referencia)
	usuarios[1,1] <- "1"
	usuarios[1,2] <- "Juan"     
	usuarios[1,3] <- "Perez"
	usuarios[1,4] <- "12345678"
	usuarios[1,5] <- "juan.perez@email.com"
	usuarios[1,6] <- "12345"
	usuarios[1,7] <- "2024-05-01"
	usuarios[1,8] <- "Administrador"
	usuarios[1,9] <- "1"
	
	usuarios[2,1] <- "2"
	usuarios[2,2] <- "Maria"
	usuarios[2,3] <- "Lopez"
	usuarios[2,4] <- "23456789"
	usuarios[2,5] <- "maria.lopez@email.com"
	usuarios[2,6] <- "abcde"
	usuarios[2,7] <- "2024-06-12"
	usuarios[2,8] <- "Cliente"
	usuarios[2,9] <- "1"
	
	usuarios[3,1] <- "3"
	usuarios[3,2] <- "Carlos"
	usuarios[3,3] <- "Ruiz"
	usuarios[3,4] <- "34567890"
	usuarios[3,5] <- "carlos.ruiz@email.com"
	usuarios[3,6] <- "qwerty"
	usuarios[3,7] <- "2024-07-03"
	usuarios[3,8] <- "Cliente"
	usuarios[3,9] <- "1"
	
	usuarios[4,1] <- "4"
	usuarios[4,2] <- "Ana"
	usuarios[4,3] <- "Torres"
	usuarios[4,4] <- "45678901"
	usuarios[4,5] <- "ana.torres@email.com"
	usuarios[4,6] <- "zxcvb"
	usuarios[4,7] <- "2024-06-25"
	usuarios[4,8] <- "Cliente"
	usuarios[4,9] <- "1"
	
	usuarios[5,1] <- "5"
	usuarios[5,2] <- "Luis"
	usuarios[5,3] <- "G�mez"
	usuarios[5,4] <- "56789012"
	usuarios[5,5] <- "luis.gomez@email.com"
	usuarios[5,6] <- "luis123"
	usuarios[5,7] <- "2024-07-10"
	usuarios[5,8] <- "Administrador"
	usuarios[5,9] <- "1"
FinFuncion

