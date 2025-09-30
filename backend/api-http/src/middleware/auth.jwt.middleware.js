import { errorResponse } from "../utils/http.js";
import { UserModel } from '../models/user.model.js';
import jwt from "jsonwebtoken";

const verifyToken = async (req, res, next) => {
  try {
    const token = req.headers["authorization"];
    if (!token) {
      return res.status(401).json(errorResponse("El token es obligatorio"));
    }

    const bearerToken = token.split(" ");

    const decoded = jwt.verify(bearerToken[1], process.env.JWT_SECRET);

    const user = await UserModel.findByField({usuario_id: decoded.id});
    
    if (!user) {
      return res.status(401).json(errorResponse("El token es obligatorio"));
    }

    req.user = user;

    next();

  } catch (err) {
    console.error("Error al verificar el token de autenticación:", err);
    return res.status(401).json(errorResponse("Acceso no autorizado"));
  }
};

export { verifyToken };
