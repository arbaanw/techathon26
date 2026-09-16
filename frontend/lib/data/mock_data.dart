import '../models/analytics.dart';
import '../models/course.dart';
import '../models/question.dart';

/// Single source of truth for BLOOM's offline demo data.
class MockData {
  MockData._();

  static final List<String> unitTitles = [
    'Introduction to Artificial Intelligence',
    'Search Techniques',
    'Knowledge Representation',
    'Machine Learning',
    'AI Applications',
  ];

  static final Map<String, List<String>> unitTopics = {
    'Introduction to Artificial Intelligence': ['Intelligent Agents', 'Problem Solving'],
    'Search Techniques': [
      'State Space Representation',
      'BFS',
      'DFS',
      'Uniform Cost Search',
      'Greedy Best First Search',
      'A* Search',
    ],
    'Knowledge Representation': [
      'Propositional Logic',
      'Predicate Logic',
      'Semantic Networks',
      'Frames',
    ],
    'Machine Learning': ['Supervised Learning', 'Unsupervised Learning', 'Classification', 'Clustering'],
    'AI Applications': ['Expert Systems', 'NLP', 'Computer Vision', 'Robotics'],
  };

  static final List<CourseOutcome> outcomes = [
    const CourseOutcome(
      code: 'CO1',
      description: 'Understand fundamental concepts and principles of AI.',
      attainment: 82,
    ),
    const CourseOutcome(
      code: 'CO2',
      description: 'Apply search techniques to solve AI problems.',
      attainment: 71,
    ),
    const CourseOutcome(
      code: 'CO3',
      description: 'Analyze knowledge representation techniques for intelligent systems.',
      attainment: 58,
    ),
    const CourseOutcome(
      code: 'CO4',
      description: 'Apply machine learning techniques to practical problems.',
      attainment: 76,
    ),
    const CourseOutcome(
      code: 'CO5',
      description: 'Evaluate AI applications and suitability for real-world problems.',
      attainment: 69,
    ),
  ];

  static final List<ProgramOutcome> programOutcomes = [
    const ProgramOutcome(code: 'PO1', description: 'Engineering knowledge', attainment: 76),
    const ProgramOutcome(code: 'PO2', description: 'Problem analysis', attainment: 64),
    const ProgramOutcome(code: 'PO3', description: 'Design/development of solutions', attainment: 69),
    const ProgramOutcome(code: 'PO5', description: 'Modern tool usage', attainment: 72),
    const ProgramOutcome(code: 'PO12', description: 'Life-long learning', attainment: 81),
  ];

  static final List<TopicMapping> topicMappings = [
    const TopicMapping(topic: 'Intelligent Agents', bloomLevel: 'Understand', co: 'CO1', po: 'PO1'),
    const TopicMapping(topic: 'Problem Solving', bloomLevel: 'Apply', co: 'CO1', po: 'PO1'),
    const TopicMapping(topic: 'State Space Representation', bloomLevel: 'Understand', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'BFS', bloomLevel: 'Apply', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'DFS', bloomLevel: 'Apply', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'Uniform Cost Search', bloomLevel: 'Analyze', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'Greedy Best First Search', bloomLevel: 'Analyze', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'A* Search', bloomLevel: 'Apply', co: 'CO2', po: 'PO2'),
    const TopicMapping(topic: 'Propositional Logic', bloomLevel: 'Understand', co: 'CO3', po: 'PO3'),
    const TopicMapping(topic: 'Predicate Logic', bloomLevel: 'Analyze', co: 'CO3', po: 'PO3'),
    const TopicMapping(topic: 'Semantic Networks', bloomLevel: 'Analyze', co: 'CO3', po: 'PO3'),
    const TopicMapping(topic: 'Frames', bloomLevel: 'Understand', co: 'CO3', po: 'PO3'),
    const TopicMapping(topic: 'Supervised Learning', bloomLevel: 'Apply', co: 'CO4', po: 'PO5'),
    const TopicMapping(topic: 'Unsupervised Learning', bloomLevel: 'Understand', co: 'CO4', po: 'PO5'),
    const TopicMapping(topic: 'Classification', bloomLevel: 'Apply', co: 'CO4', po: 'PO5'),
    const TopicMapping(topic: 'Clustering', bloomLevel: 'Analyze', co: 'CO4', po: 'PO5'),
    const TopicMapping(topic: 'Expert Systems', bloomLevel: 'Evaluate', co: 'CO5', po: 'PO12'),
    const TopicMapping(topic: 'NLP', bloomLevel: 'Evaluate', co: 'CO5', po: 'PO12'),
    const TopicMapping(topic: 'Computer Vision', bloomLevel: 'Evaluate', co: 'CO5', po: 'PO12'),
    const TopicMapping(topic: 'Robotics', bloomLevel: 'Create', co: 'CO5', po: 'PO12'),
  ];

