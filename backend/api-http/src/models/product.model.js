import db from "../config/db.js";

class ProductModel {
  static async list() {
    const res = await db.query('SELECT * FROM obtener_productos()');
    return res.rows;
  }

  static async findById(id) {
    const res = await db.query('SELECT * FROM obtener_producto_por_id($1)', [id]);
    return res.rows[0] || null;
  }

  static async findByField(data) {
    const res = await db.query('SELECT * FROM obtener_productos_por_campo($1)', [data]);
    return res.rows;
  }

  static async create(data) {
    const res = await db.query(
      'SELECT * FROM registrar_producto($1, $2, $3, $4, $5, $6)',
      Object.values(data)
    );
    return res.rows[0] || null;
  }
  
  static async updateFieldById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_campo_producto_por_id($1, $2)',
      [id, data]
    );
    return res.rows[0] || null;
  }
  
  static async updateById(id, data) {
    const res = await db.query(
      'SELECT * FROM actualizar_producto($1, $2, $3, $4, $5, $6, $7)',
      [id, ...Object.values(data)]
    );
    return res.rows[0] || null;
  }

  static async deleteById(id) {
    const res = await db.query('SELECT * FROM eliminar_producto($1)', [id]);
    return res.rows[0] || null;
  }

  static async pageBySubcategory(subcategory, filter) {
    const res = await db.query(
      'SELECT * FROM paginar_productos_por_subcategoria($1, $2, $3)',
      [subcategory, ...Object.values(filter)]
    ); 
    return res.rows;
  }

  static async pageByCategory(category, filter) {
    const res = await db.query(
      'SELECT * FROM paginar_productos_por_categoria($1, $2, $3)',
      [category, ...Object.values(filter)]
    );
    return res.rows;
  }

  static async pageBySearch(search, filter) {
    const res = await db.query(
      'SELECT * FROM paginar_productos_por_busqueda($1, $2, $3)',
      [`%${search}%`, ...Object.values(filter)]
    );
    return res.rows;
  }
}

export { ProductModel };