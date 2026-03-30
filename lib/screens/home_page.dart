import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/database.dart';
import '../models/task_model.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../constants/enums.dart';
import '../widgets/task/todo_item.dart';
import '../widgets/task/empty_state_widget.dart';
import '../widgets/dialogs/add_task_dialog.dart';
import '../widgets/dialogs/edit_task_dialog.dart';
import '../widgets/dialogs/filter_dialog.dart';
import '../widgets/search/search_bar.dart';
import '../widgets/search/filter_chips.dart';
import 'statistics_page.dart';
import 'task_detail_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myBox = Hive.box('mybox');
  final ToDoDatabase db = ToDoDatabase();

  String _searchQuery = '';
  TaskFilterStatus? _filterStatus;
  List<TaskPriority>? _filterPriorities;
  List<TaskCategory>? _filterCategories;
  TaskSortOption _sortOption = TaskSortOption.dateCreated;

  @override
  void initState() {
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
  }

  List<Task> get _filteredTasks {
    List<Task> tasks = db.searchTasks(_searchQuery);

    // Apply filters
    tasks = db.filterTasks(
      status: _filterStatus,
      priorities: _filterPriorities,
      categories: _filterCategories,
    );

    // Apply sorting
    tasks = db.sortTasks(tasks, _sortOption);

    return tasks;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_filterStatus != null) count++;
    if (_filterPriorities != null && _filterPriorities!.isNotEmpty) {
      count += _filterPriorities!.length;
    }
    if (_filterCategories != null && _filterCategories!.isNotEmpty) {
      count += _filterCategories!.length;
    }
    return count;
  }

  void _addTask(Task task) {
    setState(() {
      db.addTask(task);
    });
  }

  void _updateTask(Task task) {
    setState(() {
      db.updateTask(task.id, task);
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      db.deleteTask(taskId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.taskDeleted),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      db.toggleTaskCompletion(taskId);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(onTaskAdded: _addTask),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) =>
          EditTaskDialog(task: task, onTaskUpdated: _updateTask),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterDialog(
        initialStatus: _filterStatus,
        initialPriorities: _filterPriorities,
        initialCategories: _filterCategories,
        onApplyFilters: (status, priorities, categories) {
          setState(() {
            _filterStatus = status;
            _filterPriorities = priorities;
            _filterCategories = categories;
          });
        },
      ),
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.sortBy,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ...TaskSortOption.values.map((option) {
              final isSelected = _sortOption == option;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                title: Text(
                  option.displayName,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _sortOption = option;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _navigateToStatistics() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatisticsPage(database: db)),
    );
  }

  void _navigateToTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailPage(
          task: task,
          onTaskUpdated: _updateTask,
          onTaskDeleted: () => _deleteTask(task.id),
        ),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _filterStatus = null;
      _filterPriorities = null;
      _filterCategories = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _navigateToStatistics,
            icon: const Icon(Icons.analytics, color: Colors.white),
            tooltip: AppStrings.statistics,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          TaskSearchBar(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onFilterTap: _showFilterDialog,
            onSortTap: _showSortMenu,
            activeFilterCount: _activeFilterCount,
          ),

          // Active Filter Chips
          ActiveFilterChips(
            status: _filterStatus,
            priorities: _filterPriorities,
            categories: _filterCategories,
            onClearAll: _clearFilters,
            onRemoveStatus: (status) {
              setState(() {
                _filterStatus = null;
              });
            },
            onRemovePriority: (priority) {
              setState(() {
                _filterPriorities?.remove(priority);
                if (_filterPriorities?.isEmpty ?? false) {
                  _filterPriorities = null;
                }
              });
            },
            onRemoveCategory: (category) {
              setState(() {
                _filterCategories?.remove(category);
                if (_filterCategories?.isEmpty ?? false) {
                  _filterCategories = null;
                }
              });
            },
          ),

          // Task List
          Expanded(
            child: filteredTasks.isEmpty
                ? _searchQuery.isNotEmpty || _activeFilterCount > 0
                      ? const NoSearchResultsEmptyState()
                      : NoTasksEmptyState(onAddTask: _showAddTaskDialog)
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return ToDoItem(
                        task: task,
                        onChanged: (value) => _toggleTaskCompletion(task.id),
                        onDelete: (context) => _deleteTask(task.id),
                        onEdit: () => _showEditTaskDialog(task),
                        onTap: () => _navigateToTaskDetail(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
