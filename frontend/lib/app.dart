import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme.dart';
import 'providers/providers.dart';
import 'screens/ai_insights_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/assessment_preview_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/mapping_screen.dart';
import 'screens/more_screen.dart';
import 'screens/question_studio_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/student_preview_screen.dart';
import 'screens/syllabus_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BloomShell(child: child),
        routes: [
          GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen()),
          GoRoute(path: '/courses', builder: (c, s) => const CoursesScreen()),
          GoRoute(path: '/questions', builder: (c, s) => const QuestionStudioScreen()),
          GoRoute(path: '/analytics', builder: (c, s) => const AnalyticsScreen()),
        ],
      ),
      GoRoute(
        path: '/more',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const MoreScreen(),
      ),
      GoRoute(
        path: '/syllabus',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const SyllabusScreen(),
      ),
      GoRoute(
        path: '/mapping',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const MappingScreen(),
      ),
      GoRoute(
        path: '/assessment-preview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const AssessmentPreviewScreen(),
      ),
      GoRoute(
        path: '/student-preview',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const StudentPreviewScreen(),
      ),
      GoRoute(
        path: '/ai-insights',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const AiInsightsScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (c, s) => const SettingsScreen(),
      ),
    ],
  );
});

class BloomApp extends ConsumerWidget {
  const BloomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'BLOOM',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      darkTheme: BloomTheme.dark,
      theme: BloomTheme.dark,
      routerConfig: router,
    );
  }
}

/// Persistent shell: Top AppBar + body + BottomNavigationBar, per the
/// mobile-first navigation spec (no desktop sidebar).
class BloomShell extends ConsumerWidget {
  const BloomShell({super.key, required this.child});
  final Widget child;

  static const _titles = ['BLOOM', 'My Courses', 'Question Studio', 'Outcome Analytics'];
  static const _paths = ['/dashboard', '/courses', '/questions', '/analytics'];

  int _indexForLocation(String location) {
    final i = _paths.indexWhere((p) => location.startsWith(p));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: BloomColors.brandGradient,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(LucideIcons.sprout, size: 17, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(_titles[index]),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.layoutGrid),
            tooltip: 'More',
            onPressed: () => context.push('/more'),
          ),
        ],
      ),
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => context.go(_paths[i]),
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.sparkles), label: 'Questions'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.barChart3), label: 'Analytics'),
        ],
      ),
    );
  }
}
