import { UserModel } from '../models/user.model.js';
import { formatterJsonDate } from '../utils/persistence.js';
import { UserError } from '../errors/user.error.js';
import validator from "validator";
import bcrypt from "bcryptjs";

const getAll = async () => {
  return formatterJsonDate(await UserModel.list());
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del usuario no fue ingresado`, 400);
  }
  
  const user = await UserModel.findById(id);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${id}'`, 404);
  }

  return formatterJsonDate(user);
};

const create = async (data) => {
  const { nombre, apellido, dni, correo, password, rol } = data;

  if (!nombre || !apellido || !dni || !correo || !password || !rol) {
    throw new UserError(`El parámetro nombre, apellido, dni, correo, password y rol son obligatorios`, 400);
  }

  if (dni.length !== 8 || !validator.isNumeric(dni)) {
    throw new UserError(`El valor del 'dni' debe contener solo números y no exceder los 8 dígitos`, 400);
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  
  const newUser = {
    nombre,
    apellido,
    dni,
    correo,
    hashedPassword,
    rol
  };

  return formatterJsonDate(await UserModel.create(newUser)); 
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del usuario no fue ingresado`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }
  
  const allowedKeys = Object(['nombre', 'apellido', 'dni', 'correo', 'password', 'rol', 'activo']);

  const [key] = Object.keys(data);

  if (!allowedKeys.includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  const user = await UserModel.findById(id);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${id}'`, 404);
  }

  if (data.dni !== undefined && (data.dni.length !== 8 || !validator.isNumeric(data.dni))) {
    throw new UserError(`El valor del 'dni' debe contener solo números y no exceder los 8 dígitos`, 400);
  }

  const updateFieldUser = {
    ...(data.nombre !== undefined ? { nombre: data.nombre } : {}),
    ...(data.apellido !== undefined ? { apellido: data.apellido } : {}),
    ...(data.dni !== undefined ? { dni: data.dni } : {}),
    ...(data.correo !== undefined ? { correo: data.correo } : {}),
    ...(data.password !== undefined ? { password: await bcrypt.hash(data.password, 10) } : {}),
    ...(data.rol !== undefined ? { rol: data.rol } : {}),
    ...(data.activo !== undefined ? { activo: data.activo } : {}),
  };

  return formatterJsonDate(await UserModel.updateFieldById(id, updateFieldUser));
};

const putById = async (id, data) => {
  
  const { nombre, apellido, dni, correo, password, rol, activo } = data;

  if (!nombre || !apellido || !dni || !correo || !password || !rol || activo === undefined ) {
    throw new UserError(`El parámetro nombre, apellido, dni, correo, password, rol y activo son obligatorios`, 400);
  }

  if (!id) { 
    throw new UserError(`El parámetro ID del usuario no fue ingresado`, 400);
  }

  if (!nombre) {
    throw new UserError(`El parámetro nombre es obligatorio`, 400);
  }
  
  const user = await UserModel.findById(id);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${id}'`, 404);
  }

  if (dni.length !== 8 && !validator.isNumeric(dni)) {
    throw new UserError(`El parámetro nombre es obligatorio`, 400);
  }
  
  const hashedPassword = await bcrypt.hash(password, 10);
  
  const updateUser = {
    nombre,
    apellido,
    dni,
    correo,
    hashedPassword,
    rol,
    activo
  };

  return formatterJsonDate(await UserModel.updateById(id, updateUser));
};

const deleteById = async (id) => {

  if (!id) { 
    throw new UserError(`El parámetro ID del usuario no fue ingresado`, 400);
  }
  const user = await UserModel.findById(id);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${id}'`, 404);
  }
  
  return formatterJsonDate(await UserModel.deleteById(id));
};

export { 
  getAll, 
  getById, 
  create, 
  patchById, 
  putById, 
  deleteById 
};
