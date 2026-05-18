import 'package:flutter_test/flutter_test.dart';
import 'package:dilcalculate/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter Tests', () {
    test('formatExpression formats integer numbers correctly', () {
      expect(NumberFormatter.formatExpression('1000'), '1.000');
      expect(NumberFormatter.formatExpression('10000'), '10.000');
      expect(NumberFormatter.formatExpression('1234567'), '1.234.567');
      expect(NumberFormatter.formatExpression('0'), '0');
    });

    test('formatExpression formats decimals correctly', () {
      expect(NumberFormatter.formatExpression('1000.5'), '1.000,5');
      expect(NumberFormatter.formatExpression('1234567.89'), '1.234.567,89');
      expect(NumberFormatter.formatExpression('0.25'), '0,25');
    });

    test('formatExpression formats complex math expressions with thousands separators', () {
      expect(
        NumberFormatter.formatExpression('1000+5000'),
        '1.000+5.000',
      );
      expect(
        NumberFormatter.formatExpression('1234567-234567'),
        '1.234.567-234.567',
      );
      expect(
        NumberFormatter.formatExpression('1000.5×2000.25'),
        '1.000,5×2.000,25',
      );
    });

    test('formatResult formats math calculation output correctly', () {
      expect(NumberFormatter.formatResult('1000'), '1.000');
      expect(NumberFormatter.formatResult('10000.5'), '10.000,5');
      expect(NumberFormatter.formatResult('Error'), 'Error');
    });
  });
}
