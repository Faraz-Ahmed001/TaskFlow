// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../constants/colors.dart';
// ignore: unused_import
import '../constants/strings.dart';
import '../utils/date_utils.dart';
import '../widgets/task/priority_badge.dart';
import '../widgets/task/category_chip.dart';
import '../widgets/task/due_date_display.dart';
import '../widgets/dialogs/edit_task_dialog.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;
  final VoidCallback onTaskDeleted;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  void _toggleCompletion() {
    setState(() {
      _currentTask = _currentTask.copyWith(
        isCompleted: !_currentTask.isCompleted,
        completedAt: !_currentTask.isCompleted ? DateTime.now() : null,
      );
    });
    widget.onTaskUpdated(_currentTask);
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: _currentTask,
        onTaskUpdated: (updatedTask) {
          setState(() {
            _currentTask = updatedTask;
          });
          widget.onTaskUpdated(updatedTask);
        },
      ),
    );
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
              widget.onTaskDeleted();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _showEditDialog,
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: _deleteTask,
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _currentTask.isCompleted
                    ? AppColors.completed.withOpacity(0.1)
                    : Colors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _currentTask.isCompleted
                          ? AppColors.completed
                          : _currentTask.isOverdue
                          ? AppColors.overdue
                          : AppColors.pending,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentTask.isCompleted
                          ? 'Completed'
                          : _currentTask.isOverdue
                          ? 'Overdue'
                          : 'Pending',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    _currentTask.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      decoration: _currentTask.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tags
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      PriorityBadge(priority: _currentTask.priority),
                      CategoryChip(category: _currentTask.category),
                      if (_currentTask.dueDate != null)
                        DueDateDisplay(
                          dueDate: _currentTask.dueDate,
                          isCompleted: _currentTask.isCompleted,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Details Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notes
                  if (_currentTask.notes.isNotEmpty) ...[
                    _SectionTitle(title: 'Notes'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        _currentTask.notes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Due Date Info
                  if (_currentTask.dueDate != null) ...[
                    _SectionTitle(title: 'Due Date'),
                    const SizedBox(height: 12),
                    DueDateDetailDisplay(
                      dueDate: _currentTask.dueDate,
                      isCompleted: _currentTask.isCompleted,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Timestamps
                  _SectionTitle(title: 'Information'),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.add_circle_outline,
                    label: 'Created',
                    value: AppDateUtils.formatDateTime(_currentTask.createdAt),
                  ),
                  if (_currentTask.completedAt != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.check_circle,
                      label: 'Completed',
                      value: AppDateUtils.formatDateTime(
                        _currentTask.completedAt!,
                      ),
                      valueColor: AppColors.completed,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _toggleCompletion,
            style: ElevatedButton.styleFrom(
              backgroundColor: _currentTask.isCompleted
                  ? AppColors.pending
                  : AppColors.completed,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentTask.isCompleted ? 'Mark as Pending' : 'Mark as Complete',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
