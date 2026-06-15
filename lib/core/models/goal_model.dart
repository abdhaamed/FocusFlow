import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String primaryObjective;
  final String specific;
  final String measurable;
  final String achievable;
  final String relevant;
  final DateTime? timebound;
  final bool isActive;
  final double progress;
  final DateTime? createdAt;

  GoalModel({
    required this.id,
    required this.primaryObjective,
    required this.specific,
    required this.measurable,
    required this.achievable,
    required this.relevant,
    this.timebound,
    this.isActive = true,
    this.progress = 0.0,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'primaryObjective': primaryObjective,
      'specific': specific,
      'measurable': measurable,
      'achievable': achievable,
      'relevant': relevant,
      'timebound': timebound != null ? Timestamp.fromDate(timebound!) : null,
      'isActive': isActive,
      'progress': progress,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return GoalModel(
      id: doc.id,
      primaryObjective: data['primaryObjective'] ?? '',
      specific: data['specific'] ?? '',
      measurable: data['measurable'] ?? '',
      achievable: data['achievable'] ?? '',
      relevant: data['relevant'] ?? '',
      timebound: data['timebound'] != null ? (data['timebound'] as Timestamp).toDate() : null,
      isActive: data['isActive'] ?? true,
      progress: (data['progress'] ?? 0.0).toDouble(),
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : null,
    );
  }
}
