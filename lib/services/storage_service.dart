import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/learning_card.dart';

class StorageService {
  static const _progressKey = 'finance_english_progress_v1';
  static const _studyDatesKey = 'finance_english_study_dates_v1';

  Future<Map<String, CardProgress>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_progressKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, CardProgress.fromJson(value as Map<String, dynamic>)));
  }

  Future<void> saveProgress(Map<String, CardProgress> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(progress.map((k, v) => MapEntry(k, v.toJson()))));
  }

  Future<Set<String>> loadStudyDates() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_studyDatesKey) ?? const []).toSet();
  }

  Future<void> addStudyDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final dates = (prefs.getStringList(_studyDatesKey) ?? <String>[]).toSet();
    dates.add(_dateKey(date));
    await prefs.setStringList(_studyDatesKey, dates.toList()..sort());
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_studyDatesKey);
  }

  static String _dateKey(DateTime d) => '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
