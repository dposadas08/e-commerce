Algoritmo ModuloUsuario
    Definir i, fila Como Entero
    Definir idUsuario, nombre, apellido, dni, email, password, rol, perfil Como Cadena
    
    Definir usuarios Como Cadena
    Dimension usuarios[10,9]
    
    Definir usuario Como Cadena
    Dimension usuario[9]
	
	// -- CARGAR USUARIOS --
	cargarUsuarios(usuarios)
	
	// -- CREAR USUARIO --
	
	//- Lógica:
	//	Se requiere crear un usuario ingresando los datos
	
	//- Algoritmo:
	//	1. Leer nombre
	//	2. Leer apellido
	//	3. Leer dni
	//	4. Leer email
	//	5. Leer password
	//	6. Leer rol
	//	7. Crear fecha de registro en la función
	//	8. Crear el usuario con los datos ingresados en la función
	//  9. Mostrar mensaje de usuario creado
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear usuario"
	Escribir "-------------------------------------"
	Escribir "Ingrese nombre: "
	leer nombre
	Escribir "Ingrese apellido: "
	leer apellido
	Escribir "Ingrese dni: "
	leer dni
	Escribir "Ingrese email: "
	leer email
	Escribir "Ingrese password: "
	leer password
	Escribir "Elija perfil (c: Cliente, a: Administrador): "
	leer rol
	Mientras No (Minusculas(rol) = "c" o Minusculas(rol) = "a") Hacer	
		Escribir "Opción inválida. Elija perfil (c: Cliente, a: Administrador): "
		leer rol
	FinMientras
	Si rol = "c" Entonces
		perfil = "Cliente"
	SiNo
		perfil = "Administrador"
	FinSi
	crearUsuario(ConvertirATexto(generarId(usuarios,10)), nombre, apellido, dni, email, password, perfil, usuarios)
	Escribir "*** Usuario creado con éxito ***"
	Escribir "-------------------------------------"
	
	// -- LISTAR USUARIOS --
	
	//- Lógica:
	//	Se requiere la lista de todos los usuarios registrados
	
	//- Algoritmo:
	//	1. Buscar todos los usuarios en la función
	//	2. Validar si el usuario esta activo en la función
	//	3. Mostrar la lista de todos los usuarios activos
	
	//- Pseudocódigo en PSeint:
	Escribir "Listar usuarios"
	Escribir "-------------------------------------"
	listarUsuarios(usuarios)
	
	// -- VER USUARIO --
	
	//- Lógica:
	//	Se requiere mostrar al usuario por id
	
	//- Algoritmo:
	//	1. Leer id de usuario
	//	2. Buscar el usuario por el id ingresado en la función
	// 	3. Validar si el usuario existe
	//	3. Validar si el usuario esta activo en la función
	//	4. Mostrar el usuario encontrado
	
	//- Pseudocódigo en PSeint:
	Escribir "Ver perfil de usuario"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del usuario para mostrar: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0) Hacer 
		Escribir "El usuario no existe. Ingrese id del usuario para mostrar: "
		leer idUsuario
		fila = buscarUsuario(idUsuario, usuario, usuarios)
	FinMientras
	Escribir "-------------------------------------"
	verUsuario(idUsuario, usuario, usuarios)
	Escribir "-------------------------------------"
	
	// -- ACTUALIZAR USUARIO --
	
	//- Lógica:
	//	Se requiere actualizar los datos del usuario
	
	//- Algoritmo:
	//	1. Leer id
	//	2. Leer nombre
	//	3. Leer apellido
	//	4. Leer dni
	//	5. Leer email
	//	6. Leer password
	//	7. Leer rol
	//	8. Buscar el usuario por el id ingresado en la función
	// 	9. Validar si el usuario existe
	//	10. Actualizar los datos del usuario en la función
	//  11. Mostrar mensaje de usuario actualizado
	
	//- Pseudocódigo en PSeint:
	Escribir "Actualizar usuario"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del usuario para actualizar: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0) Hacer 
		Escribir "El usuario no existe. Ingrese id del usuario para actualizar: "
		leer idUsuario
		fila = buscarUsuario(idUsuario, usuario, usuarios)
	FinMientras
	Escribir "Ingrese nombre: "
	leer nombre
	Escribir "Ingrese apellido: "
	leer apellido
	Escribir "Ingrese dni: "
	leer dni
	Escribir "Ingrese email: "
	leer email
	Escribir "Ingrese password: "
	leer password
	Escribir "Elija perfil (c: Cliente, a: Administrador): "
	leer rol
	Mientras No (Minusculas(rol) = "c" o Minusculas(rol) = "a") Hacer	
		Escribir "Opción inválida. Elija perfil (c: Cliente, a: Administrador): "
		leer rol
	FinMientras
	Si rol = "c" Entonces
		perfil = "Cliente"
	SiNo
		perfil = "Administrador"
	FinSi
	actualizarUsuario(idUsuario, nombre, apellido, dni, email, password, perfil, usuarios)
	Escribir "*** Usuario actualizado con éxito ***"
	Escribir "-------------------------------------"
	
	// -- ELIMINAR USUARIO --
	
	//- Lógica:
	//	Se requiere que los datos del usuario se den de baja
	
	//- Algoritmo:
	//	1. Leer id de usuario
	//	2. Buscar el usuario por el id ingresado en la función
	// 	3. Validar si el usuario existe
	//	4. Cambiar el estado del usuario a inactivo si lo encuentra
	//  5. Mostrar mensaje de usuario eliminado
	
	//- Pseudocódigo en PSeint:
	Escribir "Eliminar usuario"
	Escribir "-------------------------------------"
	Escribir "Ingrese id del usuario para eliminar: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0) Hacer 
		Escribir "El usuario no existe. Ingrese id del usuario para eliminar: "
		leer idUsuario
		fila = buscarUsuario(idUsuario, usuario, usuarios)
	FinMientras
	eliminarUsuario(idUsuario, usuarios)
	Escribir "*** Usuario eliminado con éxito ***"
	Escribir "-------------------------------------"
	
	// -- INICIAR SESIÓN --
	
	//- Lógica:
	//	Se requiere que los datos del usuario (correo, contraseña y rol) sean validados para iniciar sesión 
	
	//- Algoritmo:
	//	1. Leer rol
	//	2. Leer email
	//	3. Leer password
	//	4. Validar si los datos ingresados estan completos
	//	5. Validar si los datos ingresados existen en la función
	//	6. Abrir sesión y devolver los datos del usuario o mostrar un mensaje de datos inválidos si no existe
	
	//- Pseudocódigo en PSeint:
	Escribir "Iniciar Sesión"
	Escribir "-------------------------------------"
	Repetir
		Escribir "Elija perfil (c: Cliente, a: Administrador): "
        leer rol
		Mientras No (Minusculas(rol) = "c" o Minusculas(rol) = "a") Hacer	
			Escribir "Opción inválida. Elija perfil (c: Cliente, a: Administrador): "
			leer rol
		FinMientras
		Escribir "Ingrese email: "
        leer email
		Escribir "Ingrese password: "
        leer password
		Si No (email = "" o password = "" o rol = "") Entonces
			Si rol = "c" Entonces
				perfil = "Cliente"
			SiNo
				perfil = "Administrador"
			FinSi
			fila = iniciarSesion(email, password, perfil, usuario, usuarios)
			Si fila > 0  Entonces
				Escribir "*** Bienvenido, ", usuario[2], " ***"
			SiNo
				Escribir " -> Datos ingresados inválidos..."
			FinSi
		SiNo
			Escribir " -> Debe completar todos sus datos..."
		FinSi
    Hasta Que fila > 0 
