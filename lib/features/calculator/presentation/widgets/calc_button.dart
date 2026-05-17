import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final bool isLarge;

  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Expanded(
      flex: isLarge ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          elevation: 2,
          shadowColor: Colors.black26,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 70,
              alignment: Alignment.center,
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: textColor ?? theme.colorScheme.onSurface,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ).animate(onInit: (controller) => controller.forward(from: 0))
         .scale(begin: const Offset(1, 1), end: const Offset(0.95, 0.95), duration: 100.ms, curve: Curves.easeInOut)
         .then()
         .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 100.ms),
      ),
    );
  }
}
