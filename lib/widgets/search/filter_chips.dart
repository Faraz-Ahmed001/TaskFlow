import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

class ActiveFilterChips extends StatelessWidget {
  final TaskFilterStatus? status;
  final List<TaskPriority>? priorities;
  final List<TaskCategory>? categories;
  final VoidCallback? onClearAll;
  final Function(TaskFilterStatus)? onRemoveStatus;
  final Function(TaskPriority)? onRemovePriority;
  final Function(TaskCategory)? onRemoveCategory;

  const ActiveFilterChips({
    super.key,
    this.status,
    this.priorities,
    this.categories,
    this.onClearAll,
    this.onRemoveStatus,
    this.onRemovePriority,
    this.onRemoveCategory,
  });

  bool get hasFilters =>
      status != null ||
      (priorities != null && priorities!.isNotEmpty) ||
      (categories != null && categories!.isNotEmpty);

  int get filterCount {
    int count = 0;
    if (status != null) count++;
    if (priorities != null) count += priorities!.length;
    if (categories != null) count += categories!.length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (!hasFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Active Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  filterCount.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              if (onClearAll != null)
                TextButton(
                  onPressed: onClearAll,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Status Filter Chip
              if (status != null)
                _FilterChipItem(
                  label: status!.displayName,
                  color: AppColors.primary,
                  icon: Icons.check_circle,
                  onRemove: onRemoveStatus != null
                      ? () => onRemoveStatus!(status!)
                      : null,
                ),

              // Priority Filter Chips
              if (priorities != null)
                ...priorities!.map(
                  (priority) => _FilterChipItem(
                    label: priority.displayName,
                    color: AppColors.getPriorityColor(priority),
                    icon: _getPriorityIcon(priority),
                    onRemove: onRemovePriority != null
                        ? () => onRemovePriority!(priority)
                        : null,
                  ),
                ),

              // Category Filter Chips
              if (categories != null)
                ...categories!.map(
                  (category) => _FilterChipItem(
                    label: category.displayName,
                    color: AppColors.getCategoryColor(category),
                    emoji: category.emoji,
                    onRemove: onRemoveCategory != null
                        ? () => onRemoveCategory!(category)
                        : null,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon(TaskPriority priority) {
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

class _FilterChipItem extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final String? emoji;
  final VoidCallback? onRemove;

  const _FilterChipItem({
    required this.label,
    required this.color,
    this.icon,
    this.emoji,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 14, color: color),
            ),
          ],
        ],
      ),
    );
  }
}

// Simple filter count badge
class FilterCountBadge extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const FilterCountBadge({super.key, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              '$count Filter${count > 1 ? 's' : ''} Active',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
