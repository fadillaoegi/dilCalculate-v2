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
  final bool isRadianMode;
  final bool isScientificExpanded;
  final bool isInverseMode; // for secondary functions like asin, acos

  const CalculatorState({
    required this.expression,
    required this.result,
    required this.history,
    this.isRadianMode = false,
    this.isScientificExpanded = false,
    this.isInverseMode = false,
  });

  factory CalculatorState.initial() {
    return const CalculatorState(
      expression: '0',
      result: '',
      history: [],
      isRadianMode: false,
      isScientificExpanded: false,
      isInverseMode: false,
    );
  }

  CalculatorState copyWith({
    String? expression,
    String? result,
    List<CalculationHistoryItem>? history,
    bool? isRadianMode,
    bool? isScientificExpanded,
    bool? isInverseMode,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      history: history ?? this.history,
      isRadianMode: isRadianMode ?? this.isRadianMode,
      isScientificExpanded: isScientificExpanded ?? this.isScientificExpanded,
      isInverseMode: isInverseMode ?? this.isInverseMode,
    );
  }
}
