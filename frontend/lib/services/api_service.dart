import '../models/analytics.dart';
import '../models/course.dart';
import '../models/question.dart';

/// Progress event emitted during long-running AI operations so the UI can
/// show a step-by-step animation (syllabus analysis, question generation).
class AiProgressStep {
  final String label;
  const AiProgressStep(this.label);
}

/// Common contract implemented by both [MockApiService] (default, offline)
/// and [RealApiService] (Flutter -> FastAPI -> Gemini -> Supabase, future).
abstract class ApiService {
  Future<List<Course>> getCourses();

  Future<Course> getCourse(String code);

  /// Streams progress steps, then yields the analyzed course as the final event.
  Stream<Object> analyzeSyllabus({required String fileName, required String courseCode});

  Future<List<TopicMapping>> getMappings(String courseCode);

  /// Streams progress steps, then yields the generated question list.
  Stream<Object> generateQuestions(AssessmentConfig config);

  Future<Question> regenerateQuestion(Question original);

  Future<List<Question>> getAssessment(String courseCode);

  Future<AnalyticsSummary> getAnalytics(String courseCode);

  Future<List<AiInsight>> getInsights(String courseCode);

  Future<List<ImprovementPlanItem>> getImprovementPlan(String courseCode);
}
