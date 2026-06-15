import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';

enum TaskStatus { todo, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime? deadline;
  final IconData? subtitleIcon;
  final Color? subtitleColor;
  final String? tagLabel;
  final String priorityLabel;
  final Color priorityColor;
  final Color leftBorderColor;
  final bool hasAvatars;
  final String? goalId;
  TaskStatus status;
  final DateTime? createdAt;

  TaskModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.deadline,
    this.subtitleIcon,
    this.subtitleColor,
    this.tagLabel,
    required this.priorityLabel,
    required this.priorityColor,
    required this.leftBorderColor,
    this.hasAvatars = false,
    this.goalId,
    this.status = TaskStatus.todo,
    this.createdAt,
  });

  // Convert to Firestore Map (Schema)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'tagLabel': tagLabel,
      'status': status.name,
      'hasAvatars': hasAvatars,
      'priorityLabel': priorityLabel,
      'goalId': goalId,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  // Read from Firestore Document (Schema)
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    String pLabel = data['priorityLabel'] ?? 'Q4';
    Color pColor = Colors.grey.shade400;
    Color lBorderColor = Colors.grey.shade300;

    if (pLabel == 'Q1') {
      pColor = Colors.red.shade600;
      lBorderColor = Colors.red.shade700;
    } else if (pLabel == 'Q2') {
      pColor = AppColors.primary;
      lBorderColor = AppColors.primary;
    } else if (pLabel == 'Q3') {
      pColor = Colors.grey.shade600;
      lBorderColor = Colors.grey.shade400;
    }

    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'],
      deadline: data['deadline'] != null ? (data['deadline'] as Timestamp).toDate() : null,
      subtitleIcon: (data['deadline'] != null || (data['subtitle'] != null && data['subtitle'].toString().isNotEmpty)) 
          ? Icons.calendar_today_outlined 
          : null,
      subtitleColor: AppColors.neutral,
      tagLabel: data['tagLabel'],
      priorityLabel: pLabel,
      priorityColor: pColor,
      leftBorderColor: lBorderColor,
      hasAvatars: data['hasAvatars'] ?? false,
      goalId: data['goalId'],
      status: TaskStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TaskStatus.todo,
      ),
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
    );
  }

  // Helper factory for creating new tasks dynamically from scores
  factory TaskModel.create({
    required String title,
    String? description,
    DateTime? deadline,
    required double urgency,
    required double importance,
    String? goalId,
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
      id: UniqueKey().toString(), // Will be overridden by Firestore ID
      title: title,
      subtitle: description, // Use subtitle for general description if any
      deadline: deadline,
      subtitleIcon: deadline != null ? Icons.calendar_today_outlined : null,
      subtitleColor: AppColors.neutral,
      priorityLabel: pLabel,
      priorityColor: pColor,
      leftBorderColor: lBorderColor,
      goalId: goalId,
      status: TaskStatus.todo, // Default
      createdAt: DateTime.now(), // Fallback for local creation
    );
  }
}
