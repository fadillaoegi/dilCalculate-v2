import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import '../../data/history_storage.dart';
import '../../domain/entities/calculator_state.dart';
import '../../domain/use_cases/calculate_use_case.dart';

final calculateUseCaseProvider = Provider((ref) => CalculateUseCase());
final historyStorageProvider = Provider((ref) => HistoryStorage());

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  final notifier = CalculatorNotifier(
    ref.watch(calculateUseCaseProvider),
    ref.watch(historyStorageProvider),
  );
  notifier.loadHistory();
  return notifier;
});

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculateUseCase _calculateUseCase;
  final HistoryStorage _historyStorage;
  static const int _maxHistoryItems = 50;

  CalculatorNotifier(this._calculateUseCase, this._historyStorage) : super(CalculatorState.initial());

  void append(String char) {
    // If appending a function like 'sin(', 'log(', etc. we don't treat it as a basic operator.
    final isBasicOperator = ['+', '-', '×', '÷', '%', '.'].contains(char);

    if (isBasicOperator && state.expression.isNotEmpty) {
      final lastChar = state.expression.characters.last;
      final isLastCharOperator = ['+', '-', '×', '÷', '%', '.'].contains(lastChar);
      
      if (isLastCharOperator) {
        // Prevent consecutive operators
        return;
      }
    }

    if (state.expression == '0' && !isBasicOperator && char != '.') {
      state = state.copyWith(expression: char);
    } else {
      state = state.copyWith(expression: state.expression + char);
    }
    _autoCalculate();
  }

  void plusMinus() {
    if (state.expression == '0' || state.expression.isEmpty) return;
    
    // Toggle logic for the expression (simplistic wrapper)
    if (state.expression.startsWith('-')) {
      state = state.copyWith(expression: state.expression.substring(1));
    } else {
      state = state.copyWith(expression: '-${state.expression}');
    }
    _autoCalculate();
  }

  void toggleRadianMode() {
    state = state.copyWith(isRadianMode: !state.isRadianMode);
    _autoCalculate();
  }

  void toggleScientificMode() {
    state = state.copyWith(isScientificExpanded: !state.isScientificExpanded);
  }

  void toggleInverseMode() {
    state = state.copyWith(isInverseMode: !state.isInverseMode);
  }

  void clear() {
    state = state.copyWith(expression: '0', result: '');
  }

  void delete() {
    if (state.expression.length <= 1) {
      state = state.copyWith(expression: '0', result: '');
    } else {
      state = state.copyWith(
        expression: state.expression.substring(0, state.expression.length - 1),
      );
      _autoCalculate();
    }
  }

  void calculate() {
    final expression = state.expression;
    final result = _calculateUseCase.execute(state.expression, isRadianMode: state.isRadianMode);
    if (result != 'Error') {
      _addToHistory(expression, result);
      state = state.copyWith(expression: result, result: '');
    }
  }

  void clearHistory() {
    state = state.copyWith(history: const []);
    _persistHistory();
  }

  void useHistoryItem(CalculationHistoryItem item) {
    state = state.copyWith(expression: item.result, result: '');
  }

  void _autoCalculate() {
    // Only calculate if the last character is a number or if it looks like a valid expression
    final lastChar = state.expression.characters.last;
    if (RegExp(r'[0-9)]').hasMatch(lastChar) || ['π', 'e'].contains(lastChar)) {
      final result = _calculateUseCase.execute(state.expression, isRadianMode: state.isRadianMode);
      if (result != 'Error' && result != state.expression) {
        state = state.copyWith(result: result);
      } else {
        state = state.copyWith(result: '');
      }
    } else {
      state = state.copyWith(result: '');
    }
  }

  void _addToHistory(String expression, String result) {
    if (expression.trim().isEmpty || result.trim().isEmpty) {
      return;
    }

    final item = CalculationHistoryItem(expression: expression, result: result);
    final currentHistory = state.history;

    if (currentHistory.isNotEmpty) {
      final lastItem = currentHistory.last;
      final isDuplicate = lastItem.expression == item.expression && lastItem.result == item.result;
      if (isDuplicate) {
        return;
      }
    }

    final updatedHistory = [...currentHistory, item];
    final trimmedHistory = updatedHistory.length > _maxHistoryItems
        ? updatedHistory.sublist(updatedHistory.length - _maxHistoryItems)
        : updatedHistory;

    state = state.copyWith(history: trimmedHistory);
    _persistHistory();
  }

  Future<void> loadHistory() async {
    final history = await _historyStorage.loadHistory();
    if (!mounted) {
      return;
    }
    state = state.copyWith(history: history);
  }

  void _persistHistory() {
    _historyStorage.saveHistory(state.history);
  }
}
