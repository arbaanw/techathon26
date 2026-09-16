class OutcomeAttainment {
  final String code;
  final double value; // 0-100
  const OutcomeAttainment(this.code, this.value);
}

class AnalyticsSummary {
  final int totalStudents;
  final double averageScore;
  final double maxScore;
  final double passRate; // 0-100
  final double coAttainment; // 0-100 overall
  final List<OutcomeAttainment> coBreakdown;
  final List<OutcomeAttainment> poBreakdown;
  final Map<String, double> bloomPerformance; // level -> % correct
  final double coTarget;

  const AnalyticsSummary({
    required this.totalStudents,
    required this.averageScore,
    required this.maxScore,
    required this.passRate,
    required this.coAttainment,
    required this.coBreakdown,
    required this.poBreakdown,
    required this.bloomPerformance,
    this.coTarget = 70,
  });
}

class AiInsight {
  final String title;
  final String severity; // critical / warning / info
  final String metricLabel;
  final double current;
  final double target;
  final String recommendation;

  const AiInsight({
    required this.title,
    required this.severity,
    required this.metricLabel,
    required this.current,
    required this.target,
    required this.recommendation,
  });
}

class ImprovementPlanItem {
  final String priority; // High / Medium / Low
  final String issue;
  final String action;
  final String impact;

  const ImprovementPlanItem({
    required this.priority,
    required this.issue,
    required this.action,
    required this.impact,
  });
}