  static Course get primaryCourse => Course(
        code: 'AIE-2102',
        name: 'Artificial Intelligence',
        unitCount: unitTitles.length,
        topicCount: topicMappings.length,
        progress: 0.82,
        units: unitTitles
            .map((u) => CourseUnit(title: u, topics: unitTopics[u] ?? const []))
            .toList(),
        outcomes: outcomes,
        programOutcomes: programOutcomes,
        topicMappings: topicMappings,
      );

  static List<Course> get courses => [primaryCourse];

  /// CO x PO relationship matrix strength: 3 = Strong, 2 = Moderate, 1 = Low, 0 = none.
  static final Map<String, Map<String, int>> coPoMatrix = {
    'CO1': {'PO1': 3, 'PO2': 1, 'PO3': 0, 'PO5': 1, 'PO12': 2},
    'CO2': {'PO1': 2, 'PO2': 3, 'PO3': 2, 'PO5': 1, 'PO12': 1},
    'CO3': {'PO1': 1, 'PO2': 2, 'PO3': 3, 'PO5': 1, 'PO12': 1},
    'CO4': {'PO1': 1, 'PO2': 2, 'PO3': 2, 'PO5': 3, 'PO12': 2},
    'CO5': {'PO1': 0, 'PO2': 1, 'PO3': 2, 'PO5': 2, 'PO12': 3},
  };

  /// Realistic Bloom distribution used for question generation & display.
  static const Map<String, double> bloomDistribution = {
    'Remember': 10,
    'Understand': 20,
    'Apply': 30,
    'Analyze': 20,
    'Evaluate': 10,
    'Create': 10,
  };

