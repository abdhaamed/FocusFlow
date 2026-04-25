// ASSIGNED TO: Hamid
// TODO(Hamid): Implement JSON serialization and more complex logic if needed.

class TaskItem {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> tags;
  final String? dueDate;
  final String? quadrant;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.tags = const [],
    this.dueDate,
    this.quadrant,
    this.isCompleted = false,
  });
}
