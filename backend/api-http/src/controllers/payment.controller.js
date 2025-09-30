import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import * as service from '../services/payment.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Los pagos han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los pagos:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los pagos"));
  }
};

const getById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del pago no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "El pago ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el pago:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el pago"));
    }
  }
};

const complete = async (req, res) => { 
  try {
    const { idOrder } = req.params;
    const data = req.body;
    if (!idOrder) {
      return res.status(400).json(errorResponse("El parámetro ID del pedido no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const created = await service.complete(idOrder, data);
    res.status(201).json(formatterResponse(created, "El pago ha sido completado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de completar el pago:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de completar el pago"));
    }
  }
};

const getHistoryByIdUser = async (req, res) => { 
  try {
    const { idUser } = req.params;
    if (!idUser) {
      return res.status(400).json(errorResponse("El parámetro ID del usuario no fue ingresado"));
    }
    const found = await service.getHistoryByIdUser(idUser);
    res.status(200).json(formatterResponse(found, "El pago ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el pago:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el pago"));
    }
  }
};
export {
  getAll,
  getById,
  complete,
  getHistoryByIdUser
};