  static const List<Map<String, dynamic>> _questionBank = [
    {
      'text': 'Which search algorithm guarantees an optimal solution when all step costs are equal?',
      'options': ['Depth-First Search', 'Breadth-First Search', 'Greedy Best-First Search', 'Random Search'],
      'correctIndex': 1,
      'explanation':
          'BFS explores all nodes at a given depth before going deeper, guaranteeing the shallowest (optimal) solution when step costs are uniform.',
      'bloomLevel': 'Apply',
      'co': 'CO2',
      'po': 'PO2',
      'difficulty': 'Medium',
    },
    {
      'text': 'Define an intelligent agent in the context of Artificial Intelligence.',
      'options': [
        'A program that only stores data',
        'An entity that perceives its environment and acts upon it',
        'A static rule table',
        'A hardware component only',
      ],
      'correctIndex': 1,
      'explanation':
          'An intelligent agent perceives its environment through sensors and acts upon it through actuators to achieve goals.',
      'bloomLevel': 'Remember',
      'co': 'CO1',
      'po': 'PO1',
      'difficulty': 'Easy',
    },
    {
      'text': 'Explain why the A* search algorithm is considered more efficient than Uniform Cost Search.',
      'options': [
        'It ignores path cost entirely',
        'It uses a heuristic to guide the search toward the goal',
        'It always expands every node',
        'It only works on trees, not graphs',
      ],
      'correctIndex': 1,
      'explanation':
          'A* combines path cost (g) with a heuristic estimate (h) to the goal, focusing search and reducing nodes expanded compared to UCS.',
      'bloomLevel': 'Understand',
      'co': 'CO2',
      'po': 'PO2',
      'difficulty': 'Medium',
    },
    {
      'text': 'Analyze the following statement: "All humans are mortal. Socrates is a human." '
          'Which representation best captures this reasoning?',
      'options': ['Semantic Network', 'Predicate Logic', 'Frame System', 'Fuzzy Logic'],
      'correctIndex': 1,
      'explanation':
          'Predicate logic can express quantified relationships such as "for all x, human(x) -> mortal(x)" and apply it to a specific instance.',
      'bloomLevel': 'Analyze',
      'co': 'CO3',
      'po': 'PO3',
      'difficulty': 'Hard',
    },
    {
      'text': 'Which classification algorithm is most appropriate for a linearly separable, labeled dataset?',
      'options': ['K-Means Clustering', 'Logistic Regression', 'Apriori Algorithm', 'PCA'],
      'correctIndex': 1,
      'explanation':
          'Logistic Regression is a supervised classification technique well-suited to linearly separable labeled data.',
      'bloomLevel': 'Apply',
      'co': 'CO4',
      'po': 'PO5',
      'difficulty': 'Medium',
    },
    {
      'text': 'Evaluate the suitability of an expert system for real-time medical diagnosis support.',
      'options': [
        'Unsuitable — expert systems cannot encode domain rules',
        'Suitable — it can encode expert rules but needs continuous knowledge base updates',
        'Suitable — it replaces doctors entirely',
        'Unsuitable — expert systems require GPUs',
      ],
      'correctIndex': 1,
      'explanation':
          'Expert systems encode domain expert rules effectively, but require regular updates to remain accurate and are best used as decision support, not replacement.',
      'bloomLevel': 'Evaluate',
      'co': 'CO5',
      'po': 'PO12',
      'difficulty': 'Hard',
    },
    {
      'text': 'Design a high-level clustering approach to group unlabeled customer purchase data.',
      'options': [
        'Use Linear Regression to predict labels',
        'Apply K-Means clustering after feature scaling',
        'Use Breadth-First Search',
        'Apply Predicate Logic rules',
      ],
      'correctIndex': 1,
      'explanation':
          'K-Means is an unsupervised technique appropriate for grouping unlabeled data once features are scaled appropriately.',
      'bloomLevel': 'Create',
      'co': 'CO4',
      'po': 'PO5',
      'difficulty': 'Hard',
    },
    {
      'text': 'What is the primary goal of Natural Language Processing (NLP)?',
      'options': [
        'To enable computers to understand and generate human language',
        'To optimize hardware performance',
        'To design robotic arms',
        'To compress image files',
      ],
      'correctIndex': 0,
      'explanation': 'NLP focuses on enabling machines to understand, interpret, and generate human language.',
      'bloomLevel': 'Remember',
      'co': 'CO5',
      'po': 'PO12',
      'difficulty': 'Easy',
    },
    {
      'text': 'Compare Depth-First Search and Breadth-First Search in terms of memory usage.',
      'options': [
        'DFS uses more memory than BFS in all cases',
        'DFS generally uses less memory since it explores one path at a time',
        'They use identical memory in every case',
        'Memory usage is not a relevant factor',
      ],
      'correctIndex': 1,
      'explanation':
          'DFS only needs to store a single path from root to leaf plus siblings, while BFS must store an entire frontier level, using more memory.',
      'bloomLevel': 'Analyze',
      'co': 'CO2',
      'po': 'PO2',
      'difficulty': 'Medium',
    },
    {
      'text': 'Which technique represents knowledge using nodes and labeled edges to show relationships?',
      'options': ['Semantic Network', 'Linear Regression', 'Gradient Descent', 'Support Vector Machine'],
      'correctIndex': 0,
      'explanation': 'Semantic networks represent knowledge as a graph of concepts (nodes) connected by relationships (edges).',
      'bloomLevel': 'Understand',
      'co': 'CO3',
      'po': 'PO3',
      'difficulty': 'Easy',
    },
    {
      'text': 'Apply the concept of unsupervised learning to describe how clustering differs from classification.',
      'options': [
        'Clustering requires labeled data, classification does not',
        'Clustering groups data without predefined labels; classification assigns predefined labels',
        'Both require identical labeled datasets',
        'There is no meaningful difference',
      ],
      'correctIndex': 1,
      'explanation':
          'Clustering is unsupervised and groups similar data points without predefined labels, while classification is supervised and assigns known labels.',
      'bloomLevel': 'Apply',
      'co': 'CO4',
      'po': 'PO5',
      'difficulty': 'Medium',
    },
    {
      'text': 'Judge which factor most limits the real-world deployment of a computer vision system for autonomous driving.',
      'options': [
        'Lack of camera hardware entirely',
        'Robustness to varied lighting, weather, and edge-case scenarios',
        'Inability to process any image data',
        'Excessive battery life',
      ],
      'correctIndex': 1,
      'explanation':
          'Real-world robustness — handling diverse lighting, weather, and rare edge cases — is the primary limiting factor for deploying vision systems safely.',
      'bloomLevel': 'Evaluate',
      'co': 'CO5',
      'po': 'PO12',
      'difficulty': 'Hard',
    },
  ];

