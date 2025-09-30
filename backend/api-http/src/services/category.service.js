import { CategoryModel } from '../models/category.model.js';
import { UserError } from '../errors/user.error.js';

const getAll = async () => {
  return await CategoryModel.list();
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la categoría no fue ingresada`, 400);
  }

  const category = await CategoryModel.findById(id);

  if (!category) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${id}'`, 404);
  }

  return category;
};

const create = async (data) => {
  const { nombre, descripcion } = data;

  if (!nombre) {
    throw new UserError(`El parámetro nombre es obligatorio`, 400);
  }

  const newCategory = {
    nombre, 
    descripcion
  };

  return await CategoryModel.create(newCategory); 
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la categoría no fue ingresada`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }
  
  const allowedKeys = Object.freeze(['nombre', 'descripcion']);

  const [key] = Object.keys(data);

  if (!allowedKeys.includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  const category = await CategoryModel.findById(id);

  if (!category) {
    throw new UserError(`No existe ninguna categoría asociada al ID '${id}'`, 404);
  }

  const updateFieldCategory = {
    ...(data.nombre !== undefined ? { nombre: data.nombre } : {}),
    ...(data.descripcion !== undefined ? { descripcion: data.descripcion } : {}),
  };

  return await CategoryModel.updateFieldById(id, updateFieldCategory);
};

const putById = async (id, data) => {
  const {nombre, descripcion } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID de la categoría no fue ingresada`, 400);
  }

  if (!nombre) {
    throw new UserError(`El parámetro nombre es obligatorio`, 400);
  }

  const category = await CategoryModel.findById(id);

  if (!category) {
    throw new UserError(`No existe ninguna categoría asociada al ID '${id}'`, 404);
  }

  const updateCategory = {
    nombre,
    descripcion
  };

  return await CategoryModel.updateById(id, updateCategory);
};

const deleteById = async (id) => {

  if (!id) { 
    throw new UserError(`El parámetro ID de la categoría no fue ingresada`, 400);
  }
  const category = await CategoryModel.findById(id);

  if (!category) {
    throw new UserError(`No existe ninguna categoría asociada al ID '${id}'`, 404);
  }
  
  return await CategoryModel.deleteById(id);
};

export { 
  getAll, 
  getById, 
  create, 
  patchById, 
  putById, 
  deleteById 
};