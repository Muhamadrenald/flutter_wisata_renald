import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wisata_renald/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/datasources/category_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/datasources/order_remote_datasource.dart';
import 'package:flutter_wisata_renald/data/datasources/product_remote_datasource.dart';
import 'package:flutter_wisata_renald/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/history/history_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/order/order_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/qris/qris_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/qris_status/qris_status_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/sync_order/sync_order_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/core.dart';
import 'data/datasources/product_local_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
              ProductRemoteDatasource(), ProductLocalDatasource.instance)
            ..add(ProductEvent.syncProduct()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => QrisStatusBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(CategoryRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          dialogTheme: const DialogTheme(elevation: 0),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: AppColors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: const IconThemeData(
              color: AppColors.black,
            ),
            centerTitle: true,
          ),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
