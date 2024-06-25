import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wisata_renald/data/models/response/product_response_model.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/product/product_bloc.dart';

import '../../../core/core.dart';
import '../dialogs/add_ticket_dialog.dart';
import '../models/product_model.dart';
import '../widgets/ticket_card.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    context.read<ProductBloc>().add(const ProductEvent.getProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tiket'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTicketDialog(),
              );
            },
            icon: Assets.icons.plus.svg(),
          ),
          const SpaceWidth(8.0),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          List<Product> products = state.maybeWhen(
            success: (products) => products,
            orElse: () => [],
          );
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SpaceHeight(20.0),
            itemBuilder: (context, index) => TicketCard(
              item: products[index],
            ),
          );
        },
      ),
    );
  }
}
