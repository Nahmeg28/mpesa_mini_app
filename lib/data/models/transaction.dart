enum TransactionKind { sent, received, airtime, bill }

class Transaction {
  const Transaction({
    required this.id,
    required this.title,
    required this.counterparty,
    required this.amount,
    required this.timestamp,
    required this.kind,
  });

  final String id;
  final String title;
  final String counterparty;
  final double amount;
  final DateTime timestamp;
  final TransactionKind kind;

  bool get isCredit => kind == TransactionKind.received;
}
