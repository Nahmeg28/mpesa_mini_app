import 'package:intl/intl.dart';

final _amount = NumberFormat('#,##0.00');
final _dayMonth = DateFormat('d MMM, HH:mm');

String formatMoney(num value, String currency) =>
    '$currency ${_amount.format(value)}';

String formatTimestamp(DateTime value) => _dayMonth.format(value);

String formatPhoneNumber(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 12 || !digits.startsWith('251')) return raw;

  return '+${digits.substring(0, 3)} ${digits.substring(3, 5)} '
      '${digits.substring(5, 8)} ${digits.substring(8)}';
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';

  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}
