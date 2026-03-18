import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/state/notification_provider.dart';
import '../widgets/loading_states.dart';
import '../core/ui/spacing.dart';
import '../core/ui/shadows.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final unread = state.unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications'),
            if (unread > 0) ...[
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$unread',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        centerTitle: false,
        actions: [
          if (!_isLoading && state.notifications.isNotEmpty) ...[
            if (unread > 0)
              TextButton(
                onPressed: () => notifier.markAllAsRead(),
                child: Text(
                  'Mark all read',
                  style: TextStyle(fontSize: 13, color: colorScheme.primary),
                ),
              ),
            IconButton(
              onPressed: () => _showClearDialog(context, notifier),
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: 'Clear all',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: NotificationListSkeleton(count: 5),
        ),
      )
          : state.notifications.isEmpty
          ? const AppEmptyState(
        icon: Icons.notifications_off_rounded,
        title: "You're all caught up!",
        subtitle: 'No notifications right now.',
      )
          : ListView.builder(
        padding:
        const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: state.notifications.length,
        itemBuilder: (context, index) {
          return _NotificationTile(
            notification: state.notifications[index],
            onTap: () => notifier
                .markAsRead(state.notifications[index].id),
            onDismiss: () => notifier.removeNotification(
                state.notifications[index].id),
          );
        },
      ),
    );
  }

  void _showClearDialog(
      BuildContext context, NotificationNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
            'Are you sure you want to remove all notifications?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              notifier.clearAll();
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// ── Individual notification tile ─────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = _styleFor(notification.type);
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: colorScheme.error,
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isUnread
                ? style.color.withValues(alpha: 0.06)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread
                  ? style.color.withValues(alpha: 0.25)
                  : colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: const [AppShadows.card],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(style.icon, color: style.color, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Unread dot
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: style.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: isUnread
                              ? colorScheme.onSurface.withValues(alpha: 0.8)
                              : colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: style.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              style.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: style.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            _timeAgo(notification.time),
                            style: TextStyle(
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Style per type ──────────────────────────────────────────
  ({IconData icon, Color color, String label}) _styleFor(NotifType type) {
    switch (type) {
      case NotifType.urgentNotice:
        return (
        icon: Icons.warning_rounded,
        color: const Color(0xFFEF5350),
        label: 'URGENT'
        );
      case NotifType.schedule:
        return (
        icon: Icons.event_note_rounded,
        color: const Color(0xFF1E88E5),
        label: 'SCHEDULE'
        );
      case NotifType.departmentNotice:
        return (
        icon: Icons.campaign_rounded,
        color: const Color(0xFFFF9800),
        label: 'NOTICE'
        );
      case NotifType.crApproval:
        return (
        icon: Icons.verified_rounded,
        color: const Color(0xFF4CAF50),
        label: 'APPROVAL'
        );
      case NotifType.general:
        return (
        icon: Icons.info_rounded,
        color: const Color(0xFF9C27B0),
        label: 'INFO'
        );
    }
  }

  // ── Relative time label ──────────────────────────────────────
  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
