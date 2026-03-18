import 'package:flutter/material.dart';
import '../../core/ui/spacing.dart';
import '../../core/ui/shadows.dart';

/// Floating card that overlaps the gradient header.
/// Positioned by the parent [ProfileScreen] Stack — no Transform.translate
/// needed, which makes the layout predictable on all screen sizes.
class ProfileContactCard extends StatelessWidget {
  final String email;
  final String memberSince;

  const ProfileContactCard({
    super.key,
    required this.email,
    required this.memberSince,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [AppShadows.floating],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: email,
              colorScheme: colorScheme,
            ),
            Divider(
              height: AppSpacing.lg,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            _InfoRow(
              icon: Icons.check_circle_outline,
              label: 'Status',
              value: 'Active & Verified',
              colorScheme: colorScheme,
            ),
            Divider(
              height: AppSpacing.lg,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: const Color(0xFF9C27B0),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Member since',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            memberSince,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9C27B0)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '⭐ NEW!',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9C27B0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
