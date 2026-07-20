import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/learning_card.dart';
import 'card_repository.dart';
import 'storage_service.dart';

enum ReviewRating { unknown, unsure, known }
enum StudyFilter { due, newCards, all, favourites, difficult }

class AppState extends ChangeNotifier {
  final CardRepository repository;
  final StorageService storage;

  AppState({required this.repository, required this.storage});

  bool loading = true;
  List<LearningCard> cards = [];
  List<ConversationPrompt> prompts = [];
  Map<String, CardProgress> progress = {};
  Set<String> studyDates = {};

  Future<void> initialise() async {
    cards = await repository.loadCards();
    prompts = await repository.loadPrompts();
    progress = await storage.loadProgress();
    studyDates = await storage.loadStudyDates();
    for (final card in cards) {
      progress.putIfAbsent(card.id, CardProgress.new);
    }
    loading = false;
    notifyListeners();
  }

  CardProgress cardProgress(String id) => progress.putIfAbsent(id, CardProgress.new);

  List<String> get categories {
    final values = cards.map((e) => e.category).toSet().toList()..sort();
    return values;
  }

  List<LearningCard> buildStudyQueue({required String category, required StudyFilter filter, int limit = 30}) {
    Iterable<LearningCard> result = cards;
    if (category != 'All') result = result.where((c) => c.category == category);
    switch (filter) {
      case StudyFilter.due:
        result = result.where((c) => cardProgress(c.id).isDue);
        break;
      case StudyFilter.newCards:
        result = result.where((c) => cardProgress(c.id).isNew);
        break;
      case StudyFilter.favourites:
        result = result.where((c) => cardProgress(c.id).favourite);
        break;
      case StudyFilter.difficult:
        result = result.where((c) => cardProgress(c.id).lapses > 0 || (cardProgress(c.id).attempts > 1 && cardProgress(c.id).known * 2 < cardProgress(c.id).attempts));
        break;
      case StudyFilter.all:
        break;
    }
    final list = result.toList();
    list.shuffle(Random());
    return list.take(limit).toList();
  }

  Future<void> rate(LearningCard card, ReviewRating rating) async {
    final p = cardProgress(card.id);
    p.attempts += 1;
    final now = DateTime.now();
    switch (rating) {
      case ReviewRating.unknown:
        p.lapses += 1;
        p.intervalDays = 0;
        p.dueAt = now.add(const Duration(minutes: 8)).millisecondsSinceEpoch;
        break;
      case ReviewRating.unsure:
        p.intervalDays = max(1, p.intervalDays == 0 ? 1 : (p.intervalDays * 1.4).round());
        p.dueAt = now.add(Duration(days: p.intervalDays)).millisecondsSinceEpoch;
        break;
      case ReviewRating.known:
        p.known += 1;
        if (p.intervalDays == 0) {
          p.intervalDays = 3;
        } else if (p.intervalDays < 7) {
          p.intervalDays = 7;
        } else {
          p.intervalDays = min(180, (p.intervalDays * 2.1).round());
        }
        p.dueAt = now.add(Duration(days: p.intervalDays)).millisecondsSinceEpoch;
        break;
    }
    await storage.saveProgress(progress);
    await storage.addStudyDate(now);
    studyDates = await storage.loadStudyDates();
    notifyListeners();
  }

  Future<void> toggleFavourite(LearningCard card) async {
    final p = cardProgress(card.id);
    p.favourite = !p.favourite;
    await storage.saveProgress(progress);
    notifyListeners();
  }

  int get dueCount => cards.where((c) => cardProgress(c.id).isDue).length;
  int get newCount => cards.where((c) => cardProgress(c.id).isNew).length;
  int get masteredCount => cards.where((c) => cardProgress(c.id).isMastered).length;
  int get favouriteCount => cards.where((c) => cardProgress(c.id).favourite).length;
  int get difficultCount => cards.where((c) => cardProgress(c.id).lapses > 0).length;
  int get reviewedCount => cards.where((c) => cardProgress(c.id).attempts > 0).length;

  double get knownRate {
    final attempted = progress.values.fold<int>(0, (sum, p) => sum + p.attempts);
    final known = progress.values.fold<int>(0, (sum, p) => sum + p.known);
    return attempted == 0 ? 0 : known / attempted;
  }

  int get streak {
    var count = 0;
    var day = DateTime.now();
    while (studyDates.contains(_dateKey(day))) {
      count += 1;
      day = day.subtract(const Duration(days: 1));
    }
    if (count == 0) {
      day = DateTime.now().subtract(const Duration(days: 1));
      while (studyDates.contains(_dateKey(day))) {
        count += 1;
        day = day.subtract(const Duration(days: 1));
      }
    }
    return count;
  }

  Future<void> reset() async {
    await storage.reset();
    progress = {for (final card in cards) card.id: CardProgress()};
    studyDates = {};
    notifyListeners();
  }

  static String _dateKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
