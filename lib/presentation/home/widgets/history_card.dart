import 'package:flutter/widgets.dart';
import 'package:flutter_wisata_renald/core/extensions/String_ext.dart';
import 'package:flutter_wisata_renald/presentation/home/bloc/checkout/models/order_model.dart';
import 'package:intl/intl.dart';

import '../../../core/core.dart';

class HistoryCard extends StatelessWidget {
  final OrderModel item;
  const HistoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Assets.icons.plus.svg(),
          const SpaceWidth(10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // item.cashierName,
                item.id.toString(),
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SpaceHeight(5.0),
              Text(
                DateFormat('dd MMMM yyyy').format(DateTime(
                    item.transactionTime.substring(0, 4).toInt,
                    item.transactionTime.substring(5, 7).toInt,
                    item.transactionTime.substring(8, 10).toInt)),
                // item.transactionTime,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            item.totalPrice.currencyFormatRp,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
