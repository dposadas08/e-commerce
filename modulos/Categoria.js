class Categoria {
  constructor({ id, nombre, descripcion, producto_id, estado }) {
    this.id = id || null;
    this.nombre = nombre || '';
    this.descripcion = descripcion || '';
    this.producto_id = producto_id || null;
    this.estado = estado || 'A';
  }
}