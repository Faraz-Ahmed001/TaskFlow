import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

class CategoryChip extends StatelessWidget {
  final TaskCategory category;
  final bool showEmoji;
  final bool isCompact;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.showEmoji = true,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getCategoryColor(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 6 : 10,
          vertical: isCompact ? 3 : 6,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showEmoji) ...[
              Text(
                category.emoji,
                style: TextStyle(fontSize: isCompact ? 12 : 14),
              ),
              SizedBox(width: isCompact ? 3 : 5),
            ],
            Text(
              category.displayName,
              style: TextStyle(
                color: color,
                fontSize: isCompact ? 11 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Multiple categories display widget
class CategoryChipsRow extends StatelessWidget {
  final List<TaskCategory> categories;
  final int maxDisplay;
  final bool showEmoji;

  const CategoryChipsRow({
    super.key,
    required this.categories,
    this.maxDisplay = 2,
    this.showEmoji = true,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    final displayCategories = categories.take(maxDisplay).toList();
    final remainingCount = categories.length - maxDisplay;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...displayCategories.map(
          (category) => CategoryChip(
            category: category,
            showEmoji: showEmoji,
            isCompact: true,
          ),
        ),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+$remainingCount',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
