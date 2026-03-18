import 'package:flutter/material.dart';
import '../core/ui/animations.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        NavigationDestination(
          icon: AnimatedNavIcon(icon: Icons.dashboard_rounded,   isSelected: currentIndex == 0),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: AnimatedNavIcon(icon: Icons.event_note_rounded,  isSelected: currentIndex == 1),
          label: 'Schedule',
        ),
        NavigationDestination(
          icon: AnimatedNavIcon(icon: Icons.notifications_rounded, isSelected: currentIndex == 2),
          label: 'Notices',
        ),
        NavigationDestination(
          icon: AnimatedNavIcon(icon: Icons.person_rounded,      isSelected: currentIndex == 3),
          label: 'Profile',
        ),
      ],
    );
  }
}
