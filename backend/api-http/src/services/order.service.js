import { OrderModel } from "../models/order.model.js";
import { DetailModel } from "../models/detail.model.js";
import { UserModel } from "../models/user.model.js";
import { AddressModel } from '../models/address.model.js';
import { CouponModel } from "../models/coupon.model.js";
import { ProductModel } from "../models/product.model.js";
import { SubcategoryModel } from '../models/subcategory.model.js';
import { CategoryModel } from '../models/category.model.js';
import { PaymentModel } from "../models/payment.model.js";
import { jsonJoin, generateNumber, roundDecimal } from '../utils/persistence.js';
import { OrderStates, PaymentStates } from '../constants/enums.js';
import { UserError } from '../errors/user.error.js';
import { DateTime } from "luxon";
import validator from "validator";

const getAll = async () => {
  const orders = await OrderModel.list();
  return await jsonJoin(orders, joins);
};

const getProductDetailsById = async (id) => {
  
  const order = await OrderModel.findById(id);

  if (!order) {
    throw new UserError(`No existe ningún pedido asociado al ID '${id}'`, 404);
  }

  return await DetailModel.listProductDetailsByIdOrder(id); 
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del pedido no fue ingresado`, 400);
  }

  const order = await OrderModel.findById(id);

  if (!order) {
    throw new UserError(`No existe ningún pedido asociado al ID '${id}'`, 404);
  }

  return await jsonJoin(order, joins);
};

const create = async (data) => {
  const { detallesPedido, idUsuario, idDireccion, codigoCupon } = data;

  if (!detallesPedido || !idUsuario || !idDireccion) {
    throw new UserError(`Los parámetros detallesPedido, direccion, idUsuario e idDireccion son obligatorios`, 400);
  }

  if (!Array.isArray(detallesPedido)) {
    throw new UserError(`El formato del pedido es inválido. Se esperaba una lista de productos`, 400);
  }

  if (detallesPedido.length === 0) {
    throw new UserError(`El pedido debe contener al menos un producto`, 400);
  }

  const validatedObjects = detallesPedido.every(detalle =>
    typeof detalle === 'object' &&
    'idProducto' in detalle &&
    'cantidad' in detalle
  );

  if (!validatedObjects) {
    throw new UserError(`Todos los detalles deben tener un idProducto y una cantidad válidos`, 400);   
  }
  
  for (const detalle of detallesPedido) {
    const product = await ProductModel.findById(detalle.idProducto);
    if (!validator.isInt(detalle.cantidad.toString(), { min: 1 })) {
      throw new UserError(`El valor de 'cantidad' debe ser un número entero mayor o igual a 1`, 400);
    }
    if (!product) {
      throw new UserError(`No existe ningún producto asociado al ID '${detalle.idProducto}'`, 404);
    }
    if (product.stock === 0) {
      throw new UserError(`El producto '${product.nombre}' no se encuentra disponible por falta de stock`, 409);
    }
    if (product.stock < detalle.cantidad) {
      throw new UserError(`La cantidad solicitada excede el stock disponible para el producto '${product.nombre}' ` + 
        `(Stock: ${product.stock} | Solicitado: ${detalle.cantidad})`, 422);
    }
  }

  const user = await UserModel.findById(idUsuario);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${idUsuario}'`, 404);
  }

  const address = await AddressModel.findById(idDireccion);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${idDireccion}'`, 404);
  }

  let coupon = null;

  if (codigoCupon) {
    [coupon] = await CouponModel.findByField({ codigo: codigoCupon });
    if (coupon && coupon.activo) {
      const today = DateTime.now().setZone('America/Lima');
      const expiration = DateTime.fromISO(coupon.fecha_expiracion, { zone: 'America/Lima'});
      if (expiration < today) {
        coupon = await CouponModel.updateFieldById(coupon.cupon_id, { activo: false });
        if (!coupon.activo) {
          throw new UserError(`El cupón '${codigoCupon}' no es válido. Por favor, verifique e intente nuevamente`, 422);
        }
      }
    } else {
      throw new UserError(`El cupón '${codigoCupon}' no es válido. Por favor, verifique e intente nuevamente`, 422);
    }
  }
  
  const subtotales = await Promise.all(
    detallesPedido.map(async d => {
      const product = await ProductModel.findById(d.idProducto);
      return d.cantidad * product.precio;
    })
  );

  const total = subtotales.reduce((acc, sub) => acc + sub, 0);

  const numero = await OrderModel.lastOrderNumber();

  if (codigoCupon) {
    await CouponModel.updateFieldById(coupon.cupon_id, { activo: false });
  }

  const newOrder = {
    numeroDocumento: generateNumber(numero.ultimo),
    idUsuario: idUsuario,
    idDireccion: idDireccion,
    subtotal: roundDecimal(total),
    total: codigoCupon ? roundDecimal(total - roundDecimal(total * (coupon.porcentaje_descuento / 100))) : roundDecimal(total), 
    estadoPedido: OrderStates.PENDING,
    codigoCupon: codigoCupon || null,
    idCupon: codigoCupon ? coupon.cupon_id : null,
    descuentoAplicado: codigoCupon ? roundDecimal(total * (coupon.porcentaje_descuento / 100)) : 0
  };

  const order = await OrderModel.create(newOrder); 

  for (const detalle of detallesPedido) {
    const product = await ProductModel.findById(detalle.idProducto);
    const newDetail = {
      idPedido: order.pedido_id,
      idProducto: detalle.idProducto,
      cantidad: detalle.cantidad,
      precioUnitario: product.precio,
    };
    await DetailModel.create(newDetail);
    await ProductModel.updateFieldById(detalle.idProducto, { stock: product.stock - detalle.cantidad })
  }

  const newPayment = { 
    idPedido: order.pedido_id, 
    metodoPago: null,
    estadoPago: PaymentStates.PENDING, 
    fecha_pago: null,
    monto: 0
  }

  await PaymentModel.create(newPayment);

  return await jsonJoin(order, joins);

};

