import '../models/analytics.dart';
import '../models/course.dart';
import '../models/question.dart';
import 'api_service.dart';
import 'mock_api_service.dart';

/// Placeholder for the future live pipeline:
///   Flutter APK -> Python FastAPI -> Gemini -> Supabase
///
/// Intentionally unimplemented for the hackathon build: no auth, no API
/// keys are wired up here. Point [baseUrl] at a FastAPI backend and fill in
/// the HTTP calls (e.g. using `http` or `dio`) when the backend is ready.
/// Until then this simply delegates to [MockApiService] so the app never
/// breaks if it's selected by mistake.
class RealApiService implements ApiService {
  RealApiService({this.baseUrl = 'http://localhost:8000'});

  final String baseUrl;
  final MockApiService _fallback = MockApiService();

  @override
  Future<List<Course>> getCourses() => _fallback.getCourses();

  @override
  Future<Course> getCourse(String code) => _fallback.getCourse(code);

  @override
  Stream<Object> analyzeSyllabus({required String fileName, required String courseCode}) =>
      _fallback.analyzeSyllabus(fileName: fileName, courseCode: courseCode);

  @override
  Future<List<TopicMapping>> getMappings(String courseCode) => _fallback.getMappings(courseCode);

  @override
  Stream<Object> generateQuestions(AssessmentConfig config) => _fallback.generateQuestions(config);

  @override
  Future<Question> regenerateQuestion(Question original) => _fallback.regenerateQuestion(original);

  @override
  Future<List<Question>> getAssessment(String courseCode) => _fallback.getAssessment(courseCode);

  @override
  Future<AnalyticsSummary> getAnalytics(String courseCode) => _fallback.getAnalytics(courseCode);

  @override
  Future<List<AiInsight>> getInsights(String courseCode) => _fallback.getInsights(courseCode);

  @override
  Future<List<ImprovementPlanItem>> getImprovementPlan(String courseCode) =>
      _fallback.getImprovementPlan(courseCode);
}
