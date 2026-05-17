import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import '../../domain/entities/calculator_state.dart';
import '../../domain/use_cases/calculate_use_case.dart';

final calculateUseCaseProvider = Provider((ref) => CalculateUseCase());

final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier(ref.watch(calculateUseCaseProvider));
});

class CalculatorNotifier extends StateNotifier<CalculatorState> {
  final CalculateUseCase _calculateUseCase;

  CalculatorNotifier(this._calculateUseCase) : super(CalculatorState.initial());

  void append(String char) {
    if (state.expression == '0' && !['+', '-', '×', '÷', '.'].contains(char)) {
      state = state.copyWith(expression: char);
    } else {
      state = state.copyWith(expression: state.expression + char);
    }
    _autoCalculate();
  }

  void clear() {
    state = CalculatorState.initial();
  }

  void delete() {
    if (state.expression.length <= 1) {
      state = CalculatorState.initial();
    } else {
      state = state.copyWith(
        expression: state.expression.substring(0, state.expression.length - 1),
      );
      _autoCalculate();
    }
  }

  void calculate() {
    final result = _calculateUseCase.execute(state.expression);
    if (result != 'Error') {
      state = state.copyWith(expression: result, result: '');
    }
  }

  void _autoCalculate() {
    // Only calculate if the last character is a number or if it looks like a valid expression
    final lastChar = state.expression.characters.last;
    if (RegExp(r'[0-9]').hasMatch(lastChar)) {
      final result = _calculateUseCase.execute(state.expression);
      if (result != 'Error' && result != state.expression) {
        state = state.copyWith(result: result);
      } else {
        state = state.copyWith(result: '');
      }
    }
  }
}
