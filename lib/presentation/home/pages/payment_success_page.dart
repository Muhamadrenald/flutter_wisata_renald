import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter_wisata_renald/data/dataoutputs/transaction_print.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/checkout/models/order_model.dart';
import 'package:flutter_wisata_renald/presentation/home/main_page.dart';

import '../../../core/core.dart';

class PaymentSuccessPage extends StatefulWidget {
  final OrderModel order;
  const PaymentSuccessPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Payment Reciept',
          style: TextStyle(color: AppColors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            context.pushReplacement(const MainPage());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.images.back.image(color: AppColors.white),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: context.deviceHeight / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.0),
              ),
              color: AppColors.primary,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.receiptCard.provider(),
                alignment: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                children: [
                  const Text(
                    'PAYMENT RECIEPT',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  QrImageView(
                    data: widget.order.cashierId.toString() +
                        '#' +
                        widget.order.transactionTime,
                    version: QrVersions.auto,
                  ),
                  const SpaceHeight(16.0),
                  const Text('Scan this QR code to verify tickets'),
                  const SpaceHeight(20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tagihan'),
                      Text(widget.order.totalPrice.currencyFormatRp),
                    ],
                  ),
                  const SpaceHeight(40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Bayar'),
                      Text(widget.order.paymentMethod),
                    ],
                  ),
                  const SpaceHeight(8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Waktu'),
                      Text(DateTime.now().toFormattedDate()),
                    ],
                  ),
                  const SpaceHeight(8.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Status'),
                      Text('Lunas'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(36, 0, 36, 20),
        child: Button.filled(
          onPressed: () async {
            final printData = await TransactionPrint.instance.printQRCode(
                widget.order.id.toString() + widget.order.transactionTime);
            await PrintBluetoothThermal.writeBytes(printData);
            context.read<CheckoutBloc>().add(const CheckoutEvent.started());
            context.pushReplacement(const MainPage());
          },
          label: 'Cetak Transaksi',
          borderRadius: 10.0,
        ),
      ),
    );
  }
}
