import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_wisata_renald/data/datasources/auth_remote_datasource.dart';

part 'logout_bloc.freezed.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDatasource authRemoteDatasource;
  LogoutBloc(
    this.authRemoteDatasource,
  ) : super(_Initial()) {
    on<_Logout>((event, emit) async {
      emit(_Loading());
      final response = await authRemoteDatasource.logout();

      response.fold(
        (error) => emit(_Error(error)),
        (data) => emit(_Success()),
      );
    });
  }
}
