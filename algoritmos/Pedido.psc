Algoritmo ModuloPedido
    Definir idPedido, idDetalle,stock, totStock, i, fila, filas Como Entero
    Definir continuar, tipoPago Como Caracter
    Definir existe Como Logico
	
	Definir usuarios, direcciones, productos, pedidos, detallesPedido, pagos Como Cadena
	Dimension usuarios[10,9]
	Dimension direcciones[10,8]
	Dimension productos[10,8]
	Dimension pedidos[10,7]
	Dimension detallesPedido[30,6]
	Dimension pagos[10,7]
	
	Definir usuario, producto, pedido, detallePedido, pago Como Cadena
	Dimension usuario[9]
	Dimension producto[8]
	Dimension pedido[7]
	Dimension detallePedido[6]
	Dimension pago[7]

	idPedido = 1
	idDetalle = 1
	
	// -- CARGAR PRODUCTOS --
	cargarUsuarios(usuarios)
	
	// -- CARGAR USUARIOS --
	cargarProductos(productos)
	
	// -- CARGAR DIRECCIONES --
	cargarDirecciones(direcciones)
	
	// -- CREAR PEDIDO --
	
	//- Lógica:
	//	1. Solicitar y leer el id del usuario
	//	2. Buscar el usuario por el id ingresado
	//	3. Mientras el usuario no exista o no tenga direcciones:
	//		3. Solicitar id del usuario nuevamente y buscar usuario y contar direcciones
	//	4. Listar las direcciones del usuario
	//	5. Solicitar y leer el id de la dirección
	//	6. Validar que la dirección exista para el usuario; si no, solicitar id nuevamente hasta que sea válido
	//	7. Crear un nuevo pedido con el id del pedido, id del usuario y id de la dirección
	//	8. Repetir hasta que el usuario deje de agregar productos:
	//		8. Listar productos disponibles
	//		9. Solicitar y leer id del producto
	//		10. Verificar si el producto ya está en el pedido:
	//			- Si está, preguntar si desea actualizar cantidad, eliminar o saltar
	//			- Si no está, validar que el producto exista y tenga stock, solicitar cantidad y agregar al pedido
	//		11. Mostrar subtotales y total actual del pedido
	//		12. Preguntar si desea seguir agregando productos
	//		13. Incrementar idDetalle para el próximo producto
	//	14. Actualizar total del pedido
	//	15. Confirmar el pedido
	//	16. Crear un registro de pago asociado al pedido
	//	17. Mostrar confirmación del pago con datos del pedido y estado
	//	18. Mostrar resumen de subtotales y total
	//	19. Solicitar método de pago (tarjeta crédito, PayPal, transferencia)
	//	20. Validar opción ingresada
	//	21. Actualizar método de pago en el sistema
	//	22. Mostrar resumen del método de pago y monto a pagar
	//	23. Solicitar confirmación del pago
	//	24. Validar opción ingresada
	//	25. Actualizar estados de pago y pedido a 'completado' y 'pagado'
	//	26. Mostrar confirmación de pago
	//	27. Mostrar resumen final del pedido con usuario, estado, y totales
	//	28. Actualizar estado del pedido a 'enviado' y luego a 'entregado'
	//	29. Preguntar si desea realizar otro pedido
	//	30. Validar opción ingresada
	//	31. Si desea, incrementar idPedido y repetir desde el paso 1
	//	32. Si no desea, termina
	
	//- Pseudocódigo en PSeint:
	Escribir "-------------------------------------"
	Escribir "Crear Pedido"
	Escribir "-------------------------------------"
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
	Escribir "Elija id de dirección: "
	leer idDireccion
	existe = existeDireccion(idUsuario, idDireccion, direcciones)
	Mientras No existe Hacer	
		Escribir "Id inválida. Elija id de dirección:"
		leer idDireccion
		existe = existeDireccion(idUsuario, idDireccion, direcciones)
	FinMientras
	Escribir "-------------------------------------"
	Repetir
		crearPedido(ConvertirATexto(idPedido), idUsuario, idDireccion, "", pedidos)
		Repetir
			listarProductos(productos)
			Escribir "Ingrese id del producto: "
			leer idProducto
			fila = buscarDetallePedidoPorIdProducto(ConvertirATexto(idPedido), idProducto, detallePedido, detallesPedido)
			Si fila > 0 Entonces 
				Escribir "El producto ya fue agregado. ¿Desea actualizar, eliminar o saltar? a/e/s:"
				leer continuar
				Mientras No (Minusculas(continuar) = "a" o Minusculas(continuar) = "e" o Minusculas(continuar) = "s") Hacer	
					Escribir "Opción inválida. ¿Desea actualizar, eliminar o saltar? a/e/s:"
					leer continuar
				FinMientras
				Si Minusculas(continuar) = "a" Entonces
					Escribir "Ingrese nueva cantidad del producto: "
					leer cantidad
					stock = obtenerStock(idProducto, productos)
					totStock  = ConvertirANumero(detallePedido[4]) + stock
					Mientras No (totStock >= cantidad) Hacer 
						Escribir "La cantidad excede el stock (Obtenidas: ",ConvertirANumero(detallePedido[4]),", Disponibles: ", stock,", Total: ",totStock,")."
						Escribir "Ingrese nueva cantidad del producto: "
						leer cantidad
					FinMientras
					actualizarCantidadDetalle(ConvertirATexto(idPedido), idProducto, ConvertirATexto(cantidad), detallesPedido)
					actualizarStock(idProducto, ConvertirATexto(totStock - cantidad), productos)
				FinSi
				Si Minusculas(continuar) = "e" Entonces
					stock = obtenerStock(idProducto, productos)
					cantidad = eliminarDetallePedido(ConvertirATexto(idPedido), idProducto, detallesPedido)
					actualizarStock(idProducto, ConvertirATexto(stock + cantidad), productos)
				FinSi
			SiNo
				fila = buscarProducto(idProducto, producto, productos)
				stock = obtenerStock(idProducto, productos)
				Mientras No (fila > 0 y stock > 0) Hacer 
					fila = buscarProducto(idProducto, producto, productos)
					Si fila = 0 Entonces
						Escribir "El producto no existe. Ingrese id del producto: "
						leer idProducto
						fila = buscarProducto(idProducto, producto, productos)
					FinSi
					stock = obtenerStock(idProducto, productos)
					Si fila > 0 y stock = 0 Entonces
						Escribir "El producto no tiene stock. Ingrese id del producto: "
						leer idProducto
						stock = obtenerStock(idProducto, productos)
					FinSi
				FinMientras
				Escribir "Ingrese cantidad del producto: "
				leer cantidad
				stock = obtenerStock(idProducto, productos)
				Mientras No (stock >= cantidad) Hacer 
					Escribir "La cantidad excede el stock (",stock,"). Ingrese cantidad del producto: "
					leer cantidad
				FinMientras
				agregarDetallePedido(ConvertirATexto(idDetalle), ConvertirATexto(idPedido), idProducto, ConvertirATexto(cantidad), producto[4], detallesPedido)	
				actualizarStock(idProducto, ConvertirATexto(stock - cantidad), productos)
			FinSi 
			Escribir "-------------------------------------"
			listarSubTotales(ConvertirATexto(idPedido), producto, productos, detallesPedido)
			total = obtenerTotal(ConvertirATexto(idPedido), detallesPedido)
			Escribir "-------------------------------------"
			Escribir "Total del pedido: S/. ", total	
			Escribir "-------------------------------------"
			Escribir "¿Desea seguir agregando productos? s/n:"
			leer continuar
			Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
				Escribir "Opción inválida. ¿Desea seguir agregando productos? s/n:"
				leer continuar
			FinMientras
			idDetalle = idDetalle + 1
		Hasta Que Minusculas(continuar) = 'n'
		total = obtenerTotal(ConvertirATexto(idPedido), detallesPedido)
		actualizarTotalPedido(ConvertirATexto(idPedido), total, pedidos)
		Escribir "*** Pedido confirmado ***"
		idPago = crearPago(ConvertirATexto(generarId(pagos,10)), ConvertirATexto(idPedido), "", ConvertirATexto(total), pagos)
		Escribir "-------------------------------------"
		Escribir "Confirmación del Pago"
		Escribir "-------------------------------------"
		fila = buscarPedido(ConvertirATexto(idPedido), pedido, pedidos)
		Si fila > 0 Entonces
			Escribir "Nombre: ", usuario[2]
			Escribir "DNI: ", usuario[4]
			Escribir "Fecha de pedido: ", pedido[6]
			Escribir "Estado del pedido: ", Mayusculas(pedido[4])
		FinSi 
		fila = buscarPago(ConvertirATexto(idPago), pago, pagos)
		Si fila > 0 Entonces 
			Escribir "Estado de pago: ", Mayusculas(pago[4])
		FinSi 
		Escribir "-------------------------------------"
		listarSubTotales(ConvertirATexto(idPedido), producto, productos, detallesPedido)
		total = obtenerTotal(ConvertirATexto(idPedido), detallesPedido)
		Escribir "-------------------------------------"
		Escribir "Total del pedido: S/. ", total	
		Escribir "-------------------------------------"
		Escribir "¿Que metodo de pago desea realizar?"
		Escribir "(c: Tarjeta crédito, p: PayPal, t: Transferencia) c/p/t:"
		Leer tipoPago
		Mientras No (Minusculas(tipoPago) = "c" o Minusculas(tipoPago) = "p" o Minusculas(tipoPago) = "t") Hacer	
			Escribir "Opción inválida. ¿Que metodo de pago desea realizar?"
			Escribir "(c: Tarjeta crédito, p: PayPal, t: Transferencia) c/p/t:"
			leer tipoPago
		FinMientras
		Segun tipoPago Hacer
			"c":
				tipoPago = "Tarjeta crédito"
				metodoPago = "tarjeta_credito"
			"p":
				tipoPago = "PayPal"
				metodoPago = "paypal"
			"t":
				tipoPago = "Transferencia"
				metodoPago = "transferencia"
		FinSegun
		actualizarMetodoPago(ConvertirATexto(idPago), metodoPago, pagos)
		Escribir "-------------------------------------"
		Escribir "Metodo de pago: ", tipoPago
		Escribir "Monto a pagar: S/. ", total
		Escribir "-------------------------------------"
		Escribir "¿Desea confirmar el pago? s/n:"
		leer continuar
		Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
			Escribir "Opción inválida. ¿Desea confirmar el pago? s/n:"
			leer continuar
		FinMientras 
		actualizarEstadoPago(ConvertirATexto(idPago), 'completado', pagos)
		actualizarEstadoPedido(ConvertirATexto(idPedido), 'pagado', pedidos)
		Escribir "*** Pago confirmado ***"
		Escribir "-------------------------------------"
		Escribir "Resumen del Pedido"
		Escribir "-------------------------------------"
		fila = buscarPedido(ConvertirATexto(idPedido), pedido, pedidos)
		Si fila > 0 Entonces
			Escribir "Nombre: ", usuario[2]
			Escribir "DNI: ", usuario[4]
			Escribir "Fecha de pedido: ", pedido[6]
			Escribir "Estado del pedido: ", Mayusculas(pedido[4])
		FinSi 
		fila = buscarPago(ConvertirATexto(idPago), pago, pagos)
		Si fila > 0 Entonces 
			Escribir "Estado de pago: ", Mayusculas(pago[4])
		FinSi 
		Escribir "-------------------------------------"
		listarSubTotales(ConvertirATexto(idPedido), producto, productos, detallesPedido)
		Escribir "-------------------------------------"
		Escribir "Total: S/. ", total
		Escribir "-------------------------------------"
		Escribir "Metodo de pago: ", tipoPago
		Escribir "Monto a pagar: S/. ", total
		Escribir "-------------------------------------"
		Escribir "*** Pedido enviado ***"
		actualizarEstadoPedido(ConvertirATexto(idPedido), 'enviado', pedidos)
		Escribir "*** Pedido entregado ***"
		actualizarEstadoPedido(ConvertirATexto(idPedido), 'entregado', pedidos)
		Escribir "¿Desea realizar otro pedido? s/n:"
		leer continuar
		Mientras No (Minusculas(continuar) = "s" o Minusculas(continuar) = "n") Hacer	
			Escribir "Opción inválida. ¿Desea realizar otro pedido? s/n:"
			leer continuar
		FinMientras 
		idPedido = idPedido + 1
	Hasta Que Minusculas(continuar) = 'n'
