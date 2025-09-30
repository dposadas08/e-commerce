import db from "../config/db.js";

class CouponModel {
  static async list() {
    const res = await db.query('SELECT * FROM obtener_cupones()');
    return res.rows;
  }

  static async findById(id) {
    const res = await db.query('SELECT * FROM obtener_cupon_por_id($1)', [id]);
    return res.rows[0] || null;
  }

  static async findByField(data) {
    const res = await db.query('SELECT * FROM obtener_cupones_por_campo($1)', [data]);
    return res.rows;
  }

  static async create(data) {
    const res = await db.query(
      'SELECT * FROM registrar_cupon($1, $2, $3)',
      Object.values(data)
    );
    return res.rows[0] || null;
  }
  
  static async updateFieldById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_campo_cupon_por_id($1, $2)',
      [id, data]
    );
    return res.rows[0] || null;
  }
  
  static async updateById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_cupon($1, $2, $3, $4, $5)',
      [id, ...Object.values(data)]
    );
    return res.rows[0] || null;
  }

  static async deleteById(id) {
    const res = await db.query('SELECT * FROM eliminar_cupon($1)', [id]);
    return res.rows[0] || null;
  }
}

export { CouponModel };