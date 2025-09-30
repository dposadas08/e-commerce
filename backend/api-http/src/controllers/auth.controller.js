import { formatterResponse, errorResponse } from "../utils/http.js";
import { UserError } from '../errors/user.error.js';

import { authenticate } from '../services/auth.service.js';

const login = async (req, res) => { 
  try {
    const data = req.body;
    if (data === undefined || Object.keys(data).length === 0) {
      return res.status(400).json(errorResponse("El contenido de la solicitud está vacío o no contiene datos válidos"));
    }
    const login = await authenticate(data);
    res.status(201).json(formatterResponse(login, "BIENVENIDO A LA PAGINA PRINCIPAL"));
  } catch (error) {
    console.error("Error interno del servidor en el proceso de autenticación:", error);
    if (error instanceof UserError) {
      return res.status(error.statusCode).json(errorResponse(error.message));
    } else {
      return res.status(500).json(errorResponse("Error interno del servidor en el proceso de autenticación"));
    }
  }
};

export {
  login
}