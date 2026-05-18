import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/number_formatter.dart';
import '../providers/calculator_provider.dart';
import '../widgets/calc_button.dart';

class CalculatorPage extends ConsumerWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        NumberFormatter.formatExpression(state.expression),
                        style: theme.textTheme.displayLarge,
                      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
                    ),
                    const SizedBox(height: 8),
                    if (state.result.isNotEmpty)
                      Text(
                        NumberFormatter.formatResult(state.result),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: theme.colorScheme.primary.withValues(alpha: 0.7),
                        ),
                      ).animate().fadeIn(duration: 300.ms),
                  ],
                ),
              ),
            ),

            // Buttons Area
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    _buildRow([
                      CalcButton(label: 'AC', onTap: notifier.clear, color: theme.colorScheme.secondary.withValues(alpha: 0.1), textColor: theme.colorScheme.secondary),
                      CalcButton(label: 'DEL', onTap: notifier.delete, color: theme.colorScheme.secondary.withValues(alpha: 0.1), textColor: theme.colorScheme.secondary),
                      CalcButton(label: '%', onTap: () => notifier.append('%'), color: theme.colorScheme.secondary.withValues(alpha: 0.1), textColor: theme.colorScheme.secondary),
                      CalcButton(label: '÷', onTap: () => notifier.append('÷'), color: theme.colorScheme.primary.withValues(alpha: 0.1), textColor: theme.colorScheme.primary),
                    ]),
                    _buildRow([
                      CalcButton(label: '7', onTap: () => notifier.append('7')),
                      CalcButton(label: '8', onTap: () => notifier.append('8')),
                      CalcButton(label: '9', onTap: () => notifier.append('9')),
                      CalcButton(label: '×', onTap: () => notifier.append('×'), color: theme.colorScheme.primary.withValues(alpha: 0.1), textColor: theme.colorScheme.primary),
                    ]),
                    _buildRow([
                      CalcButton(label: '4', onTap: () => notifier.append('4')),
                      CalcButton(label: '5', onTap: () => notifier.append('5')),
                      CalcButton(label: '6', onTap: () => notifier.append('6')),
                      CalcButton(label: '-', onTap: () => notifier.append('-'), color: theme.colorScheme.primary.withValues(alpha: 0.1), textColor: theme.colorScheme.primary),
                    ]),
                    _buildRow([
                      CalcButton(label: '1', onTap: () => notifier.append('1')),
                      CalcButton(label: '2', onTap: () => notifier.append('2')),
                      CalcButton(label: '3', onTap: () => notifier.append('3')),
                      CalcButton(label: '+', onTap: () => notifier.append('+'), color: theme.colorScheme.primary.withValues(alpha: 0.1), textColor: theme.colorScheme.primary),
                    ]),
                    _buildRow([
                      CalcButton(label: '0', onTap: () => notifier.append('0'), isLarge: true),
                      CalcButton(label: '.', onTap: () => notifier.append('.')),
                      CalcButton(label: '=', onTap: notifier.calculate, color: theme.colorScheme.primary, textColor: Colors.white),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
