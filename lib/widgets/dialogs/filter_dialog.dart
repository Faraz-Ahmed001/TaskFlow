// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../constants/enums.dart';

class FilterDialog extends StatefulWidget {
  final TaskFilterStatus? initialStatus;
  final List<TaskPriority>? initialPriorities;
  final List<TaskCategory>? initialCategories;
  final Function(
    TaskFilterStatus? status,
    List<TaskPriority>? priorities,
    List<TaskCategory>? categories,
  )
  onApplyFilters;

  const FilterDialog({
    super.key,
    this.initialStatus,
    this.initialPriorities,
    this.initialCategories,
    required this.onApplyFilters,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TaskFilterStatus? _selectedStatus;
  Set<TaskPriority> _selectedPriorities = {};
  Set<TaskCategory> _selectedCategories = {};

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedPriorities = widget.initialPriorities?.toSet() ?? {};
    _selectedCategories = widget.initialCategories?.toSet() ?? {};
  }

  void _applyFilters() {
    widget.onApplyFilters(
      _selectedStatus,
      _selectedPriorities.isEmpty ? null : _selectedPriorities.toList(),
      _selectedCategories.isEmpty ? null : _selectedCategories.toList(),
    );
    Navigator.of(context).pop();
  }

  void _clearFilters() {
    setState(() {
      _selectedStatus = null;
      _selectedPriorities.clear();
      _selectedCategories.clear();
    });
  }

  bool get _hasActiveFilters =>
      _selectedStatus != null ||
      _selectedPriorities.isNotEmpty ||
      _selectedCategories.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  AppStrings.filterBy,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (_hasActiveFilters)
                  TextButton(
                    onPressed: _clearFilters,
                    child: const Text(
                      AppStrings.clearFilters,
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Filter
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TaskFilterStatus.values.map((status) {
                      final isSelected = _selectedStatus == status;
                      return FilterChip(
                        label: Text(status.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedStatus = selected ? status : null;
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Priority Filter
                  const Text(
                    'Priority',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TaskPriority.values.map((priority) {
                      final isSelected = _selectedPriorities.contains(priority);
                      final color = AppColors.getPriorityColor(priority);
                      return FilterChip(
                        label: Text(priority.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPriorities.add(priority);
                            } else {
                              _selectedPriorities.remove(priority);
                            }
                          });
                        },
                        selectedColor: color.withOpacity(0.2),
                        checkmarkColor: color,
                        side: BorderSide(color: color.withOpacity(0.5)),
                        labelStyle: TextStyle(
                          color: isSelected ? color : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Category Filter
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TaskCategory.values.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      final color = AppColors.getCategoryColor(category);
                      return FilterChip(
                        avatar: Text(category.emoji),
                        label: Text(category.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        selectedColor: color.withOpacity(0.2),
                        checkmarkColor: color,
                        side: BorderSide(color: color.withOpacity(0.5)),
                        labelStyle: TextStyle(
                          color: isSelected ? color : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          // Footer Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  AppStrings.applyFilters,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
