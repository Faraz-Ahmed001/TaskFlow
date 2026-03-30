import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../constants/enums.dart';

class ToDoDatabase {
  final _myBox = Hive.box('mybox');
  List<Task> allTasks = [];

  // Load data from Hive
  void loadData() {
    final data = _myBox.get("TODOLIST");

    if (data != null && data is List) {
      allTasks = data.map((item) {
        // Check if it's the old format (List with [title, isCompleted])
        if (item is List) {
          // Convert old format to new Task model
          return Task(
            id:
                DateTime.now().millisecondsSinceEpoch.toString() +
                item[0].toString(),
            title: item[0].toString(),
            isCompleted: item[1] as bool,
            createdAt: DateTime.now(),
            priority: TaskPriority.medium,
            category: TaskCategory.personal,
          );
        } else if (item is Map) {
          // New format - convert Map to Task
          return Task.fromMap(item);
        } else {
          // Fallback - create default task
          return Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Unknown Task',
            createdAt: DateTime.now(),
          );
        }
      }).toList();
    } else {
      // No data exists - create empty list
      allTasks = [];
    }
  }

  // Create initial data (first time app launch)
  void createInitialData() {
    allTasks = [
      Task(
        id: '1',
        title: 'Welcome to your To Do App!',
        notes: 'Tap to mark as complete',
        isCompleted: false,
        priority: TaskPriority.high,
        category: TaskCategory.personal,
        createdAt: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Try adding a new task',
        notes: 'Use the + button below',
        isCompleted: false,
        priority: TaskPriority.medium,
        category: TaskCategory.personal,
        createdAt: DateTime.now(),
      ),
    ];
    updateDatabase();
  }

  // Update database
  void updateDatabase() {
    final taskMaps = allTasks.map((task) => task.toMap()).toList();
    _myBox.put("TODOLIST", taskMaps);
  }

  // Add new task
  void addTask(Task task) {
    allTasks.add(task);
    updateDatabase();
  }

  // Update existing task
  void updateTask(String taskId, Task updatedTask) {
    final index = allTasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      allTasks[index] = updatedTask;
      updateDatabase();
    }
  }

  // Delete task
  void deleteTask(String taskId) {
    allTasks.removeWhere((task) => task.id == taskId);
    updateDatabase();
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    final index = allTasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = allTasks[index];
      allTasks[index] = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      );
      updateDatabase();
    }
  }

  // Get task by ID
  Task? getTaskById(String taskId) {
    try {
      return allTasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  // Get all tasks
  List<Task> getAllTasks() {
    return List.from(allTasks);
  }

  // Get completed tasks
  List<Task> getCompletedTasks() {
    return allTasks.where((task) => task.isCompleted).toList();
  }

  // Get pending tasks
  List<Task> getPendingTasks() {
    return allTasks.where((task) => !task.isCompleted).toList();
  }

  // Get overdue tasks
  List<Task> getOverdueTasks() {
    return allTasks.where((task) => task.isOverdue).toList();
  }

  // Get tasks by category
  List<Task> getTasksByCategory(TaskCategory category) {
    return allTasks.where((task) => task.category == category).toList();
  }

  // Get tasks by priority
  List<Task> getTasksByPriority(TaskPriority priority) {
    return allTasks.where((task) => task.priority == priority).toList();
  }

  // Search tasks
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return getAllTasks();

    final lowerQuery = query.toLowerCase();
    return allTasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery) ||
          task.notes.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter tasks
  List<Task> filterTasks({
    TaskFilterStatus? status,
    List<TaskPriority>? priorities,
    List<TaskCategory>? categories,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    List<Task> filtered = List.from(allTasks);

    // Filter by status
    if (status != null) {
      switch (status) {
        case TaskFilterStatus.completed:
          filtered = filtered.where((task) => task.isCompleted).toList();
          break;
        case TaskFilterStatus.pending:
          filtered = filtered.where((task) => !task.isCompleted).toList();
          break;
        case TaskFilterStatus.overdue:
          filtered = filtered.where((task) => task.isOverdue).toList();
          break;
        case TaskFilterStatus.all:
          break;
      }
    }

    // Filter by priorities
    if (priorities != null && priorities.isNotEmpty) {
      filtered = filtered
          .where((task) => priorities.contains(task.priority))
          .toList();
    }

    // Filter by categories
    if (categories != null && categories.isNotEmpty) {
      filtered = filtered
          .where((task) => categories.contains(task.category))
          .toList();
    }

    // Filter by date range
    if (startDate != null) {
      filtered = filtered
          .where(
            (task) =>
                task.createdAt.isAfter(startDate) ||
                task.createdAt.isAtSameMomentAs(startDate),
          )
          .toList();
    }
    if (endDate != null) {
      filtered = filtered
          .where(
            (task) =>
                task.createdAt.isBefore(endDate) ||
                task.createdAt.isAtSameMomentAs(endDate),
          )
          .toList();
    }

    return filtered;
  }

  // Sort tasks
  List<Task> sortTasks(List<Task> tasks, TaskSortOption sortOption) {
    final sortedTasks = List<Task>.from(tasks);

    switch (sortOption) {
      case TaskSortOption.dateCreated:
        sortedTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;

      case TaskSortOption.dueDate:
        sortedTasks.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;

      case TaskSortOption.priority:
        sortedTasks.sort(
          (a, b) => b.priority.value.compareTo(a.priority.value),
        );
        break;

      case TaskSortOption.alphabetical:
        sortedTasks.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;

      case TaskSortOption.category:
        sortedTasks.sort(
          (a, b) => a.category.index.compareTo(b.category.index),
        );
        break;
    }

    return sortedTasks;
  }

  // Get statistics
  Map<String, dynamic> getStatistics() {
    final total = allTasks.length;
    final completed = getCompletedTasks().length;
    final pending = getPendingTasks().length;
    final overdue = getOverdueTasks().length;

    final completionRate = total > 0
        ? (completed / total * 100).toStringAsFixed(1)
        : '0.0';

    // Tasks by category
    final Map<TaskCategory, int> tasksByCategory = {};
    for (var category in TaskCategory.values) {
      tasksByCategory[category] = getTasksByCategory(category).length;
    }

    // Tasks by priority
    final Map<TaskPriority, int> tasksByPriority = {};
    for (var priority in TaskPriority.values) {
      tasksByPriority[priority] = getTasksByPriority(priority).length;
    }

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'overdue': overdue,
      'completionRate': completionRate,
      'tasksByCategory': tasksByCategory,
      'tasksByPriority': tasksByPriority,
    };
  }

  // Delete all completed tasks
  void deleteAllCompletedTasks() {
    allTasks.removeWhere((task) => task.isCompleted);
    updateDatabase();
  }

  // Delete all tasks
  void deleteAllTasks() {
    allTasks.clear();
    updateDatabase();
  }

  // Get tasks due today
  List<Task> getTasksDueToday() {
    return allTasks.where((task) => task.isDueToday).toList();
  }

  // Get tasks due tomorrow
  List<Task> getTasksDueTomorrow() {
    return allTasks.where((task) => task.isDueTomorrow).toList();
  }

  // Get tasks due this week
  List<Task> getTasksDueThisWeek() {
    final now = DateTime.now();
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));

    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isBefore(endOfWeek) && task.dueDate!.isAfter(now);
    }).toList();
  }
}
