import db from "../config/db.js";

class PaymentModel {
  static async list() {
    const res = await db.query('SELECT * FROM obtener_pagos()');
    return res.rows;
  }

  static async findById(id) {
    const res = await db.query('SELECT * FROM obtener_pago_por_id($1)', [id]);
    return res.rows[0] || null;
  }

  static async findByField(data) {
    const res = await db.query('SELECT * FROM obtener_pagos_por_campo($1)', [data]);
    return res.rows;
  }

  static async create(data) {
    const res = await db.query(
      'SELECT * FROM registrar_pago($1, $2, $3, $4, $5)',
      Object.values(data)
    );
    return res.rows[0] || null;
  }
  
  static async updateFieldById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_campo_pago_por_id($1, $2)',
      [id, data]
    );
    return res.rows[0] || null;
  }
  
  static async updateById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_pago($1, $2, $3, $4, $5)',
      [id, ...Object.values(data)]
    );
    return res.rows[0] || null;
  }

  static async deleteById(id) {
    const res = await db.query('SELECT * FROM eliminar_pago($1)', [id]);
    return res.rows[0] || null;
  }
  
  static async getHistoryByIdUser(idUser) {
    const res = await db.query('SELECT * FROM obtener_historial_pagos_usuario_id($1)', [idUser]);
    return res.rows;
  }
}

export { PaymentModel };