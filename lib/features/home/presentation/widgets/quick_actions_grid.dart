import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

typedef QuickAction = ({IconData icon, String label});

const quickActions = <QuickAction>[
  (icon: Iconsax.shop, label: 'Merchant\nPayment'),
  (icon: Iconsax.receipt_item, label: 'Bill\npayment'),
  (icon: Iconsax.wallet_money, label: 'Credits and\nSavings'),
  (icon: Iconsax.arrow_swap_horizontal, label: 'Transfer\nMoney'),
  (icon: Iconsax.mobile, label: 'Airtime/\nPackage'),
  (icon: Iconsax.category, label: 'More\nServices'),
];

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key, required this.onSelected});

  final ValueChanged<QuickAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDeep.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.78,
        children: [
          for (final action in quickActions)
            _ActionTile(action: action, onTap: () => onSelected(action)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.onTap});

  final QuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold.withValues(alpha: 0.28),
                  AppColors.brand.withValues(alpha: 0.14),
                ],
              ),
            ),
            child: Icon(action.icon, color: AppColors.brandDark, size: 27),
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: Text(
              action.label,
              textAlign: .center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                height: 1.25,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
