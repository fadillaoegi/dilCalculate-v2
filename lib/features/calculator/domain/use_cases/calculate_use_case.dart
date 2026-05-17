import 'package:math_expressions/math_expressions.dart';

class CalculateUseCase {
  String execute(String expression) {
    try {
      // Replace symbols for math_expressions compatibility
      String finalExpression = expression.replaceAll('×', '*').replaceAll('÷', '/');
      
      final p = ShuntingYardParser();
      final exp = p.parse(finalExpression);
      
      final eval = RealEvaluator().evaluate(exp);
      
      // Format the result
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      return eval.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
    } catch (e) {
      return 'Error';
    }
  }
}
