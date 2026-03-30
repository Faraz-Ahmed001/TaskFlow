import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../utils/date_utils.dart';

class DueDateDisplay extends StatelessWidget {
  final DateTime? dueDate;
  final bool isCompleted;
  final bool showIcon;
  final bool isCompact;

  const DueDateDisplay({
    super.key,
    required this.dueDate,
    this.isCompleted = false,
    this.showIcon = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return const SizedBox.shrink();
    }

    final dateString = AppDateUtils.getDueDateDisplay(dueDate, isCompleted);
    final color = _getColor();
    final icon = _getIcon();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: isCompact ? 12 : 14, color: color),
            SizedBox(width: isCompact ? 3 : 5),
          ],
          Text(
            dateString,
            style: TextStyle(
              color: color,
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    if (isCompleted) {
      return AppColors.completed;
    }

    final now = DateTime.now();
    if (dueDate!.isBefore(now)) {
      // Overdue
      return AppColors.overdue;
    } else if (_isDueToday()) {
      // Due today
      return AppColors.pending;
    } else if (_isDueTomorrow()) {
      // Due tomorrow
      return AppColors.pending;
    } else {
      // Future date
      return AppColors.textSecondary;
    }
  }

  IconData _getIcon() {
    if (isCompleted) {
      return Icons.check_circle;
    }

    final now = DateTime.now();
    if (dueDate!.isBefore(now)) {
      return Icons.warning;
    } else if (_isDueToday()) {
      return Icons.today;
    } else if (_isDueTomorrow()) {
      return Icons.event;
    } else {
      return Icons.calendar_today;
    }
  }

  bool _isDueToday() {
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool _isDueTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate!.year == tomorrow.year &&
        dueDate!.month == tomorrow.month &&
        dueDate!.day == tomorrow.day;
  }
}

// Detailed due date widget with time
class DueDateDetailDisplay extends StatelessWidget {
  final DateTime? dueDate;
  final bool isCompleted;

  const DueDateDetailDisplay({
    super.key,
    required this.dueDate,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (dueDate == null) {
      return Row(
        children: const [
          Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
          SizedBox(width: 8),
          Text(
            'No due date',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      );
    }

    final dateString = AppDateUtils.formatDate(dueDate!);
    final timeString = AppDateUtils.formatTime(dueDate!);
    final color = _getColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              dateString,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.access_time, size: 18, color: color),
            const SizedBox(width: 8),
            Text(timeString, style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
        if (!isCompleted && dueDate!.isBefore(DateTime.now())) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.overdue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'OVERDUE',
              style: TextStyle(
                color: AppColors.overdue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getColor() {
    if (isCompleted) return AppColors.completed;
    if (dueDate!.isBefore(DateTime.now())) return AppColors.overdue;
    return AppColors.primary;
  }
}
