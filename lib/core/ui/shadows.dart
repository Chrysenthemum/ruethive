import 'package:flutter/material.dart';

class AppShadows {
  static const card = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const floating = BoxShadow(
    color: Color(0x22000000),
    blurRadius: 20,
    offset: Offset(0, 8),
  );

  // Optional: Add a subtle shadow for selected chips
  static const subtle = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );
}