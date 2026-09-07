import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/application/auth_controller.dart';
import '../application/home_controller.dart';
import 'widgets/balance_card.dart';
import 'widgets/greeting_bar.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/transaction_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) return const Scaffold();

    final transactions = ref.watch(recentTransactionsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _announce(context, 'Scan to pay'),
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Iconsax.scan_barcode, size: 28),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            GreetingBar(
              user: user,
              onSignOut: ref.read(authControllerProvider.notifier).signOut,
            ),
            const SizedBox(height: AppSpacing.lg),
            BalanceCard(user: user),
            const SizedBox(height: AppSpacing.lg),
            QuickActionsGrid(
              onSelected: (action) => _announce(context, action.label),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent activity',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _announce(context, 'Full statement'),
                  child: const Text('See all'),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Column(
                children: [
                  for (final (index, transaction) in transactions.indexed) ...[
                    if (index > 0) const Divider(),
                    TransactionTile(
                      transaction: transaction,
                      currency: user.currency,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _announce(BuildContext context, String label) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$label is not part of this build.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
