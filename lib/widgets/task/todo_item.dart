// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/task_model.dart';
import '../../constants/colors.dart';
import 'priority_badge.dart';
import 'category_chip.dart';
import 'due_date_display.dart';

class ToDoItem extends StatefulWidget {
  final Task task;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ToDoItem({
    super.key,
    required this.task,
    this.onChanged,
    this.onDelete,
    this.onTap,
    this.onEdit,
  });

  @override
  State<ToDoItem> createState() => _ToDoItemState();
}

class _ToDoItemState extends State<ToDoItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            if (widget.onEdit != null)
              SlidableAction(
                onPressed: (context) => widget.onEdit?.call(),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
                borderRadius: BorderRadius.circular(12),
              ),
            if (widget.onDelete != null)
              SlidableAction(
                onPressed: widget.onDelete,
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: BorderRadius.circular(12),
              ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else {
              _toggleExpanded();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: widget.task.isCompleted
                  ? AppColors.completed.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.task.isOverdue && !widget.task.isCompleted
                    ? AppColors.overdue.withOpacity(0.3)
                    : AppColors.border,
                width: widget.task.isOverdue && !widget.task.isCompleted
                    ? 2
                    : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Main Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Row with Checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              value: widget.task.isCompleted,
                              onChanged: widget.onChanged,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              activeColor: AppColors.completed,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Title and Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Task Title
                                Text(
                                  widget.task.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: widget.task.isCompleted
                                        ? AppColors.textSecondary
                                        : AppColors.textPrimary,
                                    decoration: widget.task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Tags Row
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    PriorityBadge(
                                      priority: widget.task.priority,
                                      showLabel: true,
                                    ),
                                    CategoryChip(
                                      category: widget.task.category,
                                      isCompact: true,
                                    ),
                                    if (widget.task.dueDate != null)
                                      DueDateDisplay(
                                        dueDate: widget.task.dueDate,
                                        isCompleted: widget.task.isCompleted,
                                        isCompact: true,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Expand Icon
                          if (widget.task.notes.isNotEmpty ||
                              widget.onEdit != null)
                            IconButton(
                              icon: AnimatedRotation(
                                turns: _isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(Icons.keyboard_arrow_down),
                              ),
                              onPressed: _toggleExpanded,
                              iconSize: 24,
                              color: AppColors.textSecondary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Expanded Section
                SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        // Notes Section
                        if (widget.task.notes.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.notes,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.task.notes,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        // Created Date
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Created ${_getTimeAgo(widget.task.createdAt)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (widget.task.completedAt != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.completed,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Completed ${_getTimeAgo(widget.task.completedAt!)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.completed,
                                ),
                              ),
                            ],
                          ),
                        ],
                        // Action Buttons
                        if (widget.onEdit != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: widget.onEdit,
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Edit Task'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
