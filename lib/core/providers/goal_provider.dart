import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_provider.dart';

class GoalProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  bool _isLoading = false;

  // SMART Goal Fields
  String _primaryObjective = '';
  String _specific = '';
  String _measurable = '';
  String _achievable = '';
  String _relevant = '';
  DateTime? _timebound;

  GoalProvider(this._authProvider) {
    _authProvider.addListener(_onAuthChange);
    _fetchPrimaryGoal();
  }

  bool get isLoading => _isLoading;

  String get primaryObjective => _primaryObjective;
  String get specific => _specific;
  String get measurable => _measurable;
  String get achievable => _achievable;
  String get relevant => _relevant;
  DateTime? get timebound => _timebound;

  bool get hasGoal => _primaryObjective.isNotEmpty && _specific.isNotEmpty;

  void setPrimaryObjective(String value) { _primaryObjective = value; notifyListeners(); }
  void setSpecific(String value) { _specific = value; notifyListeners(); }
  void setMeasurable(String value) { _measurable = value; notifyListeners(); }
  void setAchievable(String value) { _achievable = value; notifyListeners(); }
  void setRelevant(String value) { _relevant = value; notifyListeners(); }
  void setTimebound(DateTime? value) { _timebound = value; notifyListeners(); }

  void _onAuthChange() {
    if (_authProvider.isAuthenticated) {
      _fetchPrimaryGoal();
    } else {
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

  Future<void> _fetchPrimaryGoal() async {
    final user = _authProvider.user;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!.containsKey('primaryGoal')) {
        final goalData = doc.data()!['primaryGoal'] as Map<String, dynamic>;
        _primaryObjective = goalData['primaryObjective'] ?? '';
        _specific = goalData['specific'] ?? '';
        _measurable = goalData['measurable'] ?? '';
        _achievable = goalData['achievable'] ?? '';
        _relevant = goalData['relevant'] ?? '';
        if (goalData['timebound'] != null) {
          _timebound = (goalData['timebound'] as Timestamp).toDate();
        }
      } else {
        _clearLocalData();
      }
    } catch (e) {
      debugPrint("Failed to fetch primary goal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePrimaryGoal() async {
    final user = _authProvider.user;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final goalData = {
        'primaryObjective': _primaryObjective,
        'specific': _specific,
        'measurable': _measurable,
        'achievable': _achievable,
        'relevant': _relevant,
        'timebound': _timebound != null ? Timestamp.fromDate(_timebound!) : null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'hasCompletedOnboarding': true,
        'primaryGoal': goalData,
      }, SetOptions(merge: true));

    } catch (e) {
      debugPrint("Failed to save primary goal: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
