import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    // Pre-populate with the mock items from TasksScreen
    TaskModel(
      id: '1',
      title: 'Finalize Q3 Marketing Strategy Presentation',
      subtitle: 'H-1',
      subtitleIcon: Icons.access_time,
      subtitleColor: Colors.red.shade700,
      tagLabel: 'Work',
      priorityLabel: 'Q1',
      priorityColor: Colors.red.shade600,
      leftBorderColor: Colors.red.shade700,
      status: TaskStatus.todo,
    ),
    TaskModel(
      id: '2',
      title: 'Draft Budget Proposal for Next Year',
      subtitle: 'Oct 24',
      subtitleIcon: Icons.calendar_today_outlined,
      subtitleColor: AppColors.neutral,
      priorityLabel: 'Q2',
      priorityColor: AppColors.primary,
      leftBorderColor: Colors.red.shade700,
      status: TaskStatus.todo,
    ),
    TaskModel(
      id: '3',
      title: 'Resolve Critical Server Outage',
      subtitle: '3h ago',
      subtitleIcon: Icons.warning_amber_rounded,
      subtitleColor: Colors.red.shade700,
      priorityLabel: '', // No tag
      priorityColor: Colors.transparent,
      leftBorderColor: Colors.red.shade700,
      hasAvatars: true,
      status: TaskStatus.inProgress, // This is mock for In Progress
    ),
    TaskModel(
      id: '4',
      title: 'Review applicant resumes for Design Lead',
      subtitle: '',
      priorityLabel: '',
      priorityColor: Colors.transparent,
      leftBorderColor: Colors.grey.shade300,
      status: TaskStatus.done,
    ),
  ];

  List<TaskModel> get todoTasks => _tasks.where((t) => t.status == TaskStatus.todo).toList();
  List<TaskModel> get inProgressTasks => _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<TaskModel> get doneTasks => _tasks.where((t) => t.status == TaskStatus.done).toList();

  void addTask(TaskModel task) {
    _tasks.insert(0, task); // Add to the top
    notifyListeners();
  }

  void updateTaskStatus(String id, TaskStatus newStatus) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].status = newStatus;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
