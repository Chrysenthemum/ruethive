import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/state/role_provider.dart';
import '../../core/state/theme_provider.dart';
import '../../core/state/notification_provider.dart';
import '../../core/ui/spacing.dart';
import '../../core/ui/shadows.dart';

class ProfileSettingsCard extends ConsumerWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = ref.watch(isDarkModeProvider);
    final notifSettings = ref.watch(notificationProvider).settings;
    final notifNotifier = ref.read(notificationProvider.notifier);
    final userRole = ref.watch(roleProvider);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [AppShadows.card],
      ),
      child: Column(
        children: [
          // ── Card header ─────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Settings & Preferences',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                // ── Appearance ──────────────────────────────
                _ToggleRow(
                  icon: Icons.wb_sunny_outlined,
                  iconColor: const Color(0xFFFFA726),
                  title: 'Appearance',
                  subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
                  value: !isDarkMode,
                  onChanged: (_) =>
                      ref.read(themeProvider.notifier).toggleTheme(),
                  colorScheme: colorScheme,
                ),
                Divider(
                  height: AppSpacing.lg,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),

                // ── Notifications master ─────────────────────
                _ToggleRow(
                  icon: Icons.notifications_outlined,
                  iconColor: const Color(0xFF1E88E5),
                  title: 'Notifications',
                  subtitle: notifSettings.enabled
                      ? 'Push alerts enabled'
                      : 'All notifications off',
                  value: notifSettings.enabled,
                  onChanged: (v) => notifNotifier.toggleAll(v),
                  colorScheme: colorScheme,
                ),

                // ── Per-type sub-toggles (animated expand) ───
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: notifSettings.enabled
                      ? Column(
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      _SubToggleRow(
                        icon: Icons.event_note_rounded,
                        iconColor: const Color(0xFF1E88E5),
                        title: 'New Schedules',
                        value: notifSettings.newSchedules,
                        onChanged: notifNotifier.toggleNewSchedules,
                        colorScheme: colorScheme,
                      ),
                      _SubToggleRow(
                        icon: Icons.warning_rounded,
                        iconColor: const Color(0xFFEF5350),
                        title: 'Urgent Notices',
                        value: notifSettings.urgentNotices,
                        onChanged: notifNotifier.toggleUrgentNotices,
                        colorScheme: colorScheme,
                      ),
                      _SubToggleRow(
                        icon: Icons.campaign_rounded,
                        iconColor: const Color(0xFFFF9800),
                        title: 'Department Notices',
                        value: notifSettings.departmentNotices,
                        onChanged:
                        notifNotifier.toggleDepartmentNotices,
                        colorScheme: colorScheme,
                      ),
                      if (userRole == UserRole.cr ||
                          userRole == UserRole.admin)
                        _SubToggleRow(
                          icon: Icons.verified_rounded,
                          iconColor: const Color(0xFF4CAF50),
                          title: 'CR Approval Updates',
                          value: notifSettings.crApprovalUpdates,
                          onChanged:
                          notifNotifier.toggleCRApprovalUpdates,
                          colorScheme: colorScheme,
                        ),
                    ],
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toggle row ───────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface)),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12, color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        _AnimatedToggle(
            value: value, onChanged: onChanged, colorScheme: colorScheme),
      ],
    );
  }
}

// ── Sub-toggle row (indented) ────────────────────────────────────
class _SubToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const _SubToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 14, color: colorScheme.onSurface)),
          ),
          _AnimatedToggle(
              value: value,
              onChanged: onChanged,
              colorScheme: colorScheme),
        ],
      ),
    );
  }
}

// ── Shared animated toggle pill ──────────────────────────────────
class _AnimatedToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme colorScheme;

  const _AnimatedToggle({
    required this.value,
    required this.onChanged,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color:
          value ? colorScheme.primary : colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment:
          value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
