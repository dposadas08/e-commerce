class Pedido {
  constructor({ id, usuario_id, direccion_id, estado_pedido, total, fecha_pedido, estado }) {
    this.id = id || null;
    this.usuario_id = usuario_id || null;
    this.direccion_id = direccion_id || null;
    this.estado_pedido = estado_pedido || 'pendiente';
    this.total = total || 0.0;
    this.fecha_pedido = fecha_pedido || new Date();
    this.estado = estado || 'A';
  }
}
