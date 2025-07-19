class Pago {
  constructor({ id, pedido_id, metodo_pago, estado_pago, fecha_pago, monto, estado }) {
    this.id = id || null;
    this.pedido_id = pedido_id || null;
    this.metodo_pago = metodo_pago || '';
    this.estado_pago = estado_pago || '';
    this.fecha_pago = fecha_pago || null;
    this.monto = monto || 0.0;
    this.estado = estado || 'A';
  }
}