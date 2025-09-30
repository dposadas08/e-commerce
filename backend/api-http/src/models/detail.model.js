import db from "../config/db.js";

class DetailModel {
  static async list() {
    const res = await db.query('SELECT * FROM obtener_detalles_pedido()');
    return res.rows;
  }
  
  static async listProductDetailsByIdOrder(idOrder) {
    const res = await db.query('SELECT * FROM obtener_detalles_producto_por_pedido_id($1)', [idOrder]);
    return res.rows;
  }

  static async findById(id) {
    const res = await db.query('SELECT * FROM obtener_detalle_pedido_por_id($1)', [id]);
    return res.rows[0] || null;
  }

  static async findByField(data) {
    const res = await db.query('SELECT * FROM obtener_detalles_pedido_por_campo($1)', [data]);
    return res.rows;
  }

  static async create(data) {
    const res = await db.query(
      'SELECT * FROM registrar_detalle_pedido($1, $2, $3, $4)',
      Object.values(data)
    );
    return res.rows[0] || null;
  }
  
  static async updateFieldById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_campo_detalle_pedido_por_id($1, $2)',
      [id, data]
    );
    return res.rows[0] || null;
  }
  
  static async updateById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_detalle_pedido($1, $2, $3, $4, $5)',
      [id, ...Object.values(data)]
    );
    return res.rows[0] || null;
  }

  static async deleteById(id) {
    const res = await db.query('SELECT * FROM eliminar_detalle_pedido($1)', [id]);
    return res.rows[0] || null;
  }
}

export { DetailModel };