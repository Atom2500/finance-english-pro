import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../widgets/stat_tile.dart';

class StatsScreen extends StatelessWidget {
  final AppState state;
  const StatsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 110), children: [
      Text('Fortschritt', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 14),
      GridView.count(crossAxisCount: MediaQuery.sizeOf(context).width > 650 ? 4 : 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.25, children: [
        StatTile(value: '${state.reviewedCount}', label: 'bearbeitet', icon: Icons.layers_rounded),
        StatTile(value: '${state.masteredCount}', label: 'gemeistert', icon: Icons.verified_rounded),
        StatTile(value: '${state.difficultCount}', label: 'schwierig', icon: Icons.priority_high_rounded),
        StatTile(value: '${state.favouriteCount}', label: 'Favoriten', icon: Icons.star_rounded),
      ]),
      const SizedBox(height: 22),
      ...state.categories.map((category) {
        final total = state.cards.where((c) => c.category == category).length;
        final reviewed = state.cards.where((c) => c.category == category && state.cardProgress(c.id).attempts > 0).length;
        final mastered = state.cards.where((c) => c.category == category && state.cardProgress(c.id).isMastered).length;
        return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(category, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 9),
          LinearProgressIndicator(value: total == 0 ? 0 : reviewed / total, minHeight: 8, borderRadius: BorderRadius.circular(99)),
          const SizedBox(height: 7),
          Text('$reviewed von $total bearbeitet • $mastered gemeistert', style: Theme.of(context).textTheme.bodySmall),
        ])));
      }),
      const SizedBox(height: 18),
      OutlinedButton.icon(onPressed: () => _confirmReset(context), icon: const Icon(Icons.restart_alt_rounded), label: const Text('Lernfortschritt zurücksetzen')),
    ]);
  }

  Future<void> _confirmReset(BuildContext context) async {
    final confirm = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: const Text('Fortschritt zurücksetzen?'), content: const Text('Alle Bewertungen, Fälligkeiten, Favoriten und Lerntage werden gelöscht.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Zurücksetzen'))]));
    if (confirm == true) await state.reset();
  }
}
