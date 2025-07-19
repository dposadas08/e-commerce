class Subcategoria {
  constructor({ id, nombre, descripcion, categoria_id, estado }) {
    this.id = id || null;
    this.nombre = nombre || '';
    this.descripcion = descripcion || '';
    this.categoria_id = categoria_id || null;
    this.estado = estado || 'A';
  }
}