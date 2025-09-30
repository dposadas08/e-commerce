import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/address.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Las direcciones han sido listadas exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar las direcciones:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar las direcciones"));
  }
};

const getAllByIdUser = async (req, res) => {
  try {       
    const { idUser } = req.params;
    if (!idUser) {
      return res.status(400).json(errorResponse("El parámetro ID del usuario no fue ingresado"));
    }
    const found = await service.getAllByIdUser(idUser);
    res.status(200).json(formatterResponse(found, "Las direcciones han sido encontradas exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar las direcciones:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar las direcciones"));
    }
  }
};

const getById = async (req, res) => {
  try {       
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la dirección no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "La dirección ha sido encontrada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar la dirección:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar la dirección"));
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
    res.status(201).json(formatterResponse(created, "La dirección ha sido creada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de crear la dirección:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear la dirección"));
    }
  }
};

const patchById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la dirección no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    if (Object.keys(data).length > 1) { 
      return res.status(400).json(errorResponse("Solo es posible ingresar un único campo con su valor correspondiente"));
    }
    const updated = await service.patchById(id, data);
    res.json(formatterResponse(updated, "El campo de la dirección ha sido actualizado exitosamente"));

  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el campo de la dirección:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el campo de la dirección"));
    }
  }
};

const putById = async (req, res) => { 
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la dirección no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const updated = await service.putById(id, data);
    return res.status(201).json(formatterResponse(updated, "La dirección ha sido actualizada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar la dirección:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar la dirección"));
    }
  }
};

const deleteById = async (req, res) => { 
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la dirección no fue ingresado"));
    }
    const deleted = await service.deleteById(id);
    return res.status(201).json(formatterResponse(deleted, "La dirección ha sido eliminada exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar la dirección:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de eliminar la dirección"));
    }
  }
};

export {
  getAll,
  getAllByIdUser,
  getById,
  create,
  patchById,
  putById,
  deleteById
};