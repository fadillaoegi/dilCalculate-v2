import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

class CalculateUseCase {
  String execute(String expression, {bool isRadianMode = true}) {
    try {
      if (expression.isEmpty) return '';

      // 1. Basic Replacements
      String finalExpr = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', 'pi')
          .replaceAll('e', 'e')
          .replaceAll('arcsin', 'asin')
          .replaceAll('arccos', 'acos')
          .replaceAll('arctan', 'atan');

      // 2. Percentages (simple replacement, assumes X% means X/100)
      finalExpr = finalExpr.replaceAll('%', '/100');

      // 3. Parse AST
      final p = ShuntingYardParser();
      Expression exp = p.parse(finalExpr);

      // 4. Transform AST for DEG mode if needed
      if (!isRadianMode) {
        exp = _convertToDegreeMode(exp);
      }

      final cm = ContextModel();
      cm.bindVariable(Variable('pi'), Number(math.pi));
      cm.bindVariable(Variable('e'), Number(math.e));

      // 5. Evaluate
      final eval = RealEvaluator(cm).evaluate(exp);
      
      if (eval.isNaN || eval.isInfinite) return 'Error';
      
      // 6. Format
      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      }
      return eval.toStringAsFixed(8).replaceAll(RegExp(r'\.?0+$'), '');
    } catch (e) {
      return 'Error';
    }
  }

  Expression _convertToDegreeMode(Expression exp) {
    return exp;
  }
}
