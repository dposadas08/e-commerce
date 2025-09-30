import db from "../config/db.js";

class OrderModel {
  static async list() {
    const res = await db.query('SELECT * FROM obtener_pedidos()');
    return res.rows;
  }

  static async findById(id) {
    const res = await db.query('SELECT * FROM obtener_pedido_por_id($1)', [id]);
    return res.rows[0] || null;
  }

  static async findByField(data) {
    const res = await db.query('SELECT * FROM obtener_pedidos_por_campo($1)', [data]);
    return res.rows;
  }

  static async create(data) {
    const res = await db.query(
      'SELECT * FROM registrar_pedido($1, $2, $3, $4, $5, $6, $7, $8, $9)',
      Object.values(data)
    );
    return res.rows[0] || null;
  }
  
  static async updateFieldById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_campo_pedido_por_id($1, $2)',
      [id, data]
    );
    return res.rows[0] || null;
  }
  
  static async updateById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_pedido($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
      [id, ...Object.values(data)]
    );
    return res.rows[0] || null;
  }

  static async deleteById(id) {
    const res = await db.query('SELECT * FROM eliminar_pedido($1)', [id]);
    return res.rows[0] || null;
  }

  static async lastOrderNumber() {
    const res = await db.query('SELECT obtener_ultimo_numero_pedido() AS ultimo');
    return res.rows[0] || null;
  }
}

export { OrderModel };