const putById = async (id, data) => {

  const { detallesPedido, idUsuario, idDireccion, codigoCupon } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID del pedido no fue ingresado`, 400);
  }

  if (!detallesPedido || !idUsuario || !idDireccion) {
    throw new UserError(`Los parámetros detallesPedido, direccion, idUsuario e idDireccion son obligatorios`, 400);
  }

  if (!Array.isArray(detallesPedido)) {
    throw new UserError(`El formato del pedido es inválido. Se esperaba una lista de productos`, 400);
  }

  if (detallesPedido.length === 0) {
    throw new UserError(`El pedido debe contener al menos un producto`, 400);
  }

  const validatedObjects = detallesPedido.every(detalle =>
    typeof detalle === 'object' &&
    'idProducto' in detalle &&
    'cantidad' in detalle
  );

  if (!validatedObjects) {
    throw new UserError(`Todos los detalles deben tener un idProducto y una cantidad válidos`, 400);   
  }
  
  let order = await OrderModel.findById(id);

  if (!order) {
    throw new UserError(`No existe ningún pedido asociado al ID '${id}'`, 404);
  }

  if (order.estado_pedido === OrderStates.CANCELLED) {
    throw new UserError(`El pedido asociado al ID '${id}' ha sido cancelado`, 409);
  }

  for (const detalle of detallesPedido) {
    if (!validator.isInt(detalle.cantidad.toString(), { min: 1 })) {
      throw new UserError(`El valor de 'cantidad' debe ser un número entero mayor o igual a 1`, 400);
    }
    
    const product = await ProductModel.findById(detalle.idProducto);
    
    if (!product) {
      throw new UserError(`No existe ningún producto asociado al ID '${detalle.idProducto}'`, 404);
    }

    const [detail] = await DetailModel.findByField({ pedido_id: id, producto_id: detalle.idProducto });
    if (detail) {
      const totStock = detail.cantidad + product.stock;
      if (totStock < detalle.cantidad) {
        throw new UserError(`La cantidad solicitada excede el stock disponible para el producto '${product.nombre}' ` +
          `(Obtenidas: ${detail.cantidad} | Stock: ${product.stock} => Total Disponible: ${totStock} | Solicitado: ${detalle.cantidad})`, 422);
      }
    } else {
      if (product.stock === 0) {
        throw new UserError(`El producto '${product.nombre}' no se encuentra disponible por falta de stock`, 409);
      } 
      if (product.stock < detalle.cantidad) {
        throw new UserError(`La cantidad solicitada excede el stock disponible para el producto '${product.nombre}' ` +
          `(Stock: ${product.stock} | Solicitado: ${detalle.cantidad})`, 422);
      }
    }
  }

  const user = await UserModel.findById(idUsuario);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${idUsuario}'`, 404);
  }

  const address = await AddressModel.findById(idDireccion);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${idDireccion}'`, 404);
  }

  let coupon = null;

  if (codigoCupon) {
    if (!order.cupon_id || order.codigo_cupon !== codigoCupon) {
      [coupon] = await CouponModel.findByField({ codigo: codigoCupon });
      if (coupon && coupon.activo) {
        const today = DateTime.now().setZone('America/Lima');
        const expiration = DateTime.fromISO(coupon.fecha_expiracion, { zone: 'America/Lima'});
        if (expiration < today) {
          coupon = await CouponModel.updateFieldById(coupon.cupon_id, { activo: false });
          if (!coupon.activo) {
            throw new UserError(`El cupón '${codigoCupon}' no es válido. Por favor, verifique e intente nuevamente`, 422);
          }
        }
      } else {
        throw new UserError(`El cupón '${codigoCupon}' no es válido. Por favor, verifique e intente nuevamente`, 422);
      }
    } else {
        coupon = await CouponModel.findById(order.cupon_id);
    }
  }
  
  const subtotales = await Promise.all(
    detallesPedido.map(async d => {
      const product = await ProductModel.findById(d.idProducto);
      return d.cantidad * product.precio;
    })
  );

  const total = subtotales.reduce((acc, sub) => acc + sub, 0);

  if (codigoCupon) {
    if (order.codigo_cupon !== codigoCupon) {
      if (order.cupon_id) {
      await CouponModel.updateFieldById(order.cupon_id, { activo: true });
      await CouponModel.updateFieldById(coupon.cupon_id, { activo: false });
      } else {
      await CouponModel.updateFieldById(coupon.cupon_id, { activo: false });
      }
    }
  } else {
    if (order.cupon_id) {
      await CouponModel.updateFieldById(order.cupon_id, { activo: true });
    }
  }  

  const updateOrder = {
    numeroDocumento: order.numero_documento,
    idUsuario: idUsuario,
    idDireccion: idDireccion,
    subtotal: roundDecimal(total),
    total: codigoCupon ? roundDecimal(total - roundDecimal(total * (coupon.porcentaje_descuento / 100))) : roundDecimal(total), 
    estadoPedido: OrderStates.PENDING,
    codigoCupon: codigoCupon || null,
    idCupon: codigoCupon ? coupon.cupon_id : null,
    descuentoAplicado: codigoCupon ? roundDecimal(total * (coupon.porcentaje_descuento / 100)) : 0
  };

  order = await OrderModel.updateById(id, updateOrder); 

  const datails = await DetailModel.findByField({ pedido_id: id});

  const detalles = new Map(detallesPedido.map(d => [d.idProducto, d.cantidad]));

  for (const detail of datails) {
    const product = await ProductModel.findById(detail.producto_id);
    const totStock = detail.cantidad + product.stock
    if (detalles.has(detail.producto_id)) {
      const cantidad = detalles.get(product.producto_id);
      const updateDetail = {
        idPedido: detail.pedido_id,
        idProducto: detail.producto_id,
        cantidad: cantidad,
        precioUnitario: product.precio,
      };
      await DetailModel.updateById(detail.detalle_pedido_id, updateDetail);
      await ProductModel.updateFieldById(detail.producto_id, { stock: totStock - cantidad});
      detalles.delete(detail.producto_id);
    } else {
      await DetailModel.deleteById(detail.detalle_pedido_id);
      await ProductModel.updateFieldById(detail.producto_id, { stock: totStock });
    }
  }

  for (const [idProducto, cantidad] of detalles) {
    const product = await ProductModel.findById(idProducto);
    const newDetail = {
      idPedido: order.pedido_id,
      idProducto: product.producto_id,
      cantidad: cantidad,
      precioUnitario: product.precio, 
    };
    await DetailModel.create(newDetail);
    await ProductModel.updateFieldById(product.producto_id, { stock: product.stock - cantidad });
  }
  
  return await jsonJoin(order, joins);
};

