import { Router } from "express";
import * as controller from "../controllers/product.controller.js";
import { verifyToken } from "../middleware/auth.jwt.middleware.js";

const router = Router();

router.get("/", verifyToken, controller.getAll);
router.get("/subcategory", verifyToken, controller.getPageBySubcategory);
router.get("/category", verifyToken, controller.getPageByCategory);
router.get("/search", verifyToken, controller.getPageBySearch);
router.get("/:id", verifyToken, controller.getById);
router.get("/:id/image", verifyToken, controller.getImageById);
router.post("/", verifyToken, controller.create);
router.patch("/:id", verifyToken, controller.patchById);
router.put("/:id", verifyToken, controller.putById);
router.delete("/:id", verifyToken, controller.deleteById);

export default router;