class Producto {
  constructor({ id, nombre, descripcion, precio, stock, imagen_url, fecha_creacion, estado }) {
    this.id = id || null;
    this.nombre = nombre || '';
    this.descripcion = descripcion || '';
    this.precio = precio || 0.0;
    this.stock = stock || 0;
    this.imagen_url = imagen_url || '';
    this.fecha_creacion = fecha_creacion || new Date();
    this.estado = estado || 'A';
  }
}
