import 'package:flutter/material.dart';
import '../models/learning_card.dart';

class FlashcardPanel extends StatelessWidget {
  final LearningCard card;
  final bool revealed;
  final bool reverse;
  final bool favourite;
  final VoidCallback onReveal;
  final VoidCallback onFavourite;

  const FlashcardPanel({
    super.key,
    required this.card,
    required this.revealed,
    required this.reverse,
    required this.favourite,
    required this.onReveal,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final front = reverse ? card.back : card.front;
    final back = reverse ? card.front : card.back;
    return GestureDetector(
      onTap: onReveal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        constraints: const BoxConstraints(minHeight: 360),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surfaceContainerHighest,
              Theme.of(context).colorScheme.surfaceContainer,
            ],
          ),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          boxShadow: const [BoxShadow(blurRadius: 30, offset: Offset(0, 16), color: Color(0x33000000))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(child: Text('${card.category}  •  ${card.type}', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary))),
              IconButton(onPressed: onFavourite, icon: Icon(favourite ? Icons.star_rounded : Icons.star_border_rounded)),
            ]),
            const Spacer(),
            Text(front, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.25)),
            const SizedBox(height: 28),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 180),
              crossFadeState: revealed ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Column(children: [
                Icon(Icons.touch_app_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(height: 8),
                Text('Tippen, um die Antwort zu zeigen', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ]),
              secondChild: Column(children: [
                Text(back, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary)),
                if (card.example.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface.withOpacity(.55), borderRadius: BorderRadius.circular(16)),
                    child: Text(card.example, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45)),
                  ),
                ],
              ]),
            ),
            const Spacer(),
            if (card.hint.isNotEmpty) Text(card.hint, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
