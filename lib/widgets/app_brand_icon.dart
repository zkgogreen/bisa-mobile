import 'package:flutter/material.dart';

/// AppBrandIcon
/// Widget ikon/branding aplikasi yang konsisten menggunakan aset assets/icons/icon.png
class AppBrandIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const AppBrandIcon({super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/icon.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
    );
  }
}