FinAlgoritmo

// Funciones Modulares
Funcion crearPedido(idPedido, idUsuario, idDireccion, total, pedidos Por Referencia)
	pedidos[ConvertirANumero(idPedido),1] <- idPedido
	pedidos[ConvertirANumero(idPedido),2] <- idUsuario
	pedidos[ConvertirANumero(idPedido),3] <- idDireccion
	pedidos[ConvertirANumero(idPedido),4] <- "pendiente"
	pedidos[ConvertirANumero(idPedido),5] <- total
	pedidos[ConvertirANumero(idPedido),6] <- formatearFechaHoraISO(FechaActual(), HoraActual())
	pedidos[ConvertirANumero(idPedido),7] <- "1"
FinFuncion

Funcion actualizarTotalPedido(idPedido, total, pedidos Por Referencia)
	pedidos[ConvertirANumero(idPedido),5] <- ConvertirATexto(total) 
FinFuncion

Funcion actualizarEstadoPedido(idPedido, estadoPedido, pedidos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si pedidos[i,1] = idPedido Entonces 
			pedidos[i,4] <- estadoPedido
		FinSi
	Fin Para
FinFuncion

Funcion fila <- buscarPedido(idPedido, pedido Por Referencia, pedidos Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si pedidos[i,1] = idPedido Entonces 
			pedido[1] <- pedidos[i,1]
			pedido[2] <- pedidos[i,2]
			pedido[3] <- pedidos[i,3]
			pedido[4] <- pedidos[i,4]
			pedido[5] <- pedidos[i,5]
			pedido[6] <- pedidos[i,6]
			pedido[7] <- pedidos[i,7]
			fila = fila + 1
		FinSi
	FinPara 
FinFuncion

Funcion agregarDetallePedido(idDetalle, idPedido, idProducto, cantidad, precio, detallesPedido Por Referencia)
	detallesPedido[ConvertirANumero(idDetalle),1] <- idDetalle
	detallesPedido[ConvertirANumero(idDetalle),2] <- idPedido
	detallesPedido[ConvertirANumero(idDetalle),3] <- idProducto
	detallesPedido[ConvertirANumero(idDetalle),4] <- cantidad
	detallesPedido[ConvertirANumero(idDetalle),5] <- precio
	detallesPedido[ConvertirANumero(idDetalle),6] <- "1"
FinFuncion

Funcion actualizarCantidadDetalle(idPedido, idProducto, cantidad, detallesPedido Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 30 Con Paso 1
		Si No detallesPedido[i,2] = "" Entonces
			Si detallesPedido[i,6] = "1" Entonces
				Si detallesPedido[i,2] = idPedido Entonces 
					Si detallesPedido[i,3] = idProducto Entonces 
						detallesPedido[i,4] <- cantidad
					FinSi
				FinSi
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion fila <- buscarDetallePedidoPorIdProducto(idPedido, idProducto, detallePedido Por Referencia, detallesPedido Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 30 Con Paso 1
		Si No detallesPedido[i,2] = "" Entonces
			Si detallesPedido[i,6] = "1" Entonces
				Si detallesPedido[i,2] = idPedido Entonces 
					Si detallesPedido[i,3] = idProducto Entonces 
						detallePedido[1] <- detallesPedido[i,1]
						detallePedido[2] <- detallesPedido[i,2]
						detallePedido[3] <- detallesPedido[i,3]
						detallePedido[4] <- detallesPedido[i,4]
						detallePedido[5] <- detallesPedido[i,5]
						detallePedido[6] <- detallesPedido[i,6]
						fila = fila + 1
					FinSi
				FinSi
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion cantidad <- eliminarDetallePedido(idPedido, idProducto, detallesPedido Por Referencia)
	Definir cantidad, i Como Entero
	Para i <- 1 Hasta 30 Con Paso 1
		Si No detallesPedido[i,2] = "" Entonces
			Si detallesPedido[i,2] = idPedido Entonces 
				Si detallesPedido[i,3] = idProducto Entonces 
					detallesPedido[i,6] <- "0"
					cantidad <- ConvertirANumero(detallesPedido[i,4])
				FinSi
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion total <- obtenerTotal(idPedido, detallesPedido Por Referencia)
	Definir total Como Real
	Definir i Como Entero
	total = 0
	Para i <- 1 Hasta 30 Con Paso 1
		Si No detallesPedido[i,2] = "" Entonces
			Si detallesPedido[i,6] = "1" Entonces
				Si detallesPedido[i,2] = idPedido Entonces 
					total <- total + (ConvertirANumero(detallesPedido[i,4]) * ConvertirANumero(detallesPedido[i,5]))	
				FinSi
			FinSi
		FinSi
	Fin Para
FinFuncion

Funcion listarSubTotales(idPedido, producto Por Referencia, productos Por Referencia, detallesPedido Por Referencia)
	Definir contador, fila Como Entero
	contador = 1
	Para i <- 1 Hasta 30 Con Paso 1
		Si No detallesPedido[i,2] = "" Entonces
			Si detallesPedido[i,6] = "1" Entonces
				Si detallesPedido[i,2] = idPedido Entonces 
					fila <- buscarProducto(detallesPedido[i,3], producto, productos)
					Si fila > 0 Entonces
						Escribir contador,". (x",detallesPedido[i,4], ") ", producto[2]," (S/. ", detallesPedido[i,5] ,"): S/. " , ConvertirANumero(detallesPedido[i,4]) * ConvertirANumero(detallesPedido[i,5])
						contador = contador + 1
					FinSi 
				FinSi
			FinSi
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

// Dirección
Funcion listarDirecciones(direcciones Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Escribir "Id: ", direcciones[i,1]
			Escribir "Id Usuario: ", direcciones[i,2]
			Escribir "Direccion: ", direcciones[i,3]
			Escribir "Ciudad: ", direcciones[i,4]
			Escribir "Provincia: ", direcciones[i,5]
			Escribir "Codigo Postal: ", direcciones[i,6]
			Escribir "Pais: ", direcciones[i,7]
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
	Definir fila, i Como Entero
	filas = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si direcciones[i,8] = "1" Entonces
			Si direcciones[i,2] = idUsuario Entonces 
				filas = filas + 1
			FinSi
		FinSi
	Fin Para
FinFuncion

// Producto
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
//			Escribir "Fecha de Creación: ", productos[i,7]
//			Escribir "Estado: ", productos[i,8] 
			Escribir "-------------------------------------"
		FinSi
	Fin Para
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

Funcion stock <- obtenerStock(idProducto, productos Por Referencia)
	Definir stock, i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,1] = idProducto Entonces 
			stock <- ConvertirANumero(productos[i,5])
		FinSi
	Fin Para
FinFuncion

Funcion actualizarStock(idProducto, stock, productos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si productos[i,1] = idProducto Entonces 
			productos[i,5] <- stock
		FinSi
	Fin Para
FinFuncion

// Pago 
Funcion id <- crearPago(idPago, idPedido, metodoPago, monto, pagos Por Referencia)
	Definir id Como Entero
	pagos[ConvertirANumero(idPago),1] <- idPago
	pagos[ConvertirANumero(idPago),2] <- idPedido
	pagos[ConvertirANumero(idPago),3] <- metodoPago
	pagos[ConvertirANumero(idPago),4] <- "pendiente"
	pagos[ConvertirANumero(idPago),5] <- monto
	pagos[ConvertirANumero(idPago),6] <- formatearFechaHoraISO(FechaActual(), HoraActual())
	pagos[ConvertirANumero(idPago),7] <- "1"
	id <- ConvertirANumero(idPago)
FinFuncion

Funcion fila <- buscarPago(idPago, pago Por Referencia, pagos Por Referencia)
	Definir fila, i Como Entero
	fila = 0
	Para i <- 1 Hasta 10 Con Paso 1
		Si pagos[i,1] = idPago Entonces 
			pago[1] <- pagos[i,1]
			pago[2] <- pagos[i,2]
			pago[3] <- pagos[i,3]
			pago[4] <- pagos[i,4]
			pago[5] <- pagos[i,5]
			pago[6] <- pagos[i,6]
			pago[7] <- pagos[i,7]
			fila = fila + 1
		FinSi
	FinPara 
FinFuncion

Funcion actualizarMetodoPago(idPago, metodoPago, pagos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si pagos[i,1] = idPago Entonces 
			pagos[i,3] <- metodoPago
		FinSi
	Fin Para
FinFuncion

Funcion actualizarEstadoPago(idPago, estadoPago, pagos Por Referencia)
	Definir i Como Entero
	Para i <- 1 Hasta 10 Con Paso 1
		Si pagos[i,1] = idPago Entonces 
			pagos[i,4] <- estadoPago
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
	// Usuario 1
	usuarios[1,1] <- "1"
	usuarios[1,2] <- "Juan"     
	usuarios[1,3] <- "Perez"
	usuarios[1,4] <- "12345678"
	usuarios[1,5] <- "juan.perez@email.com"
	usuarios[1,6] <- "12345"
	usuarios[1,7] <- "2024-05-01"
	usuarios[1,8] <- "Administrador"
	usuarios[1,9] <- "1"
	
	// Usuario 2
	usuarios[2,1] <- "2"
	usuarios[2,2] <- "Maria"
	usuarios[2,3] <- "Lopez"
	usuarios[2,4] <- "23456789"
	usuarios[2,5] <- "maria.lopez@email.com"
	usuarios[2,6] <- "abcde"
	usuarios[2,7] <- "2024-06-12"
	usuarios[2,8] <- "Cliente"
	usuarios[2,9] <- "1"
	
	// Usuario 3
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
	
	// Usuario 5
	usuarios[5,1] <- "5"
	usuarios[5,2] <- "Luis"
	usuarios[5,3] <- "Gómez"
	usuarios[5,4] <- "56789012"
	usuarios[5,5] <- "luis.gomez@email.com"
	usuarios[5,6] <- "luis123"
	usuarios[5,7] <- "2024-07-10"
	usuarios[5,8] <- "Administrador"
	usuarios[5,9] <- "1"
FinFuncion

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

Funcion cargarDirecciones(direcciones Por Referencia)
	// Usuario 1
	direcciones[1,1] <- "1"
	direcciones[1,2] <- "1"
	direcciones[1,3] <- "Av. Siempre Viva 123"
	direcciones[1,4] <- "Springfield"
	direcciones[1,5] <- "Illinois"
	direcciones[1,6] <- "12345"
	direcciones[1,7] <- "Estados Unidos"
	direcciones[1,8] <- "1"
	
	direcciones[2,1] <- "2"
	direcciones[2,2] <- "1"
	direcciones[2,3] <- "Calle Norte 456"
	direcciones[2,4] <- "Chicago"
	direcciones[2,5] <- "Illinois"
	direcciones[2,6] <- "60601"
	direcciones[2,7] <- "Estados Unidos"
	direcciones[2,8] <- "1"
	
	// Usuario 2
	direcciones[3,1] <- "3"
	direcciones[3,2] <- "2"
	direcciones[3,3] <- "Calle Falsa 456"
	direcciones[3,4] <- "Bogotá"
	direcciones[3,5] <- "Cundinamarca"
	direcciones[3,6] <- "110111"
	direcciones[3,7] <- "Colombia"
	direcciones[3,8] <- "1"
	
	direcciones[4,1] <- "4"
	direcciones[4,2] <- "2"
	direcciones[4,3] <- "Carrera 9 #15-30"
	direcciones[4,4] <- "Medellín"
	direcciones[4,5] <- "Antioquia"
	direcciones[4,6] <- "050021"
	direcciones[4,7] <- "Colombia"
	direcciones[4,8] <- "1"
	
	// Usuario 3
	direcciones[5,1] <- "5"
	direcciones[5,2] <- "3"
	direcciones[5,3] <- "Av. Central 789"
	direcciones[5,4] <- "Lima"
	direcciones[5,5] <- "Lima"
	direcciones[5,6] <- "15001"
	direcciones[5,7] <- "Perú"
	direcciones[5,8] <- "1"
	
	direcciones[6,1] <- "6"
	direcciones[6,2] <- "3"
	direcciones[6,3] <- "Jr. de la Unión 112"
	direcciones[6,4] <- "Arequipa"
	direcciones[6,5] <- "Arequipa"
	direcciones[6,6] <- "04001"
	direcciones[6,7] <- "Perú"
	direcciones[6,8] <- "1"
	
	// Usuario 4
	direcciones[7,1] <- "7"
	direcciones[7,2] <- "4"
	direcciones[7,3] <- "Calle Sur 321"
	direcciones[7,4] <- "Buenos Aires"
	direcciones[7,5] <- "Buenos Aires"
	direcciones[7,6] <- "C1000"
	direcciones[7,7] <- "Argentina"
	direcciones[7,8] <- "1"
	
	direcciones[8,1] <- "8"
	direcciones[8,2] <- "4"
	direcciones[8,3] <- "Av. Corrientes 1500"
	direcciones[8,4] <- "La Plata"
	direcciones[8,5] <- "Buenos Aires"
	direcciones[8,6] <- "1900"
	direcciones[8,7] <- "Argentina"
	direcciones[8,8] <- "1"
	
	// Usuario 5
	direcciones[9,1] <- "9"
	direcciones[9,2] <- "5"
	direcciones[9,3] <- "Rua da Alegria 654"
	direcciones[9,4] <- "São Paulo"
	direcciones[9,5] <- "São Paulo"
	direcciones[9,6] <- "01000-000"
	direcciones[9,7] <- "Brasil"
	direcciones[9,8] <- "1"
	
	direcciones[10,1] <- "10"
	direcciones[10,2] <- "5"
	direcciones[10,3] <- "Av. Paulista 1000"
	direcciones[10,4] <- "Rio de Janeiro"
	direcciones[10,5] <- "Rio de Janeiro"
	direcciones[10,6] <- "20000-000"
	direcciones[10,7] <- "Brasil"
	direcciones[10,8] <- "1"
FinFuncion
	
	

