import express from "express";
import routers from "./routes/index.js";

const app = express();

app.use(express.json());

app.get("/", (req, res) => {
  res.send("Bienvenido al E-Commerce");
});

app.use("/api/v1", routers);

export default app;