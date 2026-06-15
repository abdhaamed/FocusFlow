import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_provider.dart';
import '../models/goal_model.dart';

class GoalProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  bool _isLoading = false;

  // SMART Goal Draft Fields (used during Onboarding / Add New Goal)
  String _primaryObjective = '';
  String _specific = '';
  String _measurable = '';
  String _achievable = '';
  String _relevant = '';
  DateTime? _timebound;

  // Goals List
  List<GoalModel> _goals = [];
  StreamSubscription<QuerySnapshot>? _goalsSubscription;

  GoalProvider(this._authProvider) {
    _authProvider.addListener(_onAuthChange);
    if (_authProvider.isAuthenticated && _authProvider.user != null) {
      _subscribeToGoals(_authProvider.user!.uid);
    }
  }

  bool get isLoading => _isLoading;

  // Draft Getters
  String get primaryObjective => _primaryObjective;
  String get specific => _specific;
  String get measurable => _measurable;
  String get achievable => _achievable;
  String get relevant => _relevant;
  DateTime? get timebound => _timebound;

  // Check if we have at least one active goal from DB
  bool get hasGoal => _goals.isNotEmpty;

  // Goals List Getter
  List<GoalModel> get goals => _goals;

  // Current Active Goal
  GoalModel? get currentGoal => _goals.isNotEmpty ? _goals.first : null;

  void setPrimaryObjective(String value) { _primaryObjective = value; notifyListeners(); }
  void setSpecific(String value) { _specific = value; notifyListeners(); }
  void setMeasurable(String value) { _measurable = value; notifyListeners(); }
  void setAchievable(String value) { _achievable = value; notifyListeners(); }
  void setRelevant(String value) { _relevant = value; notifyListeners(); }
  void setTimebound(DateTime? value) { _timebound = value; notifyListeners(); }

  void _onAuthChange() {
    if (_authProvider.isAuthenticated && _authProvider.user != null) {
      _subscribeToGoals(_authProvider.user!.uid);
    } else {
      _goals = [];
      _goalsSubscription?.cancel();
      _clearLocalData();
    }
  }

  void _clearLocalData() {
    _primaryObjective = '';
    _specific = '';
    _measurable = '';
    _achievable = '';
    _relevant = '';
    _timebound = null;
    notifyListeners();
  }

  void _subscribeToGoals(String userId) {
    _isLoading = true;
    notifyListeners();

    _goalsSubscription?.cancel();
    _goalsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('goals')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _goals = snapshot.docs.map((doc) => GoalModel.fromFirestore(doc)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      debugPrint("Error fetching goals: $error");
      notifyListeners();
    });
  }

  Future<void> addGoal() async {
    final user = _authProvider.user;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newGoal = GoalModel(
        id: '', // Firestore will generate the ID
        primaryObjective: _primaryObjective,
        specific: _specific,
        measurable: _measurable,
        achievable: _achievable,
        relevant: _relevant,
        timebound: _timebound,
        isActive: true,
        progress: 0.0,
      );

      // Add to 'goals' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('goals')
          .add(newGoal.toFirestore());

      // Update user doc onboarding flag
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'hasCompletedOnboarding': true,
      }, SetOptions(merge: true));

      _clearLocalData();
    } catch (e) {
      debugPrint("Failed to add goal: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _goalsSubscription?.cancel();
    _authProvider.removeListener(_onAuthChange);
    super.dispose();
  }
}
