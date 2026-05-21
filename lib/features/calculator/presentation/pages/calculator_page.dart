import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../domain/entities/calculator_state.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            final isLandscape = size.width > size.height;
            final isTablet = size.shortestSide >= 600;
            final maxContentWidth = isTablet ? 1100.0 : double.infinity;

            final displayMainFontSize = isTablet
                ? (isLandscape ? 56.0 : 64.0)
                : (isLandscape ? 40.0 : 48.0);
            final displaySubFontSize = isTablet
                ? (isLandscape ? 30.0 : 34.0)
                : (isLandscape ? 22.0 : 24.0);
            final buttonHeight = isTablet
                ? (isLandscape ? 82.0 : 90.0)
                : (isLandscape ? 58.0 : 70.0);
            final buttonFontSize = isTablet
                ? (isLandscape ? 30.0 : 32.0)
                : (isLandscape ? 22.0 : 24.0);
            final buttonPadding = isTablet ? 10.0 : 8.0;
            final buttonRadius = isTablet ? 28.0 : 24.0;
            final panelPadding = isTablet ? 20.0 : 16.0;
            final outerPadding = EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 12,
              vertical: isTablet ? 16 : 8,
            );

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: outerPadding,
                  child: isLandscape
                      ? Row(
                          children: [
                            Expanded(
                              flex: isTablet ? 5 : 4,
                              child: _buildDisplayPanel(
                                context: context,
                                state: state,
                                notifier: notifier,
                                theme: theme,
                                horizontalPadding: isTablet ? 32 : 20,
                                verticalPadding: isTablet ? 20 : 12,
                                mainFontSize: displayMainFontSize,
                                subFontSize: displaySubFontSize,
                              ),
                            ),
                            SizedBox(width: isTablet ? 16 : 10),
                            Expanded(
                              flex: isTablet ? 7 : 6,
                              child: _buildButtonsPanel(
                                notifier: notifier,
                                theme: theme,
                                panelPadding: panelPadding,
                                panelRadius: isTablet ? 36 : 28,
                                buttonHeight: buttonHeight,
                                buttonFontSize: buttonFontSize,
                                buttonPadding: buttonPadding,
                                buttonRadius: buttonRadius,
                                allCornersRounded: true,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: isTablet ? 3 : 2,
                              child: _buildDisplayPanel(
                                context: context,
                                state: state,
                                notifier: notifier,
                                theme: theme,
                                horizontalPadding: isTablet ? 36 : 24,
                                verticalPadding: isTablet ? 36 : 32,
                                mainFontSize: displayMainFontSize,
                                subFontSize: displaySubFontSize,
                              ),
                            ),
                            Expanded(
                              flex: isTablet ? 4 : 3,
                              child: _buildButtonsPanel(
                                notifier: notifier,
                                theme: theme,
                                panelPadding: panelPadding,
                                panelRadius: isTablet ? 44 : 40,
                                buttonHeight: buttonHeight,
                                buttonFontSize: buttonFontSize,
                                buttonPadding: buttonPadding,
                                buttonRadius: buttonRadius,
                                allCornersRounded: false,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDisplayPanel({
    required BuildContext context,
    required CalculatorState state,
    required CalculatorNotifier notifier,
    required ThemeData theme,
    required double horizontalPadding,
    required double verticalPadding,
    required double mainFontSize,
    required double subFontSize,
  }) {
    final recentHistory = state.history.isNotEmpty ? state.history.last : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompactHeight = constraints.maxHeight < 260;
          final isUltraCompactHeight = constraints.maxHeight < 200;
          final scaledMainFontSize = isCompactHeight ? mainFontSize * 0.78 : mainFontSize;
          final scaledSubFontSize = isCompactHeight ? subFontSize * 0.8 : subFontSize;
          final showRecentHistory = recentHistory != null && !isCompactHeight;
          final showResult = state.result.isNotEmpty && !isUltraCompactHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'History',
                    constraints: BoxConstraints.tightFor(
                      width: isCompactHeight ? 40 : 48,
                      height: isCompactHeight ? 40 : 48,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => _showHistorySheet(context, state, notifier, theme),
                    icon: Icon(
                      Icons.history_rounded,
                      size: isCompactHeight ? 20 : 24,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (showRecentHistory)
                          Text(
                            '${NumberFormatter.formatExpression(recentHistory.expression)} = ${NumberFormatter.formatResult(recentHistory.result)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        if (showRecentHistory) SizedBox(height: scaledSubFontSize * 0.2),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Text(
                            NumberFormatter.formatExpression(state.expression),
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: scaledMainFontSize,
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
                        ),
                        if (showResult) SizedBox(height: scaledSubFontSize * 0.25),
                        if (showResult)
                          Text(
                            NumberFormatter.formatResult(state.result),
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontSize: scaledSubFontSize,
                              color: theme.colorScheme.primary.withValues(alpha: 0.7),
                            ),
                          ).animate().fadeIn(duration: 300.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showHistorySheet(
    BuildContext context,
    CalculatorState state,
    CalculatorNotifier notifier,
    ThemeData theme,
  ) {
    final history = state.history.reversed.toList(growable: false);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Calculation History',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        if (history.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              notifier.clearHistory();
                              Navigator.of(sheetContext).pop();
                            },
                            child: const Text('Clear All'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (history.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'Belum ada history perhitungan.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: history.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ListTile(
                              title: Text(NumberFormatter.formatExpression(item.expression)),
                              subtitle: Text('= ${NumberFormatter.formatResult(item.result)}'),
                              trailing: const Icon(Icons.north_west_rounded),
                              onTap: () {
                                notifier.useHistoryItem(item);
                                Navigator.of(sheetContext).pop();
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonsPanel({
    required CalculatorNotifier notifier,
    required ThemeData theme,
    required double panelPadding,
    required double panelRadius,
    required double buttonHeight,
    required double buttonFontSize,
    required double buttonPadding,
    required double buttonRadius,
    required bool allCornersRounded,
  }) {
    return Container(
      padding: EdgeInsets.all(panelPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: allCornersRounded
            ? BorderRadius.circular(panelRadius)
            : BorderRadius.vertical(top: Radius.circular(panelRadius)),
      ),
      child: Column(
        children: [
          _buildRow([
            CalcButton(
              label: 'AC',
              onTap: notifier.clear,
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.secondary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: 'DEL',
              onTap: notifier.delete,
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.secondary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '%',
              onTap: () => notifier.append('%'),
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.secondary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '÷',
              onTap: () => notifier.append('÷'),
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.primary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
          ]),
          _buildRow([
            CalcButton(
              label: '7',
              onTap: () => notifier.append('7'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '8',
              onTap: () => notifier.append('8'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '9',
              onTap: () => notifier.append('9'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '×',
              onTap: () => notifier.append('×'),
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.primary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
          ]),
          _buildRow([
            CalcButton(
              label: '4',
              onTap: () => notifier.append('4'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '5',
              onTap: () => notifier.append('5'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '6',
              onTap: () => notifier.append('6'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '-',
              onTap: () => notifier.append('-'),
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.primary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
          ]),
          _buildRow([
            CalcButton(
              label: '1',
              onTap: () => notifier.append('1'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '2',
              onTap: () => notifier.append('2'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '3',
              onTap: () => notifier.append('3'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '+',
              onTap: () => notifier.append('+'),
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              textColor: theme.colorScheme.primary,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
          ]),
          _buildRow([
            CalcButton(
              label: '0',
              onTap: () => notifier.append('0'),
              isLarge: true,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '.',
              onTap: () => notifier.append('.'),
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
            CalcButton(
              label: '=',
              onTap: notifier.calculate,
              color: theme.colorScheme.primary,
              textColor: Colors.white,
              height: buttonHeight,
              fontSize: buttonFontSize,
              padding: buttonPadding,
              borderRadius: buttonRadius,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildRow(List<Widget> children) {
    return Expanded(
      child: Row(
        children: children,
      ),
    );
  }
}
