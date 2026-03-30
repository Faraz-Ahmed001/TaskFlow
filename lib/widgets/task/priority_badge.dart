// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool showLabel;
  final double size;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.showLabel = true,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getPriorityColor(priority);

    if (!showLabel) {
      // Just show colored circle
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      );
    }

    // Show label with icon
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getPriorityIcon(), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon() {
    switch (priority) {
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
    }
  }
}
