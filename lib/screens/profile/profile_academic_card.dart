import 'package:flutter/material.dart';
import '../../core/state/role_provider.dart';
import '../../core/ui/spacing.dart';
import '../../core/ui/shadows.dart';

class ProfileAcademicCard extends StatelessWidget {
  final String department;
  final String batch;
  final String section;
  final UserRole userRole;

  const ProfileAcademicCard({
    super.key,
    required this.department,
    required this.batch,
    required this.section,
    required this.userRole,
  });

  String get _roleLabel {
    switch (userRole) {
      case UserRole.student:
        return 'Student';
      case UserRole.cr:
        return 'Class Representative';
      case UserRole.admin:
        return 'Admin';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          //  Card header --------------
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.school_outlined,
                    size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Academic Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          //  Rows -----------
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _AcademicRow(label: 'Department', value: department,
                    colorScheme: colorScheme),
                _divider(colorScheme),
                _AcademicRow(label: 'Batch', value: batch,
                    colorScheme: colorScheme),
                _divider(colorScheme),
                _AcademicRow(label: 'Section', value: section,
                    colorScheme: colorScheme),
                _divider(colorScheme),

                // Role badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Role:',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm + AppSpacing.xs,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _roleLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
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
    );
  }

  Widget _divider(ColorScheme colorScheme) => Divider(
    height: AppSpacing.lg,
    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
  );
}

class _AcademicRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _AcademicRow({
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
