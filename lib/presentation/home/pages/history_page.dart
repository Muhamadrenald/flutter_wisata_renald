import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/history/history_bloc.dart';

import '../../../core/core.dart';

import '../widgets/history_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<HistoryBloc>().add(const HistoryEvent.getHistories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, List<HistoryModel>> groupedHistory = {};
    // for (var data in histories) {
    //   final monthYear =
    //       '${data.dateTime.toFormattedMonth()} ${data.dateTime.year}';
    //   if (!groupedHistory.containsKey(monthYear)) {
    //     groupedHistory[monthYear] = [];
    //   }
    //   groupedHistory[monthYear]!.add(data);
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction History'),
        ),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return state.maybeWhen(
              success: (histories) {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: List.generate(histories.length,
                      (index) => HistoryCard(item: histories[index])),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              orElse: () {
                return const Center(
                  child: Text('No Data'),
                );
              },
            );
            // return ListView(
            //   padding: const EdgeInsets.all(16.0),
            //   children: List.generate(5, (index) => HistoryCard(item: null)),
            // );
          },
        ));
  }
}
