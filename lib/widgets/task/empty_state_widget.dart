import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    this.title = AppStrings.noTasksYet,
    this.message = AppStrings.addFirstTask,
    this.icon = Icons.task_alt,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            // Action Button
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Specific empty state variants
class NoTasksEmptyState extends StatelessWidget {
  final VoidCallback? onAddTask;

  const NoTasksEmptyState({super.key, this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: AppStrings.noTasksYet,
      message: AppStrings.addFirstTask,
      icon: Icons.task_alt,
      onActionPressed: onAddTask,
      actionText: 'Add Your First Task',
    );
  }
}

class NoSearchResultsEmptyState extends StatelessWidget {
  const NoSearchResultsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: AppStrings.noTasksFound,
      message: AppStrings.tryAdjustingFilters,
      icon: Icons.search_off,
    );
  }
}

class NoCompletedTasksEmptyState extends StatelessWidget {
  const NoCompletedTasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: AppStrings.noCompletedTasks,
      message: 'Complete your first task to see it here',
      icon: Icons.check_circle_outline,
    );
  }
}

class NoPendingTasksEmptyState extends StatelessWidget {
  const NoPendingTasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: AppStrings.noPendingTasks,
      message: 'Great job! All tasks completed',
      icon: Icons.celebration,
    );
  }
}

class NoOverdueTasksEmptyState extends StatelessWidget {
  const NoOverdueTasksEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      title: AppStrings.noOverdueTasks,
      message: 'You\'re all caught up!',
      icon: Icons.thumb_up,
    );
  }
}
