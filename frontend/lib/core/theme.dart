import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// BLOOM color palette — dark futuristic AI SaaS theme.
class BloomColors {
  BloomColors._();

  static const Color background = Color(0xFF070B14);
  static const Color surface = Color(0xFF101827);
  static const Color elevated = Color(0xFF131D2E);

  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color blue = Color(0xFF3B82F6);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const Color border = Color(0x1FFFFFFF);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, violet, cyan],
  );

  static const LinearGradient cardGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x337C3AED), Color(0x1A06B6D4)],
  );
}

/// Bloom's Taxonomy level colors, low (Remember) to high (Create).
class BloomLevelColors {
  BloomLevelColors._();

  static const Map<String, Color> byLevel = {
    'Remember': Color(0xFF3B82F6),
    'Understand': Color(0xFF06B6D4),
    'Apply': Color(0xFF22C55E),
    'Analyze': Color(0xFFF59E0B),
    'Evaluate': Color(0xFF8B5CF6),
    'Create': Color(0xFFEF4444),
  };

  static Color of(String level) => byLevel[level] ?? BloomColors.primaryPurple;
}

class BloomTheme {
  BloomTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: BloomColors.textPrimary,
      displayColor: BloomColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: BloomColors.background,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: BloomColors.primaryPurple,
        secondary: BloomColors.cyan,
        surface: BloomColors.surface,
        error: BloomColors.danger,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: BloomColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: BloomColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: BloomColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: BloomColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: BloomColors.border, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BloomColors.surface,
        selectedItemColor: BloomColors.violet,
        unselectedItemColor: BloomColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BloomColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BloomColors.textPrimary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: BloomColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BloomColors.cyan,
          minimumSize: const Size(44, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BloomColors.elevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BloomColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BloomColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: BloomColors.violet, width: 1.5),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: BloomColors.elevated,
        labelStyle: const TextStyle(color: BloomColors.textPrimary, fontSize: 12),
        side: const BorderSide(color: BloomColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BloomColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: BloomColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
