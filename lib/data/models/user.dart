import '../../core/format/formatters.dart';

class User {
  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.balance,
    required this.currency,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String,
    balance: (json['balance'] as num).toDouble(),
    currency: json['currency'] as String,
  );

  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final double balance;
  final String currency;

  String get firstName => name.split(' ').first;

  String get initials => initialsOf(name);

  String get formattedPhone => formatPhoneNumber(phoneNumber);

  String get formattedBalance => formatMoney(balance, currency);
}
