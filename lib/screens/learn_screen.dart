import 'package:flutter/material.dart';
import '../models/learning_card.dart';
import '../services/app_state.dart';
import '../widgets/flashcard_panel.dart';

class LearnScreen extends StatefulWidget {
  final AppState state;
  final StudyFilter initialFilter;
  const LearnScreen({super.key, required this.state, this.initialFilter = StudyFilter.due});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String category = 'All';
  late StudyFilter filter;
  bool reverse = false;
  bool revealed = false;
  int index = 0;
  int sessionKnown = 0;
  int sessionUnknown = 0;
  List<LearningCard> queue = [];

  @override
  void initState() {
    super.initState();
    filter = widget.initialFilter;
    _buildQueue();
  }

  void _buildQueue() {
    queue = widget.state.buildStudyQueue(category: category, filter: filter, limit: 50);
    index = 0;
    revealed = false;
  }

  Future<void> _rate(ReviewRating rating) async {
    if (index >= queue.length) return;
    final card = queue[index];
    await widget.state.rate(card, rating);
    if (rating == ReviewRating.known) sessionKnown++;
    if (rating == ReviewRating.unknown) sessionUnknown++;
    setState(() { index++; revealed = false; });
  }

  @override
  Widget build(BuildContext context) {
    final finished = index >= queue.length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 130),
      children: [
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Lernpfad'), items: ['All', ...widget.state.categories].map((c) => DropdownMenuItem(value: c, child: Text(c == 'All' ? 'Alle Lernpfade' : c, overflow: TextOverflow.ellipsis))).toList(), onChanged: (v) {category = v ?? 'All'; setState(_buildQueue);})),
          const SizedBox(width: 10),
          Expanded(child: DropdownButtonFormField<StudyFilter>(value: filter, decoration: const InputDecoration(labelText: 'Auswahl'), items: const [
            DropdownMenuItem(value: StudyFilter.due, child: Text('Fällig')),
            DropdownMenuItem(value: StudyFilter.newCards, child: Text('Neu')),
            DropdownMenuItem(value: StudyFilter.difficult, child: Text('Schwierig')),
            DropdownMenuItem(value: StudyFilter.favourites, child: Text('Favoriten')),
            DropdownMenuItem(value: StudyFilter.all, child: Text('Alle')),
          ], onChanged: (v) {filter = v ?? StudyFilter.due; setState(_buildQueue);})),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: LinearProgressIndicator(value: queue.isEmpty ? 0 : index / queue.length, minHeight: 8, borderRadius: BorderRadius.circular(99))),
          const SizedBox(width: 12),
          Text('${index.clamp(0, queue.length)} / ${queue.length}'),
          IconButton(tooltip: 'Richtung wechseln', onPressed: () => setState(() => reverse = !reverse), icon: const Icon(Icons.swap_horiz_rounded)),
        ]),
        const SizedBox(height: 14),
        if (queue.isEmpty)
          _EmptyState(onRefresh: () => setState(_buildQueue))
        else if (finished)
          _FinishedState(known: sessionKnown, unknown: sessionUnknown, onRestart: () => setState(_buildQueue))
        else ...[
          FlashcardPanel(
            card: queue[index],
            revealed: revealed,
            reverse: reverse,
            favourite: widget.state.cardProgress(queue[index].id).favourite,
            onReveal: () => setState(() => revealed = true),
            onFavourite: () => widget.state.toggleFavourite(queue[index]),
          ),
          const SizedBox(height: 14),
          if (!revealed)
            FilledButton.icon(onPressed: () => setState(() => revealed = true), icon: const Icon(Icons.visibility_rounded), label: const Text('Antwort zeigen'))
          else
            Row(children: [
              Expanded(child: _RatingButton(label: 'Nicht gewusst', icon: Icons.close_rounded, color: const Color(0xFFB4233F), onTap: () => _rate(ReviewRating.unknown))),
              const SizedBox(width: 8),
              Expanded(child: _RatingButton(label: 'Unsicher', icon: Icons.remove_rounded, color: const Color(0xFF9A6700), onTap: () => _rate(ReviewRating.unsure))),
              const SizedBox(width: 8),
              Expanded(child: _RatingButton(label: 'Gewusst', icon: Icons.check_rounded, color: const Color(0xFF137A52), onTap: () => _rate(ReviewRating.known))),
            ]),
        ],
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _RatingButton({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => FilledButton.tonalIcon(onPressed: onTap, icon: Icon(icon), label: Text(label, textAlign: TextAlign.center), style: FilledButton.styleFrom(backgroundColor: color.withOpacity(.18), foregroundColor: color, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 6)));
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyState({required this.onRefresh});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 90), child: Column(children: [const Icon(Icons.task_alt_rounded, size: 56), const SizedBox(height: 18), Text('Für diese Auswahl sind keine Karten verfügbar.', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 12), OutlinedButton(onPressed: onRefresh, child: const Text('Neu laden'))]));
}

class _FinishedState extends StatelessWidget {
  final int known;
  final int unknown;
  final VoidCallback onRestart;
  const _FinishedState({required this.known, required this.unknown, required this.onRestart});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 70), child: Column(children: [const Icon(Icons.verified_rounded, size: 64), const SizedBox(height: 18), Text('Lernrunde abgeschlossen', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 12), Text('$known gewusst  •  $unknown nicht gewusst'), const SizedBox(height: 22), FilledButton(onPressed: onRestart, child: const Text('Neue Runde starten'))]));
}
