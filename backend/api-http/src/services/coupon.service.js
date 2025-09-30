import { CouponModel } from '../models/coupon.model.js';
import { formatterJsonDate } from '../utils/persistence.js';
import { UserError } from '../errors/user.error.js';
import { DateTime } from "luxon";
import validator from "validator";

const getAll = async () => {
  return formatterJsonDate(await CouponModel.list());
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del cupón no fue ingresado`, 400);
  }

  const coupon = await CouponModel.findById(id);

  if (!coupon) {
    throw new UserError(`No existe ningún cupón asociado al ID '${id}'`, 404);
  }

  return formatterJsonDate(coupon);
};

const create = async (data) => {
  const { codigo, porcentajeDescuento, fechaExpiracion } = data;

  if (!codigo || !porcentajeDescuento || !fechaExpiracion) {
    throw new UserError(`Los parámetros codigo, porcentajeDescuento, fechaExpiracion y activo son obligatorio`, 400);
  }

  if (!validator.isDecimal(porcentajeDescuento.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'porcentajeDescuento' debe ser un número decimal mayor o igual a 1`, 400);
  }

  const today = DateTime.now().setZone('America/Lima');
  const expiration = DateTime.fromISO(fechaExpiracion, { zone: 'America/Lima'});

  if (expiration < today) {
    throw new UserError(`El valor de la fecha de expiración debe ser posterior a la fecha actual`, 422);
  }

  const newCoupon = {
    codigo, 
    porcentajeDescuento, 
    expiration
  };

  return formatterJsonDate(await CouponModel.create(newCoupon)); 
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del cupón no fue ingresado`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }  
  
  const allowedKeys = Object.freeze(['codigo', 'porcentajeDescuento', 'fechaExpiracion', 'activo']);
  
  const [key] = Object.keys(data);
  
  if (!allowedKeys.includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  const coupon = await CouponModel.findById(id);

  if (!coupon) {
    throw new UserError(`No existe ningún cupón asociado al ID '${id}'`, 404);
  }

  if (data.porcentajeDescuento !== undefined && !validator.isDecimal(data.porcentajeDescuento.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'porcentajeDescuento' debe ser un número decimal mayor o igual a 1`, 400);
  }
  
  if (data.fechaExpiracion !== undefined) {
    const today = DateTime.now().setZone('America/Lima');
    const expiration = DateTime.fromISO(data.fechaExpiracion, { zone: 'America/Lima'});

    if (expiration < today) {
      throw new UserError(`El valor de la fecha de expiración debe ser posterior a la fecha actual`, 422);
    }
  }

  const updateFieldCoupon = {
    ...(data.codigo !== undefined ? { codigo: data.codigo } : {}),
    ...(data.porcentajeDescuento !== undefined ? { porcentaje_descuento: data.porcentajeDescuento } : {}),
    ...(data.fechaExpiracion !== undefined ? { fecha_expiracion: expiration } : {}),
    ...(data.activo !== undefined ? { activo: data.activo } : {}),
  };

  return formatterJsonDate(await CouponModel.updateFieldById(id, updateFieldCoupon));
};

const putById = async (id, data) => {
  const { codigo, porcentajeDescuento, fechaExpiracion, activo } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID del cupón no fue ingresado`, 400);
  }

  if (!codigo || !porcentajeDescuento || !fechaExpiracion || activo === undefined) {
    throw new UserError(`Los parámetros codigo, porcentajeDescuento, fechaExpiracion y activo son obligatorio`, 400);
  }

  const coupon = await CouponModel.findById(id);

  if (!coupon) {
    throw new UserError(`No existe ningún cupón asociado al ID '${id}'`, 404);
  }

  if (!validator.isDecimal(porcentajeDescuento.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'porcentajeDescuento' debe ser un número decimal mayor o igual a 1`, 400);
  }
  
  const today = DateTime.now().setZone('America/Lima');
  const expiration = DateTime.fromISO(fechaExpiracion, { zone: 'America/Lima'});

  if (expiration < today) {
    throw new UserError(`El valor de la fecha de expiración debe ser posterior a la fecha actual`, 422);
  }
  
  const updateCoupon = {
    codigo, 
    porcentajeDescuento, 
    expiration, 
    activo
  };

  return formatterJsonDate(await CouponModel.updateById(id, updateCoupon));
};

const deleteById = async (id) => {

  if (!id) { 
    throw new UserError(`El parámetro ID del cupón no fue ingresado`, 400);
  }
  const coupon = await CouponModel.findById(id);

  if (!coupon) {
    throw new UserError(`No existe ningún cupón asociado al ID '${id}'`, 404);
  }
  
  return formatterJsonDate(await CouponModel.deleteById(id));
};

export { 
  getAll, 
  getById, 
  create, 
  patchById, 
  putById, 
  deleteById 
};