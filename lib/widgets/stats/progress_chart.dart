import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../constants/colors.dart';

class ProgressChart extends StatefulWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;
  final double size;

  const ProgressChart({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    this.size = 200,
  });

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completedTasks != widget.completedTasks ||
        oldWidget.totalTasks != widget.totalTasks) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final completionRate = widget.totalTasks > 0
        ? (widget.completedTasks / widget.totalTasks)
        : 0.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _ProgressChartPainter(
            completedTasks: widget.completedTasks,
            pendingTasks: widget.pendingTasks,
            overdueTasks: widget.overdueTasks,
            totalTasks: widget.totalTasks,
            animationValue: _animation.value,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(completionRate * 100 * _animation.value).toInt()}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressChartPainter extends CustomPainter {
  final int completedTasks;
  final int pendingTasks;
  final int overdueTasks;
  final int totalTasks;
  final double animationValue;

  _ProgressChartPainter({
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    required this.totalTasks,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 20.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (totalTasks == 0) return;

    double startAngle = -math.pi / 2;

    // Draw completed segment
    if (completedTasks > 0) {
      final completedSweep =
          (completedTasks / totalTasks) * 2 * math.pi * animationValue;
      final completedPaint = Paint()
        ..color = AppColors.completed
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        completedSweep,
        false,
        completedPaint,
      );
      startAngle += completedSweep;
    }

    // Draw pending segment
    if (pendingTasks > 0) {
      final pendingSweep =
          (pendingTasks / totalTasks) * 2 * math.pi * animationValue;
      final pendingPaint = Paint()
        ..color = AppColors.pending
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pendingSweep,
        false,
        pendingPaint,
      );
      startAngle += pendingSweep;
    }

    // Draw overdue segment
    if (overdueTasks > 0) {
      final overdueSweep =
          (overdueTasks / totalTasks) * 2 * math.pi * animationValue;
      final overduePaint = Paint()
        ..color = AppColors.overdue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        overdueSweep,
        false,
        overduePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressChartPainter oldDelegate) {
    return oldDelegate.completedTasks != completedTasks ||
        oldDelegate.pendingTasks != pendingTasks ||
        oldDelegate.overdueTasks != overdueTasks ||
        oldDelegate.animationValue != animationValue;
  }
}
