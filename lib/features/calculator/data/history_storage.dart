import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/calculator_state.dart';

class HistoryStorage {
  static const String _historyKey = 'calculator_history_items';

  Future<List<CalculationHistoryItem>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final rawItems = prefs.getStringList(_historyKey) ?? const [];

    final history = <CalculationHistoryItem>[];
    for (final rawItem in rawItems) {
      try {
        final decoded = jsonDecode(rawItem);
        if (decoded is Map<String, dynamic>) {
          final expression = decoded['expression'];
          final result = decoded['result'];
          if (expression is String && result is String) {
            history.add(
              CalculationHistoryItem(
                expression: expression,
                result: result,
              ),
            );
          }
        }
      } catch (_) {
        continue;
      }
    }

    return history;
  }

  Future<void> saveHistory(List<CalculationHistoryItem> history) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedHistory = history
        .map(
          (item) => jsonEncode({
            'expression': item.expression,
            'result': item.result,
          }),
        )
        .toList(growable: false);

    await prefs.setStringList(_historyKey, encodedHistory);
  }
}
