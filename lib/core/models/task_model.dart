import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum TaskStatus { todo, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? subtitleIcon;
  final Color? subtitleColor;
  final String? tagLabel;
  final String priorityLabel;
  final Color priorityColor;
  final Color leftBorderColor;
  final bool hasAvatars;
  TaskStatus status;

  TaskModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.subtitleIcon,
    this.subtitleColor,
    this.tagLabel,
    required this.priorityLabel,
    required this.priorityColor,
    required this.leftBorderColor,
    this.hasAvatars = false,
    this.status = TaskStatus.todo,
  });

  // Helper factory for creating new tasks dynamically from scores
  factory TaskModel.create({
    required String title,
    String? description,
    String? deadline,
    required double urgency,
    required double importance,
  }) {
    String pLabel;
    Color pColor;
    Color lBorderColor;

    if (urgency >= 4 && importance >= 4) {
      pLabel = 'Q1';
      pColor = Colors.red.shade600;
      lBorderColor = Colors.red.shade700;
    } else if (urgency < 4 && importance >= 4) {
      pLabel = 'Q2';
      pColor = AppColors.primary;
      lBorderColor = AppColors.primary;
    } else if (urgency >= 4 && importance < 4) {
      pLabel = 'Q3';
      pColor = Colors.grey.shade600;
      lBorderColor = Colors.grey.shade400; // Light grey blue based on Priority Board
    } else {
      pLabel = 'Q4';
      pColor = Colors.grey.shade400;
      lBorderColor = Colors.grey.shade300;
    }

    return TaskModel(
      id: UniqueKey().toString(),
      title: title,
      subtitle: deadline,
      subtitleIcon: deadline != null && deadline.isNotEmpty ? Icons.calendar_today_outlined : null,
      subtitleColor: AppColors.neutral,
      priorityLabel: pLabel,
      priorityColor: pColor,
      leftBorderColor: lBorderColor,
      status: TaskStatus.todo, // Default
    );
  }
}
