import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/learning_card.dart';

class CardRepository {
  Future<List<LearningCard>> loadCards() async {
    final raw = await rootBundle.loadString('assets/data/cards.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => LearningCard.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ConversationPrompt>> loadPrompts() async {
    final raw = await rootBundle.loadString('assets/data/conversation_prompts.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => ConversationPrompt.fromJson(e as Map<String, dynamic>)).toList();
  }
}
