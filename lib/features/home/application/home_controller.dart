import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/transaction.dart';

final recentTransactionsProvider = Provider<List<Transaction>>((ref) {
  final now = DateTime.now();

  return [
    Transaction(
      id: 'TX-88213',
      title: 'Sent to',
      counterparty: 'Meron Alemu',
      amount: 450,
      timestamp: now.subtract(const Duration(hours: 2)),
      kind: TransactionKind.sent,
    ),
    Transaction(
      id: 'TX-88190',
      title: 'Received from',
      counterparty: 'Dawit Bekele',
      amount: 1200,
      timestamp: now.subtract(const Duration(hours: 9)),
      kind: TransactionKind.received,
    ),
    Transaction(
      id: 'TX-88154',
      title: 'Airtime',
      counterparty: 'Safaricom Ethiopia',
      amount: 100,
      timestamp: now.subtract(const Duration(days: 1, hours: 3)),
      kind: TransactionKind.airtime,
    ),
    Transaction(
      id: 'TX-88101',
      title: 'Paid to',
      counterparty: 'Ethiopian Electric Utility',
      amount: 780.25,
      timestamp: now.subtract(const Duration(days: 2)),
      kind: TransactionKind.bill,
    ),
  ];
});
