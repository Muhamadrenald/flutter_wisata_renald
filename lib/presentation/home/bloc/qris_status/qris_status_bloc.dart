import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_wisata_renald/data/datasources/midtrans_remote_datasource.dart';

import '../../../../data/models/response/qris_status_response_model.dart';

part 'qris_status_bloc.freezed.dart';
part 'qris_status_event.dart';
part 'qris_status_state.dart';

class QrisStatusBloc extends Bloc<QrisStatusEvent, QrisStatusState> {
  final MidtransRemoteDatasource datasource;
  QrisStatusBloc(
    this.datasource,
  ) : super(_Initial()) {
    on<_CheckPaymentStatus>((event, emit) async {
      emit(_Loading());
      try {
        final qrisStatusResponse =
            await datasource.checkPaymentStatus(event.orderId);
        if (qrisStatusResponse.transactionStatus == 'settlement') {
          emit(QrisStatusState.success('Payment Success'));
        } else if (qrisStatusResponse.transactionStatus == 'pending') {
          emit(QrisStatusState.pending('Payment Pending'));
        }
      } catch (e) {
        emit(QrisStatusState.error(e.toString()));
      }
    });
  }
}
