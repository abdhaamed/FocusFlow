import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _taskSubscription;

  bool get isLoading => _isLoading;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get todoTasks => _tasks.where((t) => t.status == TaskStatus.todo).toList();
  List<TaskModel> get inProgressTasks => _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<TaskModel> get doneTasks => _tasks.where((t) => t.status == TaskStatus.done).toList();

  TaskProvider() {
    // Listen to Auth State to load tasks for current user
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToTasks(user.uid);
      } else {
        _tasks = [];
        _taskSubscription?.cancel();
        notifyListeners();
      }
    });
  }

  void _subscribeToTasks(String userId) {
    _isLoading = true;
    notifyListeners();

    _taskSubscription?.cancel();
    _taskSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _tasks = snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      debugPrint("Error fetching tasks: $error");
      notifyListeners();
    });
  }

  Future<void> addTask(TaskModel task) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .add(task.toFirestore());
    } catch (e) {
      debugPrint("Failed to add task: $e");
    }
  }

  Future<void> updateTaskStatus(String id, TaskStatus newStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(id)
          .update({'status': newStatus.name});
    } catch (e) {
      debugPrint("Failed to update task: $e");
    }
  }

  Future<void> updateTaskPriority(String id, String priorityLabel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(id)
          .update({'priorityLabel': priorityLabel});
    } catch (e) {
      debugPrint("Failed to update task priority: $e");
    }
  }

  Future<void> deleteTask(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint("Failed to delete task: $e");
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
