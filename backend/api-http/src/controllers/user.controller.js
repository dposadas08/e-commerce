import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/user.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Los usaurios han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los usuarios:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los usuarios"));
  }
};

const getById = async (req, res) => {
  try {       
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la categoría no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "El usuario ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el usuario:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el usuario"));
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
    res.status(201).json(formatterResponse(created, "El usuario ha sido creado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de crear el usuario:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear el usuario"));
    }
  }
};

const patchById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la categoría no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    if (Object.keys(data).length > 1) { 
      return res.status(400).json(errorResponse("Solo es posible ingresar un único campo con su valor correspondiente"));
    }
    const updated = await service.patchById(id, data);
    res.json(formatterResponse(updated, "El campo del usuario ha sido actualizado exitosamente"));

  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el campo del usuario:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el campo del usuario"));
    }
  }
};

const putById = async (req, res) => { 
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la categoría no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const updated = await service.putById(id, data);
    return res.status(201).json(formatterResponse(updated, "El usuario ha sido actualizado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el usuario:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el usuario"));
    }
  }
};

const deleteById = async (req, res) => { 
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la categoría no fue ingresado"));
    }
    const deleted = await service.deleteById(id);
    return res.status(201).json(formatterResponse(deleted, "El usuario ha sido eliminado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar el usuario:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de eliminar el usuario"));
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