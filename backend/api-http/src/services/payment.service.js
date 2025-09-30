import { PaymentModel } from '../models/payment.model.js';
import { OrderModel } from '../models/order.model.js';
import { DetailModel } from "../models/detail.model.js";
import { UserModel } from "../models/user.model.js";
import { AddressModel } from '../models/address.model.js';
import { CouponModel } from "../models/coupon.model.js";
import { ProductModel } from "../models/product.model.js";
import { SubcategoryModel } from '../models/subcategory.model.js';
import { CategoryModel } from '../models/category.model.js';
import { jsonJoin, roundDecimal } from '../utils/persistence.js';
import { OrderStates, PaymentStates, PaymentMethods } from '../constants/enums.js';
import { UserError } from '../errors/user.error.js';
import { DateTime } from "luxon";
import validator from "validator";

const getAll = async () => {
  const payment = await PaymentModel.list();
  
  return await jsonJoin(payment, joins); 
};

const getById = async (id) => {
  if (!id) { 
    throw new UserError(`El parámetro ID del pago no fue ingresado`, 400);
  }

  const payment = await PaymentModel.findById(id);

  if (!payment) {
    throw new UserError(`No existe ningún pago asociado al ID '${id}'`, 404);
  }
  
  return await jsonJoin(payment, joins); 
};

const complete = async (idPedido, data) => {
  const { metodoPago, monto } = data;

  if (!idPedido) { 
    throw new UserError(`El parámetro ID del pedido no fue ingresado`, 400);
  }

  if (!metodoPago || !monto) {
    throw new UserError(`Los parámetros metodoPago y monto son obligatorio`, 400);
  }

  if (!validator.isDecimal(monto.toString(), { min: 1 })) {
    throw new UserError(`El valor del 'monto' debe ser un número decimal mayor o igual a 1`, 400);
  }

  let order = await OrderModel.findById(idPedido);

  if (!order) {
    throw new UserError(`No existe ningún pedido asociado al ID '${id}'`, 404);
  }

  if (order.estado_pedido === OrderStates.CANCELLED) {
    throw new UserError(`El pedido asociado al ID '${idPedido}' ha sido cancelado`, 409);
  }
  
  let [payment] = await PaymentModel.findByField({ pedido_id: idPedido});

  if (payment.estado_pago === PaymentStates.COMPLETED) {
    throw new UserError(`El pago asociado al ID del pedido '${idPedido}' ya ha sido pagado`, 409);
  }

  if (+order.total !== +monto) {
    throw new UserError(`El valor del 'monto' es incorrecto. Debe ingresar exactamente '${order.total} PEN'`, 422);
  }

  payment = await PaymentModel.updateFieldById(payment.pago_id, { 
    metodo_pago: metodoPago,
    estado_pago: PaymentStates.COMPLETED,
    fecha_pago: DateTime.now().setZone('America/Lima'),
    monto: roundDecimal(monto)
  });

  await OrderModel.updateFieldById(idPedido, { estado_pedido: OrderStates.PAID });

  return await jsonJoin(payment, joins); 
};

const getHistoryByIdUser = async (idUser) => {
  if (!idUser) { 
    throw new UserError(`El parámetro ID del usuario no fue ingresado`, 400);
  }
  
  const user = await UserModel.findById(idUser);

  if (!user) {
    throw new UserError(`No existe ningún usuario asociado al ID '${idUser}'`, 404);
  }

  const payment = await PaymentModel.getHistoryByIdUser(idUser);

  return jsonJoin(payment, joins);
};

const joins = [
  {
    join: OrderModel,
    on: "pedido_id",
    as: "pedido",
    many: false,
    subJoin: [
      {
        join: DetailModel,
        on: "pedido_id",
        as: "detalle",
        many: true,
        subJoin: {
          join: ProductModel,
          on: "producto_id",
          as: "producto",
          many: false, 
          subJoin: {
            join: SubcategoryModel,
            on: "subcategoria_id",
            as: "subcategoria",
            many: false,
            subJoin: {
              join: CategoryModel,
              on: "categoria_id",
              as: "categoria",
              many: false
            }
          }
        }
      },
      {
        join: CouponModel,
        on: "cupon_id",
        as: "cupon",
        many: false
      },
      {
        join: UserModel,
        on: "usuario_id",
        as: "usuario",
        many: false
      },
      {
        join: AddressModel,
        on: "direccion_id",
        as: "direccion",
        many: false
      }
    ]
  }
];

export { 
  getAll, 
  getById, 
  complete,
  getHistoryByIdUser
};