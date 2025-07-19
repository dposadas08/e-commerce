Algoritmo ModuloPago
    Definir idUsuario Como Cadena
	
    Definir usuarios, pagos, pedidos, detallesPedido, productos Como Cadena
	Dimension usuarios[10,9]
    Dimension pagos[10,7]
    Dimension pedidos[10,7]
    Dimension detallesPedido[10,6]
	Dimension productos[10,8]

    Definir usuario, pago, pedido, detallePedido, producto Como Cadena
    Dimension usuario[9]
    Dimension pago[7]
	Dimension pedido[7]
    Dimension detallePedido[6]
	Dimension producto[8]
	
	// -- CARGAR USUARIOS --
	cargarUsuarios(usuarios)
	
	// -- CARGAR PAGOS --
	cargarPagos(pagos)
	
	// -- CARGAR PEDIDOS --
	cargarPedidos(pedidos)
	
	// -- CARGAR DETALLES DE PEDIDO --
	cargarDetallesPedido(detallesPedido)
	
	// -- CARGAR PRODUCTOS --
	cargarProductos(productos)
	
	// -- LISTAR RESUMEN DE PAGO --
	
	//- Lógica:
	//	Se requiere obtener el resumen de pago del cliente po id
	
	//- Algoritmo:
	//	1. Leer id de usuario
	//	2. Validar si existe el usuario
	//	3. Buscar el resumen de pago por id de usuario en la función
	//	4. Buscar el usuario existente
	//	5. Validar estado del usuario y existencia del usuario
	//  6. Listar nombre, dni, correo
	//	7. Buscar el pedido existente
	//	8. Validar estado del pedido y existencia del pedido por id del pedido
	//	9. Listar estado, total, fecha de pedido
	//	10. Buscar el producto existente
	//	11. Validar estado del producto y existencia del producto por id del producto
	//	12. Listar nombre, cantidad, precio
	//	13. Buscar el pago existente
	//	14. Validar estado del pago y existencia del pago por id del pago
	//	15. Listar metodo de pago, estado de pago, fecha de pago, monto
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Buscar pagos"
	Escribir "-------------------------------------"
	listarUsuarios(usuarios)
	Escribir "Ingrese id del usuario: "
	leer idUsuario
	fila = buscarUsuario(idUsuario, usuario, usuarios)
	Mientras No (fila > 0) Hacer 
		Escribir "El usuario no existe. Ingrese id del usuario: "
		leer idUsuario
		fila = buscarUsuario(idUsuario, usuario, usuarios)
	FinMientras
	Escribir "-------------------------------------"
	Escribir "Resumen de Pago del Cliente" 
	Escribir "-------------------------------------"
	listarResumenPagoPorIdUsuario(idUsuario, usuarios, pedidos, detallesPedido,pagos, productos)
	
FinAlgoritmo

// Funciones Modulares
Funcion listarResumenPagoPorIdUsuario(idUsuario, usuarios Por Referencia, pedidos Por Referencia, detallesPedido Por Referencia, pagos Por Referencia, productos Por Referencia) 
		Para i <- 1 Hasta 10 Con Paso 1
			Si usuarios[i,1] = idUsuario Y usuarios[i,9] = "1" Entonces
				Escribir "Nombre: ", usuarios[i,2], " ", usuarios[i,3]
				Escribir "Dni: ", usuarios[i,4]
				Escribir "Correo: ", usuarios[i,5]
				Escribir "-------------------------------------"
				Para j <- 1 Hasta 10 Con Paso 1
					Si pedidos[j,2] = usuarios[i,1] Y pedidos[j,7] = "1" Entonces
						Escribir "Estado: ", pedidos[j,4]
						Escribir "Total: S/ ", pedidos[j,5]
						Escribir "Fecha: ", pedidos[j,6]
						Escribir "-------------------------------------"
						Para k <- 1 Hasta 10 Con Paso 1
							Si detallesPedido[k,2] = pedidos[j,1] Y detallesPedido[k,6] = "1" Entonces
								Para m <- 1 Hasta 10 Con Paso 1 
									Si productos[m,1] = detallesPedido[k,2] Entonces
										nombreProducto <- productos[m,2]
									FinSi
								Fin Para
								Escribir "Producto: ", nombreProducto
								Escribir "-------------------------------------"
								Escribir "Cantidad: ", detallesPedido[k,4]
								Escribir "Precio unitario: S/ ", detallesPedido[k,5]
								Escribir "-------------------------------------"
							FinSi
						Fin Para
						Para p <- 1 Hasta 10 Con Paso 1
							Si pagos[p,2] = pedidos[j,1] Y pagos[p,7] = "1" Entonces
								Escribir "Método: ", pagos[p,3]
								Escribir "Estado de pago: ", pagos[p,4]
								Escribir "Fecha de pago: ", pagos[p,5]
								Escribir "Monto: S/ ", pagos[p,6]
							FinSi
						Fin Para
						Escribir "-------------------------------------"
					FinSi
				Fin Para
			FinSi
		Fin Para
