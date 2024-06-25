part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;
  //addCheckout
  const factory CheckoutEvent.addCheckout(Product product) = _AddCheckout;
  //removeCheckout
  const factory CheckoutEvent.removeCheckout(Product product) = _RemoveCheckout;
}