  /// Deterministically generates [count] questions matching the requested
  /// config, cycling and lightly varying the underlying question bank so
  /// the Bloom distribution stays realistic across regenerations.
  static List<Question> generateQuestions(int count, {int seedOffset = 0}) {
    final List<Question> result = [];
    for (int i = 0; i < count; i++) {
      final source = _questionBank[(i + seedOffset) % _questionBank.length];
      result.add(
        Question(
          id: 'q_${DateTime.now().microsecondsSinceEpoch}_$i',
          text: source['text'] as String,
          options: List<String>.from(source['options'] as List),
          correctIndex: source['correctIndex'] as int,
          explanation: source['explanation'] as String,
          bloomLevel: source['bloomLevel'] as String,
          co: source['co'] as String,
          po: source['po'] as String,
          difficulty: source['difficulty'] as String,
          marks: 2,
        ),
      );
    }
    return result;
  }

  static AnalyticsSummary get analytics => AnalyticsSummary(
        totalStudents: 48,
        averageScore: 14.8,
        maxScore: 20,
        passRate: 87,
        coAttainment: 71,
        coTarget: 70,
        coBreakdown: const [
          OutcomeAttainment('CO1', 82),
          OutcomeAttainment('CO2', 71),
          OutcomeAttainment('CO3', 58),
          OutcomeAttainment('CO4', 76),
          OutcomeAttainment('CO5', 69),
        ],
        poBreakdown: const [
          OutcomeAttainment('PO1', 76),
          OutcomeAttainment('PO2', 64),
          OutcomeAttainment('PO3', 69),
          OutcomeAttainment('PO5', 72),
          OutcomeAttainment('PO12', 81),
        ],
        bloomPerformance: const {
          'Remember': 88,
          'Understand': 79,
          'Apply': 68,
          'Analyze': 57,
          'Evaluate': 61,
          'Create': 54,
        },
      );

  static const List<AiInsight> insights = [
    AiInsight(
      title: 'CO3 Needs Attention',
      severity: 'critical',
      metricLabel: 'CO3 — Analyze knowledge representation techniques',
      current: 58,
      target: 70,
      recommendation:
          'Increase Analyze-level practice for Knowledge Representation. Add scenario-based predicate logic questions.',
    ),
    AiInsight(
      title: 'Bloom Imbalance Detected',
      severity: 'warning',
      metricLabel: 'Create-level questions underrepresented',
      current: 10,
      target: 15,
      recommendation:
          'Introduce more Create-level design tasks, especially in Machine Learning and AI Applications units.',
    ),
    AiInsight(
      title: 'PO2 Trending Below Target',
      severity: 'info',
      metricLabel: 'PO2 — Problem analysis',
      current: 64,
      target: 70,
      recommendation:
          'Pair Search Techniques topics with more multi-step problem analysis exercises to lift PO2 attainment.',
    ),
  ];

  static const List<ImprovementPlanItem> improvementPlan = [
    ImprovementPlanItem(
      priority: 'High',
      issue: 'CO3 attainment (58%) below the 70% target',
      action: 'Add 6-8 Analyze-level questions on Predicate Logic & Semantic Networks',
      impact: 'Projected +10-12% CO3 attainment next cycle',
    ),
    ImprovementPlanItem(
      priority: 'Medium',
      issue: 'Create-level Bloom coverage under-represented (10% vs 15% target)',
      action: 'Introduce 2 design/build style questions in Machine Learning unit',
      impact: 'Improves higher-order thinking coverage by ~5%',
    ),
    ImprovementPlanItem(
      priority: 'Medium',
      issue: 'PO2 (Problem analysis) trending at 64%',
      action: 'Add multi-step search-algorithm tracing questions',
      impact: 'Projected +6% PO2 attainment',
    ),
    ImprovementPlanItem(
      priority: 'Low',
      issue: 'Assessment pacing feedback from last cycle',
      action: 'Add a short worked example before Analyze-level items',
      impact: 'Reduces question abandonment rate',
    ),
  ];
}