FinFuncion

// Funciones Extra Modulares
// Usuario
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

Funcion listarUsuarios(usuarios Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si usuarios[i,9] = "1" Entonces
			Escribir "Id: ", usuarios[i,1]
			Escribir "Nombre: ", usuarios[i,2]
			Escribir "Apellido: ", usuarios[i,3]
			Escribir "Dni: ", usuarios[i,4]
			Escribir "Correo: ", usuarios[i,5]
//			Escribir "Contraseña: ", usuarios[i,6]
//			Escribir "Fecha de registro: ", usuarios[i,7]
//			Escribir "Tipo de usuario: ", usuarios[i,8]
//			Escribir "Estado: ", usuarios[i,9]
			Escribir "-------------------------------------"
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

Funcion cargarPedidos(pedidos Por Referencia)
	pedidos[1,1] <- "1"
	pedidos[1,2] <- "1"
	pedidos[1,3] <- "1"
	pedidos[1,4] <- "pendiente"
	pedidos[1,5] <- "150.00"
	pedidos[1,6] <- "2025-07-12 10:30"
	pedidos[1,7] <- "1"
	
	pedidos[2,1] <- "2"
	pedidos[2,2] <- "2"
	pedidos[2,3] <- "3"
	pedidos[2,4] <- "pagado"
	pedidos[2,5] <- "85.50"
	pedidos[2,6] <- "2025-07-13 14:15"
	pedidos[2,7] <- "1"
	
	pedidos[3,1] <- "3"
	pedidos[3,2] <- "3"
	pedidos[3,3] <- "2"
	pedidos[3,4] <- "enviado"
	pedidos[3,5] <- "230.75"
	pedidos[3,6] <- "2025-07-15 16:45"
	pedidos[3,7] <- "1"
	
	pedidos[4,1] <- "4"
	pedidos[4,2] <- "4"
	pedidos[4,3] <- "5"
	pedidos[4,4] <- "entregado"
	pedidos[4,5] <- "99.99"
	pedidos[4,6] <- "2025-07-11 09:20"
	pedidos[4,7] <- "1"
	
	pedidos[5,1] <- "5"
	pedidos[5,2] <- "5"
	pedidos[5,3] <- "4"
	pedidos[5,4] <- "cancelado"
	pedidos[5,5] <- "45.00"
	pedidos[5,6] <- "2025-07-14 18:05"
	pedidos[5,7] <- "1"
FinFuncion

Funcion cargarDetallesPedido(detallesPedido Por Referencia)
	detallesPedido[1,1] <- "1"
	detallesPedido[1,2] <- "1"
	detallesPedido[1,3] <- "101"
	detallesPedido[1,4] <- "2"
	detallesPedido[1,5] <- "50.00"
	detallesPedido[1,6] <- "1"
	
	detallesPedido[2,1] <- "2"
	detallesPedido[2,2] <- "1"
	detallesPedido[2,3] <- "102"
	detallesPedido[2,4] <- "1"
	detallesPedido[2,5] <- "50.00"
	detallesPedido[2,6] <- "1"
	
	detallesPedido[3,1] <- "3"
	detallesPedido[3,2] <- "2"
	detallesPedido[3,3] <- "103"
	detallesPedido[3,4] <- "3"
	detallesPedido[3,5] <- "28.50"
	detallesPedido[3,6] <- "1"
	
	detallesPedido[4,1] <- "4"
	detallesPedido[4,2] <- "3"
	detallesPedido[4,3] <- "104"
	detallesPedido[4,4] <- "5"
	detallesPedido[4,5] <- "46.15"
	detallesPedido[4,6] <- "1"
	
	detallesPedido[5,1] <- "5"
	detallesPedido[5,2] <- "4"
	detallesPedido[5,3] <- "105"
	detallesPedido[5,4] <- "1"
	detallesPedido[5,5] <- "99.99"
	detallesPedido[5,6] <- "1"
	
	detallesPedido[6,1] <- "6"
	detallesPedido[6,2] <- "5"
	detallesPedido[6,3] <- "106"
	detallesPedido[6,4] <- "3"
	detallesPedido[6,5] <- "15.00"
	detallesPedido[6,6] <- "1"
FinFuncion

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
