import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'services/card_repository.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'screens/learn_screen.dart';
import 'screens/library_screen.dart';
import 'screens/prompts_screen.dart';
import 'screens/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(repository: CardRepository(), storage: StorageService());
  await state.initialise();
  runApp(FinanceEnglishApp(state: state));
}

class FinanceEnglishApp extends StatelessWidget {
  final AppState state;
  const FinanceEnglishApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF4F8CFF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance English Pro',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF08111F),
        inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
      ),
      home: AppShell(state: state),
    );
  }
}

class AppShell extends StatefulWidget {
  final AppState state;
  const AppShell({super.key, required this.state});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  StudyFilter learnFilter = StudyFilter.due;

  void openLearn(StudyFilter filter) => setState(() { learnFilter = filter; index = 1; });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final pages = [
          HomeScreen(state: widget.state, onStartDue: () => openLearn(StudyFilter.due), onStartNew: () => openLearn(StudyFilter.newCards)),
          LearnScreen(key: ValueKey('learn-$learnFilter'), state: widget.state, initialFilter: learnFilter),
          LibraryScreen(state: widget.state),
          PromptsScreen(state: widget.state),
          StatsScreen(state: widget.state),
        ];
        return Scaffold(
          appBar: AppBar(title: Text(['Übersicht', 'Lernen', 'Bibliothek', 'Gesprächsprompts', 'Fortschritt'][index]), centerTitle: false),
          body: SafeArea(child: pages[index]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (value) => setState(() => index = value),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Start'),
              NavigationDestination(icon: Icon(Icons.style_outlined), selectedIcon: Icon(Icons.style_rounded), label: 'Lernen'),
              NavigationDestination(icon: Icon(Icons.library_books_outlined), selectedIcon: Icon(Icons.library_books_rounded), label: 'Karten'),
              NavigationDestination(icon: Icon(Icons.forum_outlined), selectedIcon: Icon(Icons.forum_rounded), label: 'Prompts'),
              NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights_rounded), label: 'Fortschritt'),
            ],
          ),
        );
      },
    );
  }
}
