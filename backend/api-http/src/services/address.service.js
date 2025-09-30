import { AddressModel } from '../models/address.model.js';
import { UserModel } from '../models/user.model.js';
import { jsonJoin } from '../utils/persistence.js';
import { UserError } from '../errors/user.error.js';

const getAll = async () => {
  const addresses = await AddressModel.list();
  return await jsonJoin(addresses, joins);
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la dirección no fue ingresada`, 400);
  }
  
  const address = await AddressModel.findById(id);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${id}'`, 404);
  }

  return await jsonJoin(address, joins);
};

const getAllByIdUser = async (idUser) => {
  if (!idUser) { 
    throw new UserError(`El parámetro ID de la dirección no fue ingresada`, 400);
  }
  
  const user = await UserModel.findById(idUser);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${id}'`, 404);
  }

  const address = await AddressModel.findByField({ usuario_id: idUser });

  if (address.length === 0) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${idUser}'`, 404);
  }

  return await jsonJoin(user, {
    join: AddressModel,
    on: "usuario_id",
    as: "direcciones",
    many: true
  });
};

const create = async (data) => {
  const { direccion, ciudad, provincia, codigoPostal, pais, idUsuario } = data;

  if (!direccion || !idUsuario) {
    throw new UserError(`Los parámetros direccion y idUsuario son obligatorios`, 400);
  }

  const user = await UserModel.findById(idUsuario);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${idUsuario}'`, 404);
  }

  const newAddress = { 
    direccion, 
    ciudad, 
    provincia, 
    codigoPostal, 
    pais, 
    idUsuario
  };

  const address = await AddressModel.create(newAddress); 

  return await jsonJoin(address, joins);
};

const patchById = async (id, data = {}) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la dirección no fue ingresada`, 400);
  }

  if (Object.keys(data).length > 1) { 
    throw new UserError(`El formato del pedido es inválido. Solo es posible ingresar un parámetro y valor`, 400);
  }

  const allowedKeys = Object.freeze(['direccion', 'ciudad', 'provincia', 'codigoPostal', 'pais', 'idUsuario', 'activo']);

  const [key] = Object.keys(data);

  if (!allowedKeys .includes(key)) {
    throw new UserError(`El parámetro '${key}' ingresado no es válido`, 400);
  }

  let address = await AddressModel.findById(id);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${id}'`, 404);
  }

  if (data.idUsuario !== undefined) {
    const user = await UserModel.findById(data.idUsuario);

    if (!user) {
      throw new UserError(`No existe ningún usuario asociado al ID '${data.idUsuario}'`, 404);
    }
  }

  const updateFieldAddress = {
    ...(data.direccion !== undefined ? { direccion: data.direccion } : {}),
    ...(data.ciudad !== undefined ? { ciudad: data.ciudad } : {}),
    ...(data.provincia !== undefined ? { provincia: data.provincia } : {}),
    ...(data.codigoPostal !== undefined ? { codigo_postal: data.codigoPostal } : {}),
    ...(data.pais !== undefined ? { pais: data.pais } : {}),
    ...(data.idUsuario !== undefined ? { usuario_id: data.idUsuario } : {}),
    ...(data.activo !== undefined ? { activo: data.activo } : {}),
  };

  address = await AddressModel.updateFieldById(id, updateFieldAddress);

  return await jsonJoin(address, joins);
};

const putById = async (id, data) => {
  const { direccion, ciudad, provincia, codigoPostal, pais, idUsuario, activo } = data;

  if (!id) { 
    throw new UserError(`El parámetro ID de la dirección no fue ingresada`, 400);
  }

  if (!direccion || !idUsuario || activo === undefined) {
    throw new UserError(`Los parámetros dirección, idUsuario y activo son obligatorios`, 400);
  }

  let address = await AddressModel.findById(id);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${id}'`, 404);
  }

  const user = await UserModel.findById(idUsuario);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${idUsuario}'`, 404);
  }
  
  const updateAddress = {
    direccion, 
    ciudad, 
    provincia, 
    codigoPostal, 
    pais, 
    idUsuario,
    activo
  };

  address = await AddressModel.updateById(id, updateAddress);

  return await jsonJoin(address, joins);
};

const deleteById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID de la dirección no fue ingresada`, 400);
  }

  let address = await AddressModel.findById(id);

  if (!address) {
    throw new UserError(`No existe ninguna dirección asociada al ID '${id}'`, 404);
  }

  address = await AddressModel.deleteById(id);

  return await jsonJoin(address, joins);
};

const joins = [
  {
    join: UserModel,
    on: "usuario_id",
    as: "usuario",
    many: false
  }
];

export { 
  getAll,
  getAllByIdUser,
  getById, 
  create, 
  patchById, 
  putById, 
  deleteById 
};
