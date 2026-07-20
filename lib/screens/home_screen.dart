import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/stat_tile.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onStartDue;
  final VoidCallback onStartNew;
  const HomeScreen({super.key, required this.state, required this.onStartDue, required this.onStartNew});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
      children: [
        Text('Finance English Pro', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Professionelles Englisch für Accounting, Finance und Einkauf', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 22),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer]),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Heute lernen', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('${state.dueCount} Karten sind fällig. Der Schwerpunkt liegt bewusst auf aktivem Erinnern statt auf zufälligen Multiple-Choice-Fragen.'),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: FilledButton.icon(onPressed: onStartDue, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Fällige Karten'))),
              const SizedBox(width: 10),
              Expanded(child: OutlinedButton.icon(onPressed: onStartNew, icon: const Icon(Icons.add_rounded), label: const Text('Neue Karten'))),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.25,
          children: [
            StatTile(value: '${state.dueCount}', label: 'heute fällig', icon: Icons.schedule_rounded),
            StatTile(value: '${state.masteredCount}', label: 'gemeistert', icon: Icons.verified_rounded),
            StatTile(value: '${state.streak}', label: 'Tage Serie', icon: Icons.local_fire_department_rounded),
            StatTile(value: '${(state.knownRate * 100).round()}%', label: 'Gewusst-Quote', icon: Icons.analytics_rounded),
          ],
        ),
        const SizedBox(height: 24),
        Text('Lernstruktur', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text('${state.cards.length} sorgfältig strukturierte Lernkarten aus Fachbegriffen, Kollokationen, aktiver Übersetzung und beruflichen Reaktionen. Keine Browserstimme, kein zufälliges Antwort-Mischen.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
        const SizedBox(height: 16),
        ...state.categories.take(8).map((category) {
          final total = state.cards.where((c) => c.category == category).length;
          final mastered = state.cards.where((c) => c.category == category && state.cardProgress(c.id).isMastered).length;
          final ratio = total == 0 ? 0.0 : mastered / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Expanded(child: Text(category, style: const TextStyle(fontWeight: FontWeight.w600))), Text('$mastered / $total')]),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: ratio, minHeight: 8, borderRadius: BorderRadius.circular(99)),
            ]),
          );
        }),
      ],
    );
  }
}
