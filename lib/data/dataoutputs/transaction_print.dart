import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

class TransactionPrint {
  TransactionPrint._init();

  static final TransactionPrint instance = TransactionPrint._init();

  Future<List<int>> printQRCode(String qrCodeString) async {
    List<int> bytes = [];
    // Print QR Code
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.reset();

    bytes += generator.text('WISATA KODING FLUTTER',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.text('Pembayaran QRIS',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));
    bytes += generator.feed(1);
    bytes += generator.text(
        'Tanggal : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
        styles: const PosStyles(
          bold: false,
          align: PosAlign.center,
        ));
    bytes += generator.feed(1);
    bytes += generator.qrcode(
      qrCodeString,
      size: QRSize.Size6,
      cor: QRCorrection.H,
    );

    bytes += generator.feed(1);
    bytes += generator.text('~ Terima kasih ~',
        styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.feed(3);

    return bytes;
  }
}
