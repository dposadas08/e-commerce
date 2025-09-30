import { Router } from "express";
import * as controller from "../controllers/order.controller.js";
import { verifyToken } from "../middleware/auth.jwt.middleware.js";

const router = Router();

router.get("/", verifyToken, controller.getAll);
router.get("/:id/product-details", verifyToken, controller.getProductDetailsById);
router.get("/:id", verifyToken, controller.getById);
router.post("/", verifyToken, controller.create);
router.put("/:id", verifyToken, controller.putById);
router.put("/:id/cancel", verifyToken, controller.cancelById);

export default router;