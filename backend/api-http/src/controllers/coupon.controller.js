import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/coupon.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Los cupones han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los cupones:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los cupones"));
  }
};

const getById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del cupón no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "El cupón ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el cupón:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el cupón"));
    }
  }
};

const create = async (req, res) => { 
  try {
    const data = req.body;
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const created = await service.create(data);
    res.status(201).json(formatterResponse(created, "El cupón ha sido creado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de crear el cupón:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear el cupón"));
    }
  }
};

const patchById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del cupón no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    if (Object.keys(data).length > 1) { 
      return res.status(400).json(errorResponse("Solo es posible ingresar un único campo con su valor correspondiente"));
    }
    const updated = await service.patchById(id, data);
    res.json(formatterResponse(updated, "El campo del cupón ha sido actualizado exitosamente"));

  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el campo del cupón:", error); 
    if (error instanceof UserError) {   
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el campo del cupón"));
    }
  }
};

const putById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del cupón no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const updated = await service.putById(id, data);
    return res.status(201).json(formatterResponse(updated, "El cupón ha sido actualizado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de actualizar el cupón:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el cupón"));
    }
  }
};

const deleteById = async (req, res) => { 
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del cupón no fue ingresado"));
    }
    const deleted = await service.deleteById(id);
    return res.status(201).json(formatterResponse(deleted, "El cupón ha sido eliminado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar el cupón:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de eliminar el cupón"));
    }
  }
};

export {
  getAll,
  getById,
  create,
  patchById,
  putById,
  deleteById
};