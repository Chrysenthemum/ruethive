import 'package:flutter/material.dart';
import '../state/role_provider.dart';

class RoleColors {
  static Color primary(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.cr:
        return Colors.lightGreen;
      case UserRole.admin:
        return Colors.purpleAccent;
    }
  }
}