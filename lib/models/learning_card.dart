class LearningCard {
  final String id;
  final String category;
  final String type;
  final String front;
  final String back;
  final String example;
  final String hint;
  final List<String> tags;

  const LearningCard({
    required this.id,
    required this.category,
    required this.type,
    required this.front,
    required this.back,
    required this.example,
    required this.hint,
    required this.tags,
  });

  factory LearningCard.fromJson(Map<String, dynamic> json) => LearningCard(
        id: json['id'] as String,
        category: json['category'] as String,
        type: json['type'] as String,
        front: json['front'] as String,
        back: json['back'] as String,
        example: json['example'] as String? ?? '',
        hint: json['hint'] as String? ?? '',
        tags: (json['tags'] as List<dynamic>? ?? const [])
            .map((e) => e.toString())
            .toList(),
      );
}

class CardProgress {
  int intervalDays;
  int dueAt;
  int attempts;
  int known;
  bool favourite;
  int lapses;

  CardProgress({
    this.intervalDays = 0,
    this.dueAt = 0,
    this.attempts = 0,
    this.known = 0,
    this.favourite = false,
    this.lapses = 0,
  });

  bool get isNew => attempts == 0;
  bool get isDue => dueAt <= DateTime.now().millisecondsSinceEpoch;
  bool get isMastered => intervalDays >= 30 && known >= 3;

  Map<String, dynamic> toJson() => {
        'intervalDays': intervalDays,
        'dueAt': dueAt,
        'attempts': attempts,
        'known': known,
        'favourite': favourite,
        'lapses': lapses,
      };

  factory CardProgress.fromJson(Map<String, dynamic> json) => CardProgress(
        intervalDays: json['intervalDays'] as int? ?? 0,
        dueAt: json['dueAt'] as int? ?? 0,
        attempts: json['attempts'] as int? ?? 0,
        known: json['known'] as int? ?? 0,
        favourite: json['favourite'] as bool? ?? false,
        lapses: json['lapses'] as int? ?? 0,
      );
}

class ConversationPrompt {
  final String title;
  final String category;
  final String level;
  final String prompt;

  const ConversationPrompt({required this.title, required this.category, required this.level, required this.prompt});

  factory ConversationPrompt.fromJson(Map<String, dynamic> json) => ConversationPrompt(
        title: json['title'] as String,
        category: json['category'] as String,
        level: json['level'] as String,
        prompt: json['prompt'] as String,
      );
}
