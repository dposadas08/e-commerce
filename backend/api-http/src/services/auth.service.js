import { UserModel } from '../models/user.model.js';
import { UserError } from '../errors/user.error.js'; 
import validator from "validator";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

const authenticate = async (data) => {
  const { correo, password, rol } = data;

  if (!correo || !password) {
    throw new UserError(`Los campos correo y password son requeridos`, 400);
  }

  if (!validator.isEmail(correo)) {
    throw new UserError(`El correo electrónico ingresado no es válido'`, 400);
  } 
  
  const [user] = await UserModel.findByField({ correo: correo });

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al correo '${correo}'`, 404);
  }

  if (rol !== user.rol) { 
    throw new UserError(`No cuenta con los privilegios necesarios para acceder`, 403);
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    throw new UserError(`Error de autenticación: credenciales incorrectas`, 401);
  }  

  const token = jwt.sign(
    {
      id: user.usuario_id,
      role: user.rol,
    },
    process.env.JWT_SECRET,
    { expiresIn: "1d" }
  );

  return { token, user: user };
 
};

export { authenticate };