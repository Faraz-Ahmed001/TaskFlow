import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/enums.dart';

class PrioritySelector extends StatefulWidget {
  final TaskPriority selectedPriority;
  final Function(TaskPriority) onPriorityChanged;
  final bool showLabel;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
    this.showLabel = true,
  });

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  late TaskPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.selectedPriority;
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
              'Priority',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            final color = AppColors.getPriorityColor(priority);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPriority = priority;
                    });
                    widget.onPriorityChanged(priority);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getPriorityIcon(priority),
                          color: isSelected ? Colors.white : color,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priority.displayName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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

// Dropdown version of priority selector
class PriorityDropdown extends StatefulWidget {
  final TaskPriority selectedPriority;
  final Function(TaskPriority) onPriorityChanged;

  const PriorityDropdown({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  State<PriorityDropdown> createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  late TaskPriority _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TaskPriority>(
          value: _selectedPriority,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: TaskPriority.values.map((priority) {
            final color = AppColors.getPriorityColor(priority);
            return DropdownMenuItem<TaskPriority>(
              value: priority,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(priority.displayName),
                ],
              ),
            );
          }).toList(),
          onChanged: (TaskPriority? priority) {
            if (priority != null) {
              setState(() {
                _selectedPriority = priority;
              });
              widget.onPriorityChanged(priority);
            }
          },
        ),
      ),
    );
  }
}
