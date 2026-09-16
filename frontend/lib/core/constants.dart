class BloomSpacing {
  BloomSpacing._();
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
}

class BloomRadius {
  BloomRadius._();
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double pill = 999;
}

/// Standard mock async delays (see PRD "Mock delays" section).
class BloomMockDelays {
  BloomMockDelays._();
  static const syllabusAnalysis = Duration(seconds: 3);
  static const questionGeneration = Duration(seconds: 2);
  static const regeneration = Duration(milliseconds: 1400);
  static const analytics = Duration(seconds: 1);
  static const generic = Duration(milliseconds: 600);
}
