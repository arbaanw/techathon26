import 'dart:math';

import '../core/constants.dart';
import '../data/mock_data.dart';
import '../models/analytics.dart';
import '../models/course.dart';
import '../models/question.dart';
import 'api_service.dart';

/// Default BLOOM data source. Works fully offline with realistic mock data
/// and simulated AI processing delays, so no backend or API key is required.
class MockApiService implements ApiService {
  int _regenSeed = 100;

  @override
  Future<List<Course>> getCourses() async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.courses;
  }

  @override
  Future<Course> getCourse(String code) async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.courses.firstWhere(
      (c) => c.code == code,
      orElse: () => MockData.primaryCourse,
    );
  }

  @override
  Stream<Object> analyzeSyllabus({
    required String fileName,
    required String courseCode,
  }) async* {
    const steps = [
      'Reading syllabus...',
      'Extracting course structure...',
      'Identifying COs...',
      'Mapping POs...',
      'Classifying Bloom levels...',
      'Building outcome graph...',
    ];
    final perStep = BloomMockDelays.syllabusAnalysis ~/ steps.length;
    for (final step in steps) {
      await Future.delayed(perStep);
      yield AiProgressStep(step);
    }
    yield MockData.primaryCourse;
  }

  @override
  Future<List<TopicMapping>> getMappings(String courseCode) async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.topicMappings;
  }

  @override
  Stream<Object> generateQuestions(AssessmentConfig config) async* {
    const steps = [
      'Balancing Bloom Taxonomy',
      'Mapping Course Outcomes',
      'Mapping Program Outcomes',
      'Generating Questions',
      'Quality Checking',
    ];
    final perStep = BloomMockDelays.questionGeneration ~/ steps.length;
    for (final step in steps) {
      await Future.delayed(perStep);
      yield AiProgressStep(step);
    }
    yield MockData.generateQuestions(config.questionCount);
  }

  @override
  Future<Question> regenerateQuestion(Question original) async {
    await Future.delayed(BloomMockDelays.regeneration);
    _regenSeed += Random().nextInt(7) + 1;
    final replacement = MockData.generateQuestions(1, seedOffset: _regenSeed).first;
    return replacement.copyWith();
  }

  @override
  Future<List<Question>> getAssessment(String courseCode) async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.generateQuestions(10);
  }

  @override
  Future<AnalyticsSummary> getAnalytics(String courseCode) async {
    await Future.delayed(BloomMockDelays.analytics);
    return MockData.analytics;
  }

  @override
  Future<List<AiInsight>> getInsights(String courseCode) async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.insights;
  }

  @override
  Future<List<ImprovementPlanItem>> getImprovementPlan(String courseCode) async {
    await Future.delayed(BloomMockDelays.generic);
    return MockData.improvementPlan;
  }
}
