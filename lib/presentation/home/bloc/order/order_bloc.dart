import 'package:bloc/bloc.dart';
import 'package:flutter_wisata_renald/data/datasources/auth_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../checkout/models/order_item.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Success([], 0, 0, 0, '', 0, '')) {
    on<_AddPaymentMethod>((event, emit) async {
      emit(const _Loading());
      final userData = await AuthLocalDatasource().getAuthData();
      emit(_Success(
        event.orders,
        event.orders.fold(
            0, (previousValue, element) => previousValue + element.quantity),
        event.orders.fold(
            0,
            (previousValue, element) =>
                previousValue + (element.quantity * element.product.price!)),
        0,
        event.paymentMethod,
        userData.user!.id!,
        userData.user!.name!,
      ));
    });

    on<_AddNominalPayment>((event, emit) async {
      var currentState = state as _Success;
      emit(const _Loading());
      emit(_Success(
        currentState.orders,
        currentState.totalQuantity,
        currentState.totalPrice,
        event.nominalPayment,
        currentState.paymentMethod,
        currentState.cashierId,
        currentState.cashierName,
      ));
    });

    on<_Started>((event, emit) async {
      emit(const _Loading());
      emit(const _Success([], 0, 0, 0, '', 0, ''));
    });
  }
}
