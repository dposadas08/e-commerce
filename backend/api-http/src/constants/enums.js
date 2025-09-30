const OrderStates = Object.freeze({
  PENDING: 'pendiente',
  PAID: 'pagado', 
  SHIPPED: 'enviado', 
  DELIVERED: 'entregado', 
  CANCELLED: 'cancelado'
});

const PaymentStates = Object.freeze({
  PENDING: 'pendiente',
  COMPLETED: 'completado',
  FAILED: 'fallido',
  CANCELLED: 'cancelado',
  REFUNDED: 'reembolsado'
});

const PaymentMethods = Object.freeze({
  CREDIT_CARD: 'tarjeta_credito',
  DEBIT_CARD: 'tarjeta_debito',
  PAYPAL: 'paypal',
  TRANSFER: 'transferencia',
  MERCADO_PAGO: 'mercado_pago',
  CRYPTO: 'cripto',
  APPLE_PAY: 'apple_pay',
  GOOGLE_PAY: 'google_pay',
  CASH_ON_DELIVERY: 'pago_contra_entrega',
  OTHER: 'otro'
});

const UserRole = Object.freeze({
  ADMIN: 'administrador',
  USER: 'cliente'
});

export {
  OrderStates,
  PaymentStates,
  PaymentMethods,
  UserRole
};