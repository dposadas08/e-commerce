import { Router } from "express";
import * as controller from "../controllers/payment.controller.js";
import { verifyToken } from "../middleware/auth.jwt.middleware.js";

const router = Router();

router.get("/", verifyToken, controller.getAll);
router.get("/:id", verifyToken, controller.getById);
router.put("/:idOrder", verifyToken, controller.complete);
router.get("/:idUser/history", verifyToken, controller.getHistoryByIdUser);

export default router;