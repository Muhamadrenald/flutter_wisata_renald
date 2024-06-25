part of 'qris_status_bloc.dart';

@freezed
class QrisStatusState with _$QrisStatusState {
  const factory QrisStatusState.initial() = _Initial;
  const factory QrisStatusState.loading() = _Loading;
  const factory QrisStatusState.qrisStatusResponse(QrisStatusResponseModel qrisStatusResponse) = _Loaded;
  //error
  const factory QrisStatusState.error(String message) = _Error;
  //success
  const factory QrisStatusState.success(String message) = _Success;
  //pending
  const factory QrisStatusState.pending(String message) = _Pending;
}
