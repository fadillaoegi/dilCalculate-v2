class CalculatorState {
  final String expression;
  final String result;

  const CalculatorState({
    required this.expression,
    required this.result,
  });

  factory CalculatorState.initial() {
    return const CalculatorState(
      expression: '0',
      result: '',
    );
  }

  CalculatorState copyWith({
    String? expression,
    String? result,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
    );
  }
}
