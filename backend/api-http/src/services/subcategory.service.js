import { SubcategoryModel } from '../models/subcategory.model.js';
import { CategoryModel } from '../models/category.model.js';
import { jsonJoin } from '../utils/persistence.js';
import { UserError } from '../errors/user.error.js';

const getAll = async () => {
  const subcategories = await SubcategoryModel.list();
  return await jsonJoin(subcategories, joins);
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la subcategoría no fue ingresada`, 400);
  }
  
  const subcategory = await SubcategoryModel.findById(id);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${id}'`, 404);
  }
  
  return await jsonJoin(subcategory, joins);
};

const create = async (data) => {
  const { nombre, descripcion, idCategoria } = data;

  if (!nombre || !idCategoria) {
    throw new UserError(`Los parámetros nombre y idCategoria son obligatorios`, 400);
  }

  const category = await CategoryModel.findById(idCategoria);

  if (!category) {
    throw new UserError(`No existe ninguna categoría asociada al ID '${idCategoria}'`, 404);
  }

  const newSubcategory = {
    nombre, 
    descripcion,
    idCategoria
  };

  const subcategory = await SubcategoryModel.create(newSubcategory); 

  return await jsonJoin(subcategory, joins);
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la subcategoría no fue ingresada`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }
  
  const allowedKeys = Object.freeze(['nombre', 'descripcion', 'idCategoria']);

  const [key] = Object.keys(data);

  if (!allowedKeys.includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  let subcategory = await SubcategoryModel.findById(id);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${id}'`, 404);
  }

  if (data.idCategoria !== undefined) {
    const category = await CategoryModel.findById(data.idCategoria);
    
    if (!category) {
      throw new UserError(`No existe ninguna categoría asociada al ID '${data.idCategoria}'`, 404);
    }
  }
  
  const updateFieldSubcategory = {
    ...(data.nombre !== undefined ? { nombre: data.nombre } : {}),
    ...(data.descripcion !== undefined ? { descripcion: data.descripcion } : {}),
    ...(data.idCategoria !== undefined ? { categoria_id: data.idCategoria } : {}),
  };

  subcategory = await SubcategoryModel.updateFieldById(id, updateFieldSubcategory);

  return await jsonJoin(subcategory, joins);
};

const putById = async (id, data) => {
  const { nombre, descripcion, idCategoria } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID de la subcategoría no fue ingresada`, 400);
  }

  if (!nombre || !idCategoria) {
    throw new UserError(`Los parámetros nombre y idCategoria son obligatorios`, 400);
  }

  let subcategory = await SubcategoryModel.findById(id);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${id}'`, 404);
  }

  const category = await CategoryModel.findById(idCategoria);

  if (!category) {
    throw new UserError(`No existe ninguna categoría asociada al ID '${idCategoria}'`, 404);
  }
  
  const updateSubcategory = {
    nombre,
    descripcion,
    idCategoria
  };

  subcategory = await SubcategoryModel.updateById(id, updateSubcategory);

  return await jsonJoin(subcategory, joins);
};

const deleteById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la subcategoría no fue ingresada`, 400);
  }

  let subcategory = await SubcategoryModel.findById(id);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${id}'`, 404);
  }

  subcategory = await SubcategoryModel.deleteById(id);

  return await jsonJoin(subcategory, joins);
};

const joins = [
  {
    join: CategoryModel,
    on: "categoria_id",
    as: "categoria",
    many: false
  }
];

export { 
  getAll, 
  getById, 
  create, 
  patchById, 
  putById, 
  deleteById 
};
