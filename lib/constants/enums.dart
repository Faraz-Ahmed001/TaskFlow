// Enums for the app

enum TaskPriority { low, medium, high }

enum TaskCategory {
  work,
  personal,
  shopping,
  health,
  education,
  finance,
  home,
  other,
}

enum TaskSortOption { dateCreated, dueDate, priority, alphabetical, category }

enum TaskFilterStatus { all, completed, pending, overdue }

// Extension methods for Priority
extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  int get value {
    switch (this) {
      case TaskPriority.low:
        return 1;
      case TaskPriority.medium:
        return 2;
      case TaskPriority.high:
        return 3;
    }
  }
}

// Extension methods for Category
extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.shopping:
        return 'Shopping';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.education:
        return 'Education';
      case TaskCategory.finance:
        return 'Finance';
      case TaskCategory.home:
        return 'Home';
      case TaskCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case TaskCategory.work:
        return '💼';
      case TaskCategory.personal:
        return '👤';
      case TaskCategory.shopping:
        return '🛒';
      case TaskCategory.health:
        return '❤️';
      case TaskCategory.education:
        return '📚';
      case TaskCategory.finance:
        return '💰';
      case TaskCategory.home:
        return '🏠';
      case TaskCategory.other:
        return '📌';
    }
  }
}

// Extension methods for Sort Option
extension TaskSortOptionExtension on TaskSortOption {
  String get displayName {
    switch (this) {
      case TaskSortOption.dateCreated:
        return 'Date Created';
      case TaskSortOption.dueDate:
        return 'Due Date';
      case TaskSortOption.priority:
        return 'Priority';
      case TaskSortOption.alphabetical:
        return 'Alphabetical';
      case TaskSortOption.category:
        return 'Category';
    }
  }
}

// Extension methods for Filter Status
extension TaskFilterStatusExtension on TaskFilterStatus {
  String get displayName {
    switch (this) {
      case TaskFilterStatus.all:
        return 'All Tasks';
      case TaskFilterStatus.completed:
        return 'Completed';
      case TaskFilterStatus.pending:
        return 'Pending';
      case TaskFilterStatus.overdue:
        return 'Overdue';
    }
  }
}
