import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/state/notification_provider.dart';
import '../screens/notifications_screen.dart';

class NotificationBell extends ConsumerWidget {
  /// Set to true for app bars with dark/colored backgrounds (e.g. inside
  /// gradient headers) so the icon renders white instead of the theme color.
  final bool onDark;

  const NotificationBell({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = onDark ? Colors.white : colorScheme.onSurface;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const NotificationsScreen()),
          ),
          icon: Icon(
            unread > 0
                ? Icons.notifications_rounded
                : Icons.notifications_none_rounded,
            color: iconColor,
          ),
          tooltip: 'Notifications',
        ),
        // Badge
        if (unread > 0)
          Positioned(
            top: 6,
            right: 6,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: unread > 9 ? 20 : 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: onDark
                        ? colorScheme.primary
                        : colorScheme.surface,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
