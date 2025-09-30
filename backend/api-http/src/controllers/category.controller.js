import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/category.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Las categorías han sido listadas exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar las categorías:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar las categorías"));
  }
};

const getById = async (req, res) => {
  try {       
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la categoría no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "La categoría ha sido encontrada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar la categoría:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar la categoría"));
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
    res.status(201).json(formatterResponse(created, "La categoría ha sido creada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de crear la categoría:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear la categoría"));
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
    res.json(formatterResponse(updated, "El campo de la categoría ha sido actualizado exitosamente"));

  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el campo de la categoría:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el campo de la categoría"));
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
    return res.status(201).json(formatterResponse(updated, "La categoría ha sido actualizada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar la categoría:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar la categoría"));
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
    return res.status(201).json(formatterResponse(deleted, "La categoría ha sido eliminada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar la categoría:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de eliminar la categoría"));
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