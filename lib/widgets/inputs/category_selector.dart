import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

class CategorySelector extends StatefulWidget {
  final TaskCategory selectedCategory;
  final Function(TaskCategory) onCategoryChanged;
  final bool showLabel;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.showLabel = true,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late TaskCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            final color = AppColors.getCategoryColor(category);

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                widget.onCategoryChanged(category);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color, width: isSelected ? 2 : 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(category.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      category.displayName,
                      style: TextStyle(
                        color: isSelected ? Colors.white : color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Grid version of category selector
class CategoryGridSelector extends StatefulWidget {
  final TaskCategory selectedCategory;
  final Function(TaskCategory) onCategoryChanged;

  const CategoryGridSelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryGridSelector> createState() => _CategoryGridSelectorState();
}

class _CategoryGridSelectorState extends State<CategoryGridSelector> {
  late TaskCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: TaskCategory.values.length,
      itemBuilder: (context, index) {
        final category = TaskCategory.values[index];
        final isSelected = _selectedCategory == category;
        final color = AppColors.getCategoryColor(category);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategory = category;
            });
            widget.onCategoryChanged(category);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: isSelected ? 2 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text(
                  category.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
