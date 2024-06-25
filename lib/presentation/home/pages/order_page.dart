import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/pages/order_detail_page.dart';

import '../../../core/core.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductEvent.getLocalProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan Ticket'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          final products = state.maybeWhen(
            success: (products) => products,
            orElse: () => [],
          );
          if (products.isEmpty) {
            return const Center(
              child: Text('No Data'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SpaceHeight(20.0),
            itemBuilder: (context, index) => OrderCard(
              item: products[index],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Order Summary'),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        success: (checkout) {
                          final total = checkout.fold<int>(
                            0,
                            (previousValue, element) =>
                                previousValue +
                                element.product.price! * element.quantity,
                          );
                          return Text(
                            total.currencyFormatRp,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          );
                        },
                        orElse: () => const Text(
                          '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      );
                      // return Text(
                      //   40000.currencyFormatRp,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16.0,
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Button.filled(
                height: 48,
                width: 120,
                onPressed: () {
                  context.push(const OrderDetailPage());
                },
                label: 'Process',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
