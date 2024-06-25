part of 'qris_bloc.dart';

@freezed
class QrisEvent with _$QrisEvent {
  const factory QrisEvent.started() = _Started;
  const factory QrisEvent.generateQRCode(String orderId, int grossAmount) = _GenerateQRCode;
  const factory QrisEvent.checkPaymentStatus(String orderId) = _CheckPaymentStatus;
}