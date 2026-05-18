class NumberFormatter {
  static String formatExpression(String expr) {
    if (expr.isEmpty) return '0';
    if (expr == '0') return '0';
    
    // Split the expression by mathematical operators to format each number individually
    final regex = RegExp(r'([+\-×÷%])');
    final parts = expr.split(regex);
    final operators = regex.allMatches(expr).map((m) => m.group(0)!).toList();

    final formattedParts = parts.map((part) {
      if (part.isEmpty) return part;
      
      // If there is a decimal dot, split it
      final subParts = part.split('.');
      final integerPart = subParts[0];
      
      // Format the integer part with thousands separators
      final formattedInt = _formatThousands(integerPart);
      
      if (subParts.length > 1) {
        // Return with Indonesian comma separator for decimals
        return '$formattedInt,${subParts.sublist(1).join(',')}';
      }
      return formattedInt;
    }).toList();

    // Reconstruct the expression with original operators
    final sb = StringBuffer();
    for (var i = 0; i < formattedParts.length; i++) {
      sb.write(formattedParts[i]);
      if (i < operators.length) {
        sb.write(operators[i]);
      }
    }
    return sb.toString();
  }

  static String formatResult(String result) {
    if (result.isEmpty || result == 'Error') return result;
    
    final subParts = result.split('.');
    final integerPart = subParts[0];
    final formattedInt = _formatThousands(integerPart);
    
    if (subParts.length > 1) {
      return '$formattedInt,${subParts.sublist(1).join(',')}';
    }
    return formattedInt;
  }

  static String _formatThousands(String numberStr) {
    if (numberStr.isEmpty) return numberStr;
    
    // Handle minus sign if any
    final isNegative = numberStr.startsWith('-');
    final cleanStr = isNegative ? numberStr.substring(1) : numberStr;
    
    // Format using regex to insert dots as thousands separators
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = cleanStr.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    
    return isNegative ? '-$formatted' : formatted;
  }
}
