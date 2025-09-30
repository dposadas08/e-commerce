import { ProductModel } from '../models/product.model.js';
import { SubcategoryModel } from '../models/subcategory.model.js';
import { jsonJoin } from '../utils/persistence.js';
import { UserError } from '../errors/user.error.js';
import validator from "validator";

const getAll = async () => {
  const products = await ProductModel.list();
  return await jsonJoin(products, joins);
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del producto no fue ingresado`, 400);
  }

  const product = await ProductModel.findById(id);

  if (!product) {
    throw new UserError(`No existe ningún producto asociado al ID '${id}'`, 404);
  } 
  
  return await jsonJoin(product, joins);
};

const getImageById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del producto no fue ingresado`, 400);
  } 

  const product = await ProductModel.findById(id);
   
  if (!product) {
    throw new UserError(`No existe ningún producto asociado al ID '${id}'`, 404);
  } 

  if (!product.imagen_url) {
    throw new UserError(`No se encontró una imagen asociada al producto con el ID '${id}'`, 404);
  } 

  if (!validator.isURL(product.imagen_url)) {
    throw new UserError(`La URL de la imagen asociada al producto con el ID '${id}' no es válida`, 500);
  }

  return product.imagen_url;
};

const create = async (data) => {
  const { nombre, descripcion, precio, stock, imagenUrl, idSubcategoria } = data;

  if (!nombre || !precio || !stock || !idSubcategoria ) {
    throw new UserError(`El nombre, precio, stock y el id de la subcategoría son obligatorios`, 404);
  }

  if (!validator.isDecimal(precio.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'precio' debe ser un número decimal mayor o igual a 1`, 400);
  }

  if (!validator.isInt(stock.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'stock' debe ser un número entero mayor o igual a 1`, 400);
  }
  
  const subcategory = await SubcategoryModel.findById(idSubcategoria);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${idSubcategoria}'`, 404);
  }

  const newProduct = {
    nombre, 
    descripcion, 
    precio, 
    stock, 
    imagenUrl,
    idSubcategoria
  };
  
  const product = await ProductModel.create(newProduct);  

  return await jsonJoin(product, joins);
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del producto no fue ingresado`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }
  
  const allowedKeys = Object.freeze(['nombre', 'descripcion', 'precio', 'stock', 'imagenUrl', 'idSubcategoria']);

  const [key] = Object.keys(data);

  if (!allowedKeys.includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  let product = await ProductModel.findById(id);

  if (!product) {
    throw new UserError(`No existe ningún producto asociado al ID '${id}'`, 404);
  }

  if (data.precio !== undefined && !validator.isDecimal(data.precio.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'precio' debe ser un número decimal mayor o igual a 1`, 400);
  }

  if (data.stock !== undefined && !validator.isInt(data.stock.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'stock' debe ser un número entero mayor o igual a 1`, 400);
  }

  if (data.idSubcategoria !== undefined) {
    const subcategory = await SubcategoryModel.findById(data.idSubcategoria);
    
    if (!subcategory) {
      throw new UserError(`No existe ninguna subcategoría asociada al ID '${data.idSubcategoria}'`, 404);
    }
  }

  const updateFieldProduct = {
    ...(data.nombre !== undefined ? { nombre: data.nombre } : {}),
    ...(data.descripcion !== undefined ? { descripcion: data.descripcion } : {}),
    ...(data.precio !== undefined ? { precio: data.precio } : {}),
    ...(data.stock !== undefined ? { stock: data.stock } : {}),
    ...(data.imagenUrl !== undefined ? { imagen_url: data.imagenUrl } : {}),
    ...(data.idSubcategoria !== undefined ? { subcategoria_id: data.idSubcategoria } : {})
  };

  product = await ProductModel.updateFieldById(id, updateFieldProduct);

  return await jsonJoin(product, joins);
};

const putById = async (id, data) => {
  const {nombre, descripcion, precio, stock, imagenUrl, idSubcategoria } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID del producto no fue ingresado`, 400);
  }

  if (!nombre || !precio || !stock || !idSubcategoria) {
    throw new UserError(`Los parámetros nombre, precio, stock y idSubcategoria son obligatorios`, 400);
  }

  let product = await ProductModel.findById(id);

  if (!product) {
    throw new UserError(`No existe ningún producto asociado al ID '${id}'`, 404);
  }

  if (!validator.isDecimal(precio.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'precio' debe ser un número decimal mayor o igual a 1`, 400);
  }

  if (!validator.isInt(stock.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'stock' debe ser un número entero mayor o igual a 1`, 400);
  }
  
  const subcategory = await SubcategoryModel.findById(idSubcategoria);

  if (!subcategory) {
    throw new UserError(`No existe ninguna subcategoría asociada al ID '${idSubcategoria}'`, 404);
  }

  const updateProduct = {
    nombre, 
    descripcion, 
    precio, 
    stock, 
    imagenUrl,
    idSubcategoria
  };

  product = await ProductModel.updateById(id, updateProduct);  

  return await jsonJoin(product, joins);
};

const deleteById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del producto no fue ingresado`, 400);
  }

  let product = await ProductModel.findById(id);

  if (!product) {
    throw new UserError(`No existe ningún producto asociado al ID '${id}'`, 404);
  }
    
  product = await ProductModel.deleteById(id);

  return await jsonJoin(product, joins);
};

const pageBySubcategory = async (subcategory, page, limit) => {
  return await ProductModel.pageBySubcategory(subcategory, {
    page: page, 
    limit: limit
  });
};

const pageByCategory = async (category, page, limit) => {
  return await ProductModel.pageByCategory(category, {
    page: page, 
    limit: limit
  });
};

const pageBySearch = async (search, page, limit) => {
  return await ProductModel.pageBySearch(search, {
    page: page, 
    limit: limit
  });
};

const joins = [
  {
    join: SubcategoryModel,
    on: "subcategoria_id",
    as: "subcategoria",
    many: false
  }
];

export { 
  getAll, 
  getById,
  getImageById,
  create, 
  patchById, 
  putById, 
  deleteById,
  pageBySubcategory,
  pageByCategory,
  pageBySearch 
};