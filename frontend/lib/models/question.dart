/// The six levels of Bloom's Taxonomy, low to high cognitive order.
const List<String> kBloomLevels = [
  'Remember',
  'Understand',
  'Apply',
  'Analyze',
  'Evaluate',
  'Create',
];

const Map<String, String> kBloomDescriptions = {
  'Remember': 'Recall facts and basic concepts',
  'Understand': 'Explain ideas or concepts',
  'Apply': 'Use information in new situations',
  'Analyze': 'Draw connections among ideas',
  'Evaluate': 'Justify a stand or decision',
  'Create': 'Produce new or original work',
};

class Question {
  final String id;
  final String text;
  final List<String> options; // A, B, C, D
  final int correctIndex;
  final String explanation;
  final String bloomLevel;
  final String co;
  final String po;
  final String difficulty; // Easy, Medium, Hard
  final int marks;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.bloomLevel,
    required this.co,
    required this.po,
    required this.difficulty,
    required this.marks,
  });

  String get correctLetter => String.fromCharCode(65 + correctIndex);

  Question copyWith({
    String? text,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    String? bloomLevel,
    String? co,
    String? po,
    String? difficulty,
    int? marks,
  }) {
    return Question(
      id: id,
      text: text ?? this.text,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      bloomLevel: bloomLevel ?? this.bloomLevel,
      co: co ?? this.co,
      po: po ?? this.po,
      difficulty: difficulty ?? this.difficulty,
      marks: marks ?? this.marks,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        text: json['text'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String,
        bloomLevel: json['bloomLevel'] as String,
        co: json['co'] as String,
        po: json['po'] as String,
        difficulty: json['difficulty'] as String,
        marks: json['marks'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'bloomLevel': bloomLevel,
        'co': co,
        'po': po,
        'difficulty': difficulty,
        'marks': marks,
      };
}

class AssessmentConfig {
  final String courseCode;
  final int questionCount;
  final String type; // MCQ
  final String difficulty; // Mixed / Easy / Medium / Hard
  final String bloomFocus; // Balanced / Lower-order / Higher-order
  final String coMode; // Automatic / Manual
  final String poMode; // Automatic / Manual
  final int marksPerQuestion;

  const AssessmentConfig({
    this.courseCode = 'AIE-2102',
    this.questionCount = 10,
    this.type = 'MCQ',
    this.difficulty = 'Mixed',
    this.bloomFocus = 'Balanced',
    this.coMode = 'Automatic',
    this.poMode = 'Automatic',
    this.marksPerQuestion = 2,
  });

  AssessmentConfig copyWith({
    String? courseCode,
    int? questionCount,
    String? type,
    String? difficulty,
    String? bloomFocus,
    String? coMode,
    String? poMode,
    int? marksPerQuestion,
  }) {
    return AssessmentConfig(
      courseCode: courseCode ?? this.courseCode,
      questionCount: questionCount ?? this.questionCount,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      bloomFocus: bloomFocus ?? this.bloomFocus,
      coMode: coMode ?? this.coMode,
      poMode: poMode ?? this.poMode,
      marksPerQuestion: marksPerQuestion ?? this.marksPerQuestion,
    );
  }
}
