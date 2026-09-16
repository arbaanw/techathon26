class TopicMapping {
  final String topic;
  final String bloomLevel;
  final String co;
  final String po;

  const TopicMapping({
    required this.topic,
    required this.bloomLevel,
    required this.co,
    required this.po,
  });

  factory TopicMapping.fromJson(Map<String, dynamic> json) => TopicMapping(
        topic: json['topic'] as String,
        bloomLevel: json['bloomLevel'] as String,
        co: json['co'] as String,
        po: json['po'] as String,
      );

  Map<String, dynamic> toJson() => {
        'topic': topic,
        'bloomLevel': bloomLevel,
        'co': co,
        'po': po,
      };
}

class CourseUnit {
  final String title;
  final List<String> topics;

  const CourseUnit({required this.title, required this.topics});

  factory CourseUnit.fromJson(Map<String, dynamic> json) => CourseUnit(
        title: json['title'] as String,
        topics: List<String>.from(json['topics'] as List),
      );

  Map<String, dynamic> toJson() => {'title': title, 'topics': topics};
}

class CourseOutcome {
  final String code; // CO1..CO5
  final String description;
  final double attainment; // 0-100

  const CourseOutcome({
    required this.code,
    required this.description,
    required this.attainment,
  });

  factory CourseOutcome.fromJson(Map<String, dynamic> json) => CourseOutcome(
        code: json['code'] as String,
        description: json['description'] as String,
        attainment: (json['attainment'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'attainment': attainment,
      };
}

class ProgramOutcome {
  final String code; // PO1, PO2...
  final String description;
  final double attainment;

  const ProgramOutcome({
    required this.code,
    required this.description,
    required this.attainment,
  });

  factory ProgramOutcome.fromJson(Map<String, dynamic> json) => ProgramOutcome(
        code: json['code'] as String,
        description: json['description'] as String,
        attainment: (json['attainment'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'description': description,
        'attainment': attainment,
      };
}

class Course {
  final String code; // AIE-2102
  final String name; // Artificial Intelligence
  final int unitCount;
  final int topicCount;
  final double progress; // 0-1
  final List<CourseUnit> units;
  final List<CourseOutcome> outcomes;
  final List<ProgramOutcome> programOutcomes;
  final List<TopicMapping> topicMappings;

  const Course({
    required this.code,
    required this.name,
    required this.unitCount,
    required this.topicCount,
    required this.progress,
    required this.units,
    required this.outcomes,
    required this.programOutcomes,
    required this.topicMappings,
  });

  int get coCount => outcomes.length;
  int get poCount => programOutcomes.length;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        code: json['code'] as String,
        name: json['name'] as String,
        unitCount: json['unitCount'] as int,
        topicCount: json['topicCount'] as int,
        progress: (json['progress'] as num).toDouble(),
        units: (json['units'] as List)
            .map((e) => CourseUnit.fromJson(e as Map<String, dynamic>))
            .toList(),
        outcomes: (json['outcomes'] as List)
            .map((e) => CourseOutcome.fromJson(e as Map<String, dynamic>))
            .toList(),
        programOutcomes: (json['programOutcomes'] as List)
            .map((e) => ProgramOutcome.fromJson(e as Map<String, dynamic>))
            .toList(),
        topicMappings: (json['topicMappings'] as List)
            .map((e) => TopicMapping.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'unitCount': unitCount,
        'topicCount': topicCount,
        'progress': progress,
        'units': units.map((e) => e.toJson()).toList(),
        'outcomes': outcomes.map((e) => e.toJson()).toList(),
        'programOutcomes': programOutcomes.map((e) => e.toJson()).toList(),
        'topicMappings': topicMappings.map((e) => e.toJson()).toList(),
      };
}
