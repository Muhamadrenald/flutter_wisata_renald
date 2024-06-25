part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  //addPaymentMethod
  const factory OrderEvent.addPaymentMethod(
    String paymentMethod,
    List<OrderItem> orders,
  ) = _AddPaymentMethod;

  //addNominalPayment
  const factory OrderEvent.addNominalPayment(
    int nominalPayment,
  ) = _AddNominalPayment;
}
