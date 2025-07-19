class DetallePedido {
  constructor({ id, pedido_id, producto_id, cantidad, precio_unitario, estado }) {
    this.id = id || null;
    this.pedido_id = pedido_id || null;
    this.producto_id = producto_id || null;
    this.cantidad = cantidad || 0;
    this.precio_unitario = precio_unitario || 0.0;
    this.estado = estado || 'A';
  }
}