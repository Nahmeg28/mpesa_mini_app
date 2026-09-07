import 'package:flutter/material.dart';

abstract final class AppColors {
  static const brand = Color(0xFFC85A32);
  static const brandLight = Color(0xFFE8763F);
  static const brandDark = Color(0xFF9E4525);
  static const brandDeep = Color(0xFF6E2E14);
  static const coral = Color(0xFFFF5A5F);
  static const gold = Color(0xFFF6B26B);

  static const ink = Color(0xFF1F1A18);
  static const inkMuted = Color(0xFF7B6A64);
  static const canvas = Color(0xFFFDF1EC);
  static const outline = Color(0xFFEBD9D3);

  static const danger = Color(0xFFD64545);
  static const positive = Color(0xFF2E7D4F);

  /// Warm diagonal ramp used on the sign-in header and the balance card.
  static const brandRamp = [brandLight, brand, brandDeep];
}

const mpesaLogo = 'assests/m-pesa_logo.png';

/// Placeholder portrait for the sign-in header. The app already needs the network
/// to sign in, and [Image.network]'s errorBuilder covers the offline case.
const avatarPhotoUrl = 'https://randomuser.me/api/portraits/men/32.jpg';
