import 'package:flutter/material.dart';
import '../services/app_state.dart';

class LibraryScreen extends StatefulWidget {
  final AppState state;
  const LibraryScreen({super.key, required this.state});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String query = '';
  String category = 'All';

  @override
  Widget build(BuildContext context) {
    final results = widget.state.cards.where((c) {
      final matchesCategory = category == 'All' || c.category == category;
      final haystack = '${c.front} ${c.back} ${c.example} ${c.category}'.toLowerCase();
      return matchesCategory && haystack.contains(query.toLowerCase());
    }).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 110), children: [
      TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), labelText: 'Begriffe, Formulierungen oder Beispiele suchen'), onChanged: (v) => setState(() => query = v)),
      const SizedBox(height: 10),
      DropdownButtonFormField<String>(value: category, decoration: const InputDecoration(labelText: 'Lernpfad'), items: ['All', ...widget.state.categories].map((c) => DropdownMenuItem(value: c, child: Text(c == 'All' ? 'Alle Lernpfade' : c))).toList(), onChanged: (v) => setState(() => category = v ?? 'All')),
      const SizedBox(height: 14),
      Text('${results.length} Karten', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      ...results.take(250).map((card) {
        final p = widget.state.cardProgress(card.id);
        return Card(
          child: ExpansionTile(
            leading: Icon(card.type == 'Vocabulary' ? Icons.translate_rounded : card.type == 'Collocation' ? Icons.link_rounded : Icons.forum_rounded),
            title: Text(card.front, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text('${card.category} • ${card.type}', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(onPressed: () => widget.state.toggleFavourite(card), icon: Icon(p.favourite ? Icons.star_rounded : Icons.star_border_rounded)),
            childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            children: [Align(alignment: Alignment.centerLeft, child: Text(card.back, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary))), if (card.example.isNotEmpty) ...[const SizedBox(height: 10), Align(alignment: Alignment.centerLeft, child: Text(card.example))]],
          ),
        );
      }),
      if (results.length > 250) const Padding(padding: EdgeInsets.all(16), child: Text('Die Anzeige ist auf 250 Treffer begrenzt. Nutze die Suche oder den Lernpfadfilter.')),
    ]);
  }
}
