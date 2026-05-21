class CalculationHistoryItem {
  final String expression;
  final String result;

  const CalculationHistoryItem({
    required this.expression,
    required this.result,
  });
}

class CalculatorState {
  final String expression;
  final String result;
  final List<CalculationHistoryItem> history;

  const CalculatorState({
    required this.expression,
    required this.result,
    required this.history,
  });

  factory CalculatorState.initial() {
    return const CalculatorState(
      expression: '0',
      result: '',
      history: [],
    );
  }

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<CalculationHistoryItem>? history,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
    );
  }
}
