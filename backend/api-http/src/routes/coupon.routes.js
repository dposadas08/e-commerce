import { Router } from "express";
import * as controller from "../controllers/coupon.controller.js";
import { verifyToken } from "../middleware/auth.jwt.middleware.js";

const router = Router();

router.get("/", verifyToken, controller.getAll);
router.get("/:id", verifyToken, controller.getById);
router.post("/", verifyToken, controller.create);
router.patch("/:id", verifyToken, controller.patchById);
router.put("/:id", verifyToken, controller.putById);
router.delete("/:id", verifyToken, controller.deleteById);

export default router;