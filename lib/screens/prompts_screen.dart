import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/app_state.dart';

class PromptsScreen extends StatelessWidget {
  final AppState state;
  const PromptsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 110), children: [
      Text('Gesprächstraining', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      Text('Keine künstliche Browserstimme. Diese Prompts sind für echte, frei reagierende Sprachgespräche mit einem KI-Tutor vorbereitet.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5)),
      const SizedBox(height: 16),
      ...state.prompts.map((p) => Card(
        child: ExpansionTile(
          title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${p.category} • ${p.level}'),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          children: [
            Align(alignment: Alignment.centerLeft, child: SelectableText(p.prompt, style: const TextStyle(height: 1.5))),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () async {await Clipboard.setData(ClipboardData(text: p.prompt)); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tutor-Prompt kopiert.')));}, icon: const Icon(Icons.copy_rounded), label: const Text('Prompt kopieren'))),
          ],
        ),
      )),
    ]);
  }
}