FinAlgoritmo

// Funciones Modulares
Funcion crearUsuario(idUsuario, nombre, apellido, dni, email, password, rol, usuarios Por Referencia)
	usuarios[ConvertirANumero(idUsuario),1] <- idUsuario
	usuarios[ConvertirANumero(idUsuario),2] <- nombre
	usuarios[ConvertirANumero(idUsuario),3] <- apellido
	usuarios[ConvertirANumero(idUsuario),4] <- dni
	usuarios[ConvertirANumero(idUsuario),5] <- email
	usuarios[ConvertirANumero(idUsuario),6] <- password
	usuarios[ConvertirANumero(idUsuario),7] <- formatearFechaHoraISO(FechaActual(), HoraActual())
	usuarios[ConvertirANumero(idUsuario),8] <- rol
	usuarios[ConvertirANumero(idUsuario),9] <- "1"
FinFuncion

Funcion verUsuario(idUsuario, usuario Por Referencia, usuarios Por Referencia)
	Definir fila Como Entero
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Si fila > 0 Entonces
		Escribir "Id: ", usuario[1]
		Escribir "Nombre: ", usuario[2]
		Escribir "Apellido: ", usuario[3]
		Escribir "Dni: ", usuario[4]
		Escribir "Correo: ", usuario[5]
		Escribir "Contraseña: ", usuario[6]
		Escribir "Fecha de registro: ", usuario[7]
		Escribir "Tipo de usuario: ", usuario[8]
		Escribir "Estado: ", usuario[9]
	SiNo
		Escribir " -> Usuario no encontrado..."
	FinSi
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

