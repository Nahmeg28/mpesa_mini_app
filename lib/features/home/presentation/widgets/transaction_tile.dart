import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currency,
  });

  final Transaction transaction;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final credit = transaction.isCredit;
    final accent = credit ? AppColors.positive : AppColors.ink;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(_iconFor(transaction.kind), size: 20, color: accent),
          ),
          const SizedBox(width: AppSpacing.md - AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  transaction.counterparty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.title} · ${formatTimestamp(transaction.timestamp)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${credit ? '+' : '-'} ${formatMoney(transaction.amount, currency)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(TransactionKind kind) => switch (kind) {
  TransactionKind.sent => Iconsax.send_2,
  TransactionKind.received => Iconsax.money_recive,
  TransactionKind.airtime => Iconsax.mobile,
  TransactionKind.bill => Iconsax.receipt_item,
};
