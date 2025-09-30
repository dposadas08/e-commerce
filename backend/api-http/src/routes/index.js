import { Router } from "express";
import productRoutes from "./product.routes.js";
import categoryRoutes from "./category.routes.js";
import subcategoryRoutes from "./subcategory.routes.js";
import addressRoutes from "./address.routes.js";
import userRoutes from "./user.routes.js";
import couponRoutes from "./coupon.routes.js";
import orderRoutes from "./order.routes.js";
import paymentRoutes from "./payment.routes.js";
import authRoutes from "./auth.routes.js";

const router = Router();
router.use("/products", productRoutes);
router.use("/categories", categoryRoutes);
router.use("/subcategories", subcategoryRoutes);
router.use("/addresses", addressRoutes);
router.use("/users", userRoutes);
router.use("/coupons", couponRoutes);
router.use("/orders", orderRoutes);
router.use("/payments", paymentRoutes);
router.use("/auths", authRoutes);


export default router;