Funcion actualizarUsuario(idUsuario, nombre, apellido, dni, email, password, rol, usuarios Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,1] = idUsuario Entonces
			usuarios[ConvertirANumero(idUsuario),1] <- idUsuario
			usuarios[ConvertirANumero(idUsuario),2] <- nombre
			usuarios[ConvertirANumero(idUsuario),3] <- apellido
			usuarios[ConvertirANumero(idUsuario),4] <- dni
			usuarios[ConvertirANumero(idUsuario),5] <- email
			usuarios[ConvertirANumero(idUsuario),6] <- password
			usuarios[ConvertirANumero(idUsuario),8] <- rol
			usuarios[ConvertirANumero(idUsuario),9] <- "1"
		FinSi
	Fin Para	
FinFuncion

Funcion eliminarUsuario(idUsuario, usuarios Por Referencia)
	Definir i Como Entero
 	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,1] = idUsuario Entonces
			usuarios[i,9] <- "0"
		FinSi
	Fin Para
FinFuncion

Funcion listarUsuarios(usuarios Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,9] = "1" Entonces
			Escribir "Id: ", usuarios[i,1]
			Escribir "Nombre: ", usuarios[i,2]
			Escribir "Apellido: ", usuarios[i,3]
			Escribir "Dni: ", usuarios[i,4]
			Escribir "Correo: ", usuarios[i,5]
			Escribir "Contraseña: ", usuarios[i,6]
			Escribir "Fecha de registro: ", usuarios[i,7]
			Escribir "Tipo de usuario: ", usuarios[i,8]
			Escribir "Estado: ", usuarios[i,9]
			Escribir "-------------------------------------"
		FinSi
	Fin Para
FinFuncion

Funcion fila <- iniciarSesion(email, password, rol, usuario Por Referencia, usuarios Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,5] = email y usuarios[i,6] = password y usuarios[i,8] = rol Entonces 
			Si usuarios[i,9] = "1" Entonces
				fila = buscarUsuario(usuarios[i,1], usuario, usuarios)
			FinSi
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
Funcion cargarUsuarios(usuarios Por Referencia)
	usuarios[1,1] <- "1"
	usuarios[1,2] <- "Juan"     
	usuarios[1,3] <- "Perez"
	usuarios[1,4] <- "12345678"
	usuarios[1,5] <- "juan.perez@email.com"
	usuarios[1,6] <- "12345"
	usuarios[1,7] <- "2024-05-01 08:47"
	usuarios[1,8] <- "Administrador"
	usuarios[1,9] <- "1"
	
	usuarios[2,1] <- "2"
	usuarios[2,2] <- "Maria"
	usuarios[2,3] <- "Lopez"
	usuarios[2,4] <- "23456789"
	usuarios[2,5] <- "maria.lopez@email.com"
	usuarios[2,6] <- "abcde"
	usuarios[2,7] <- "2024-06-12 14:22"
	usuarios[2,8] <- "Cliente"
	usuarios[2,9] <- "1"
	
	usuarios[3,1] <- "3"
	usuarios[3,2] <- "Carlos"
	usuarios[3,3] <- "Ruiz"
	usuarios[3,4] <- "34567890"
	usuarios[3,5] <- "carlos.ruiz@email.com"
	usuarios[3,6] <- "qwerty"
	usuarios[3,7] <- "2024-07-03 19:05"
	usuarios[3,8] <- "Cliente"
	usuarios[3,9] <- "1"
	
	usuarios[4,1] <- "4"
	usuarios[4,2] <- "Ana"
	usuarios[4,3] <- "Torres"
	usuarios[4,4] <- "45678901"
	usuarios[4,5] <- "ana.torres@email.com"
	usuarios[4,6] <- "zxcvb"
	usuarios[4,7] <- "2024-06-25 11:38"
	usuarios[4,8] <- "Cliente"
	usuarios[4,9] <- "1"
	
	usuarios[5,1] <- "5"
	usuarios[5,2] <- "Luis"
	usuarios[5,3] <- "Gómez"
	usuarios[5,4] <- "56789012"
	usuarios[5,5] <- "luis.gomez@email.com"
	usuarios[5,6] <- "luis123"
	usuarios[5,7] <- "2024-07-10 16:12"
	usuarios[5,8] <- "Administrador"
	usuarios[5,9] <- "1"

FinFuncion

