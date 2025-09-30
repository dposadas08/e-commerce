class Categoria {
  constructor({ id, nombre, descripcion, estado }) {
    this.id = id || null;
    this.nombre = nombre || '';
    this.descripcion = descripcion || '';
    this.estado = estado || 'A';
  }
}