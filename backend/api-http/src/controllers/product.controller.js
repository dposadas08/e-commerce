import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';
import axios from "axios";

import * as service from '../services/product.service.js';

const getAll = async (req, res) => {
  try {
    const listed = await service.getAll();
    res.status(200).json(formatterResponse(listed, "Los productos han sido listados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de listar los productos:", error);
    return res.status(500).json(errorResponse("Error interno del servidor al tratar de listar los productos"));
  }
};

const getById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del producto no fue ingresado"));
    }
    const found = await service.getById(id);
    res.status(200).json(formatterResponse(found, "El producto ha sido encontrado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar el producto:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar el producto"));
    }
  }
};

const getImageById = async (req, res) => {
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del producto no fue ingresado"));
    }
    const imageUrl = await service.getImageById(id);
    const result = await axios.get(imageUrl, {
      responseType: 'stream'
    });
    res.setHeader('Content-Type', result.headers['content-type']);
    result.data.pipe(res);
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar la imagen del producto:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar la imagen del producto"));
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
    res.status(201).json(formatterResponse(created, "El producto ha sido creado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de crear el producto:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de crear el producto"));
    }
  }
};

const patchById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del producto no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    if (Object.keys(data).length > 1) { 
      return res.status(400).json(errorResponse("Solo es posible ingresar un único campo con su valor correspondiente"));
    }
    const updated = await service.patchById(id, data);
    res.json(formatterResponse(updated, "El campo del producto ha sido actualizado exitosamente"));

  } catch (error) {
    console.error("Error interno del servidor al tratar de actualizar el campo del producto:", error); 
    if (error instanceof UserError) {   
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el campo del producto"));
    }
  }
};

const putById = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del producto no fue ingresado"));
    }
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const updated = await service.putById(id, data);
    return res.status(201).json(formatterResponse(updated, "El producto ha sido actualizado exitosamente"));
  } catch (error) { 
    console.error("Error interno del servidor al tratar de actualizar el producto:", error);  
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de actualizar el producto"));
    }
  }
};

const deleteById = async (req, res) => { 
  try {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json(errorResponse("El parámetro ID del producto no fue ingresado"));
    }
    const deleted = await service.deleteById(id);
    return res.status(201).json(formatterResponse(deleted, "El producto ha sido eliminado exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de eliminar el producto:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de eliminar el producto"));
    }
  }
};

const getPageBySubcategory = async (req, res) => {
  try {
    const { subcategory, page, limit } = req.query;
    if (!page || !limit) {
      return res.status(400).json(errorResponse("Los parámetros page y limit son necesarios"));
    }
    const paged = await service.pageBySubcategory(subcategory, page, limit);
    res.status(200).json(formatterResponse(paged, "Los productos han sido encontrados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar los productos:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar los productos"));
    }
  }
};

const getPageByCategory = async (req, res) => {
  try {
    const { category, page, limit } = req.query;
    if (!page || !limit) {
      return res.status(400).json(errorResponse("Los parámetros page y limit son necesarios"));
    }
    const paged = await service.pageByCategory(category, page, limit);
    res.status(200).json(formatterResponse(paged, "Los productos han sido encontrados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar los productos:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar los productos"));
    }
  }
};

const getPageBySearch = async (req, res) => {
  try {
    const { search, page, limit } = req.query;
    if (!page || !limit) {
      return res.status(400).json(errorResponse("Los parámetros page y limit son necesarios"));
    }
    const paged = await service.pageBySearch(search, page, limit);
    res.status(200).json(formatterResponse(paged, "Los productos han sido encontrados exitosamente"));
  } catch (error) {
    console.error("Error interno del servidor al tratar de buscar los productos:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor al tratar de buscar los productos"));
    }
  }
};

export {
  getAll,
  getById,
  getImageById,
  create,
  patchById,
  putById,
  deleteById,
  getPageBySubcategory,
  getPageByCategory,
  getPageBySearch
};