import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_wisata_renald/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/models/response/qris_response_model.dart';

part 'qris_bloc.freezed.dart';
part 'qris_event.dart';
part 'qris_state.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  final MidtransRemoteDatasource datasource;
  QrisBloc(
    this.datasource,
  ) : super(_Initial()) {
    on<_GenerateQRCode>((event, emit) async {
      emit(_Loading());
      try {
        final qrisResponse =
            await datasource.generateQRCode(event.orderId, event.grossAmount);
        emit(QrisState.qrisResponse(qrisResponse));
      } catch (e) {
        emit(QrisState.error(e.toString()));
      }
    });
  }
}
