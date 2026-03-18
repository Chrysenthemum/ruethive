import 'package:flutter/material.dart';

class ToggleSwitch extends StatelessWidget {
  final bool isLeftSelected;
  final String leftLabel;
  final String rightLabel;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({
    super.key,
    required this.isLeftSelected,
    required this.leftLabel,
    required this.rightLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(context, leftLabel, true),
          _buildOption(context, rightLabel, false),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, bool left) {
    final selected = isLeftSelected == left;

    return GestureDetector(
      onTap: () => onChanged(left),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
