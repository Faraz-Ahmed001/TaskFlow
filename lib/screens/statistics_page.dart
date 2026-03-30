import 'package:flutter/material.dart';
import '../database/database.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../widgets/stats/progress_chart.dart';
import '../widgets/stats/stats_card.dart';
import '../widgets/stats/category_breakdown.dart';

class StatisticsPage extends StatefulWidget {
  final ToDoDatabase database;

  const StatisticsPage({super.key, required this.database});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    final stats = widget.database.getStatistics();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.statistics,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Chart
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ProgressChart(
                    totalTasks: stats['total'],
                    completedTasks: stats['completed'],
                    pendingTasks: stats['pending'],
                    overdueTasks: stats['overdue'],
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _LegendItem(
                        color: AppColors.completed,
                        label: 'Completed',
                      ),
                      _LegendItem(color: AppColors.pending, label: 'Pending'),
                      _LegendItem(color: AppColors.overdue, label: 'Overdue'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stats Card
            StatsCard(
              totalTasks: stats['total'],
              completedTasks: stats['completed'],
              pendingTasks: stats['pending'],
              overdueTasks: stats['overdue'],
              completionRate: stats['completionRate'],
            ),
            const SizedBox(height: 16),

            // Category Breakdown
            CategoryBreakdown(tasksByCategory: stats['tasksByCategory']),
            const SizedBox(height: 16),

            // Priority Breakdown
            PriorityBreakdown(tasksByPriority: stats['tasksByPriority']),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
