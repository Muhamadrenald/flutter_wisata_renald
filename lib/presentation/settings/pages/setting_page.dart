import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wisata_renald/core/core.dart';
import 'package:flutter_wisata_renald/data/datasources/product_local_datasource.dart';
import 'package:flutter_wisata_renald/presentation/auth/login_page.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/sync_order/sync_order_bloc.dart';

import '../widgets/setting_button.dart';
import 'setting_printer_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(24.0),
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 24.0,
        children: [
          SettingButton(
            iconPath: Assets.icons.settings.printer.path,
            title: 'Printer',
            subtitle: 'kelola printer',
            onPressed: () {
              context.push(const SettingPrinterPage());
            },
          ),
          // SettingButton(
          //   iconPath: Assets.icons.settings.logout.path,
          //   title: 'Logout',
          //   subtitle: 'keluar dari aplikasi',
          //   onPressed: () {
          //     // showDialog(
          //     //   context: context,
          //     //   builder: (context) => const LogoutTicketDialog(),
          //     // );
          //   },
          // ),
          SettingButton(
            iconPath: Assets.icons.settings.logout.path,
            title: 'Logout',
            subtitle: 'keluar dari aplikasi',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Konfirmasi Logout'),
                  content: Text('Apakah Anda yakin ingin logout?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                      },
                    ),
                    TextButton(
                      child: Text('Logout'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) {
              state.maybeWhen(
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                success: (categories) {
                  ProductLocalDatasource.instance.removeAllCategory();
                  ProductLocalDatasource.instance.insertAllCategory(categories);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sync Category Success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Categories',
                    subtitle: 'sinkronasi online',
                    onPressed: () {
                      context
                          .read<CategoryBloc>()
                          .add(const CategoryEvent.fetch());
                    },
                  );
                },
              );
            },
          ),
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              state.maybeWhen(
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                success: (products) {
                  ProductLocalDatasource.instance.removeAllProduct();
                  ProductLocalDatasource.instance.insertAllProduct(products);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sync Product Success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Product',
                    subtitle: 'sinkronasi online',
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const ProductEvent.getProducts());
                    },
                  );
                },
              );
            },
          ),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeWhen(
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                success: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Sync Order Success'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                orElse: () {
                  return SettingButton(
                    iconPath: Assets.icons.settings.syncData.path,
                    title: 'Sync Orders',
                    subtitle: 'sinkronasi online',
                    onPressed: () {
                      context
                          .read<SyncOrderBloc>()
                          .add(const SyncOrderEvent.syncOrder());
                    },
                  );
                },
              );
            },
          ),
          SettingButton(
            iconPath: Assets.icons.settings.syncData.path,
            title: 'Server Key',
            subtitle: 'input server key',
            onPressed: () {
              // context.push(const SaveServerKeyPage());
            },
          ),
        ],
      ),
    );
  }
}