const cancelById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del pedido no fue ingresado`, 400);
  }

  let order = await OrderModel.findById(id);

  if (!order) {
    throw new UserError(`No existe ningún pedido asociado al ID '${id}'`, 404);
  }
  
  if (order.estado_pedido === OrderStates.CANCELLED) {
    throw new UserError(`El pedido asociado al ID '${id}' ya ha sido cancelado`, 409);
  }

  if (order.estado_pedido === OrderStates.SHIPPED) {
    throw new UserError(`El pedido asociado al ID '${id}' no puede ser cancelado porque ya ha sido enviado, solicita un reembolso una vez recibas el producto`, 409);
  }

  if (order.estado_pedido === OrderStates.DELIVERED) {
    throw new UserError(`El pedido asociado al ID '${id}' no puede ser cancelado porque ya ha sido entregado, solicita un reembolso`, 409);
  }
  const datails = await DetailModel.findByField({ pedido_id: id });

  for (const detail of datails) {
    const product = await ProductModel.findById(detail.producto_id);
    const totStock = detail.cantidad + product.stock
    await ProductModel.updateFieldById(detail.producto_id, { stock: totStock });
  }

  if (order.cupon_id) {
    await CouponModel.updateFieldById(order.cupon_id, { activo: true });
    order = await OrderModel.updateFieldById(id, { 
      estado_pedido: OrderStates.CANCELLED,
      codigo_cupon: null,
      cupon_id: null
    });
  } else {
    order = await OrderModel.updateFieldById(id, { estado_pedido: OrderStates.CANCELLED });
  }
  
  await PaymentModel.updateFieldById(id, { estado_pago: PaymentStates.CANCELLED });

  return await jsonJoin(order, joins);
};

const joins = [
  {
    join: DetailModel,
    on: "pedido_id",
    as: "detalles_pedido",
    many: true,
    subJoin: {
      join: ProductModel,
      on: "producto_id",
      as: "producto",
      many: false, 
      subJoin: {
        join: SubcategoryModel,
        on: "subcategoria_id",
        as: "subcategoria",
        many: false,
        subJoin: {
          join: CategoryModel,
          on: "categoria_id",
          as: "categoria",
          many: false
        }
      }
    }
  },
  {
    join: UserModel,
    on: "usuario_id",
    as: "usuario",
    many: false
  },
  {
    join: AddressModel,
    on: "direccion_id",
    as: "direccion",
    many: false
  },
  {
    join: CouponModel,
    on: "cupon_id",
    as: "cupon",
    many: false
  }
];

export { 
  getAll, 
  getProductDetailsById,
  getById, 
  create,
  putById, 
  cancelById 
};
