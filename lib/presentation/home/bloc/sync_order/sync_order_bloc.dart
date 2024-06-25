import 'package:bloc/bloc.dart';
import 'package:flutter_wisata_renald/data/datasources/product_local_datasource.dart';
import 'package:flutter_wisata_renald/data/models/request/order_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_wisata_renald/data/datasources/order_remote_datasource.dart';
import 'package:intl/intl.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(
    this.orderRemoteDatasource,
  ) : super(_Initial()) {
    on<_SyncOrder>((event, emit) async {
      emit(_Loading());
      final orderIsSyncFalse =
          await ProductLocalDatasource.instance.getOrdersIsSyncFalse();
      for (final order in orderIsSyncFalse) {
        final orderItems = await ProductLocalDatasource.instance
            .getOrderItemsByIdOrder(order.id!);
        final transactionTimeFormatted = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.parse(order.transactionTime));

        final orderRequest = OrderRequestModel(
          cashierName: order.cashierName,
          paymentAmount: order.nominalPayment,
          transactionTime: transactionTimeFormatted,
          cashierId: order.cashierId,
          totalPrice: order.totalPrice,
          totalItem: order.totalQuantity,
          paymentMethod: order.paymentMethod,
          orderItems: orderItems,
        );

        final response = await orderRemoteDatasource.sendOrder(orderRequest);

        if (response) {
          await ProductLocalDatasource.instance.updateOrderIsSync(order.id!);
        }
      }
      emit(_Success());
    });
  }
}
