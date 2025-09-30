import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/order.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Los pedidos han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los pedidos:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los pedidos"));
  }
};

const getProductDetailsById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la orden no fue ingresado"));
    }
    const listed = await service.getProductDetailsById(id);
    res.status(200).json(formatterResponse(listed, "Los detalles de productos han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los detalles de productos:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los detalles de productos"));
  }
};

const getById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la orden no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "El pedido ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el pedido:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el pedido"));
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
    res.status(201).json(formatterResponse(created, "El pedido ha sido creado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de crear el pedido:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear el pedido"));
    }
  }
};

const putById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la orden no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const updated = await service.putById(id, data);
    return res.status(201).json(formatterResponse(updated, "El pedido ha sido actualizado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de actualizar el pedido:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el pedido"));
    }
  }
};

const cancelById = async (req, res) => { 
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID de la orden no fue ingresado"));
    }
    const canceled = await service.cancelById(id);
    return res.status(201).json(formatterResponse(canceled, "El pedido ha sido cancelado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar el pedido:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de cancelar el pedido"));
    }
  }
};

export {
  getAll,
  getProductDetailsById,
  getById,
  create,
  putById,
  cancelById
};