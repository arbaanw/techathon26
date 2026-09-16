import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/analytics.dart';
import '../models/course.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import '../services/mock_api_service.dart';

/// Demo mode is always on for the hackathon build — no backend required.
final apiServiceProvider = Provider<ApiService>((ref) => MockApiService());

/// Selected theme mode from Settings (Dark is BLOOM's default look).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// Currently active course across the app.
final activeCourseProvider = StateProvider<Course>((ref) => MockData.primaryCourse);

/// Bottom navigation index for the shell.
final navIndexProvider = StateProvider<int>((ref) => 0);

/// Holds the last-generated / edited assessment so Question Studio,
/// Assessment Preview and Student Preview all stay in sync.
class AssessmentNotifier extends StateNotifier<List<Question>> {
  AssessmentNotifier() : super(MockData.generateQuestions(10));

  void setAll(List<Question> questions) => state = questions;

  void updateQuestion(Question updated) {
    state = [
      for (final q in state)
        if (q.id == updated.id) updated else q,
    ];
  }

  void removeQuestion(String id) {
    state = state.where((q) => q.id != id).toList();
  }

  void replaceQuestion(String id, Question replacement) {
    state = [
      for (final q in state)
        if (q.id == id) replacement.copyWith() else q,
    ];
  }
}

final assessmentProvider = StateNotifierProvider<AssessmentNotifier, List<Question>>(
  (ref) => AssessmentNotifier(),
);

final assessmentConfigProvider = StateProvider<AssessmentConfig>((ref) => const AssessmentConfig());

/// Analytics summary — fetched once per session (demo data).
final analyticsProvider = FutureProvider<AnalyticsSummary>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getAnalytics(ref.watch(activeCourseProvider).code);
});

final insightsProvider = FutureProvider<List<AiInsight>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getInsights(ref.watch(activeCourseProvider).code);
});

final improvementPlanProvider = FutureProvider<List<ImprovementPlanItem>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getImprovementPlan(ref.watch(activeCourseProvider).code);
});

/// Simple backend-connectivity flag surfaced in Settings/error states.
final backendConnectedProvider = StateProvider<bool>((ref) => false);
