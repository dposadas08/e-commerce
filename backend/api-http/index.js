import dotenv from "dotenv";
dotenv.config();

import app from "./src/app.js";

const PORT = process.env.PORT || 3400;

app.listen(PORT, () => {
  console.log(`Servidor escuchando en http://localhost:${PORT}...`);
});