import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../domain/entities/calculator_state.dart';
import '../providers/calculator_provider.dart';
import '../widgets/calc_button.dart';

class CalculatorPage extends ConsumerWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final currentThemeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);
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
                                currentThemeMode: currentThemeMode,
                                onThemeModeChange: (mode) {
                                  themeModeNotifier.state = mode;
                                },
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
                                state: state,
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
                                currentThemeMode: currentThemeMode,
                                onThemeModeChange: (mode) {
                                  themeModeNotifier.state = mode;
                                },
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
                                state: state,
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
    required ThemeMode currentThemeMode,
    required ValueChanged<ThemeMode> onThemeModeChange,
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
          final scaledMainFontSize = isCompactHeight
              ? mainFontSize * 0.78
              : mainFontSize;
          final scaledSubFontSize = isCompactHeight
              ? subFontSize * 0.8
              : subFontSize;
          final showRecentHistory = recentHistory != null && !isCompactHeight;
          final showResult = state.result.isNotEmpty && !isUltraCompactHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Scientific Mode',
                    constraints: BoxConstraints.tightFor(
                      width: isCompactHeight ? 40 : 48,
                      height: isCompactHeight ? 40 : 48,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: notifier.toggleScientificMode,
                    icon: Icon(
                      state.isScientificExpanded
                          ? Icons.science
                          : Icons.science_outlined,
                      size: isCompactHeight ? 20 : 24,
                      color: state.isScientificExpanded
                          ? theme.colorScheme.primary
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'History',
                    constraints: BoxConstraints.tightFor(
                      width: isCompactHeight ? 40 : 48,
                      height: isCompactHeight ? 40 : 48,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        _showHistorySheet(context, state, notifier, theme),
                    icon: Icon(
                      Icons.history_rounded,
                      size: isCompactHeight ? 20 : 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildThemeButton(
                    tooltip: _themeTooltip(currentThemeMode, theme.brightness),
                    icon: _themeIcon(currentThemeMode, theme.brightness),
                    isActive: true,
                    compact: isCompactHeight,
                    onTap: () => onThemeModeChange(
                      _nextThemeMode(currentThemeMode, theme.brightness),
                    ),
                    theme: theme,
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
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.55,
                              ),
                            ),
                          ),
                        if (showRecentHistory)
                          SizedBox(height: scaledSubFontSize * 0.2),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child:
                              Text(
                                    NumberFormatter.formatExpression(
                                      state.expression,
                                    ),
                                    style: theme.textTheme.displayLarge
                                        ?.copyWith(
                                          fontSize: scaledMainFontSize,
                                        ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 400.ms)
                                  .slideX(begin: 0.2),
                        ),
                        if (showResult)
                          SizedBox(height: scaledSubFontSize * 0.25),
                        if (showResult)
                          Text(
                            NumberFormatter.formatResult(state.result),
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontSize: scaledSubFontSize,
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.7,
                              ),
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
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final sheetBackground = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surface;
    final tileBackground = isDark
        ? colorScheme.surfaceContainer
        : colorScheme.surface;
    final titleColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: sheetBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                            color: titleColor,
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
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ListTile(
                              title: Text(
                                NumberFormatter.formatExpression(
                                  item.expression,
                                ),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '= ${NumberFormatter.formatResult(item.result)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: subtitleColor,
                                ),
                              ),
                              tileColor: tileBackground,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              trailing: Icon(
                                Icons.north_west_rounded,
                                color: theme.colorScheme.primary,
                              ),
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

  Widget _buildThemeButton({
    required String tooltip,
    required IconData icon,
    required bool isActive,
    required bool compact,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final bgColor = isActive
        ? activeColor.withValues(alpha: 0.16)
        : theme.colorScheme.surface.withValues(alpha: 0.35);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: compact ? 34 : 40,
          height: compact ? 34 : 40,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? activeColor.withValues(alpha: 0.45)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            icon,
            size: compact ? 18 : 20,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }

  ThemeMode _nextThemeMode(
    ThemeMode currentMode,
    Brightness effectiveBrightness,
  ) {
    if (currentMode == ThemeMode.dark) return ThemeMode.light;
    if (currentMode == ThemeMode.light) return ThemeMode.dark;
    return effectiveBrightness == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  }

  IconData _themeIcon(ThemeMode currentMode, Brightness effectiveBrightness) {
    final isDark =
        currentMode == ThemeMode.dark ||
        (currentMode == ThemeMode.system &&
            effectiveBrightness == Brightness.dark);
    return isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded;
  }

  String _themeTooltip(ThemeMode currentMode, Brightness effectiveBrightness) {
    final nextMode = _nextThemeMode(currentMode, effectiveBrightness);
    return nextMode == ThemeMode.dark
        ? 'Switch to Dark Theme'
        : 'Switch to Light Theme';
  }

  Widget _buildButtonsPanel({
    required CalculatorState state,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final useScrollableScientificLayout =
            state.isScientificExpanded && constraints.maxHeight < 560;

        return Container(
          padding: EdgeInsets.all(panelPadding),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.3),
            borderRadius: allCornersRounded
                ? BorderRadius.circular(panelRadius)
                : BorderRadius.vertical(top: Radius.circular(panelRadius)),
          ),
          child: useScrollableScientificLayout
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildScientificPanel(
                        state: state,
                        notifier: notifier,
                        theme: theme,
                        buttonHeight: buttonHeight,
                        buttonFontSize: buttonFontSize,
                        buttonPadding: buttonPadding,
                        buttonRadius: buttonRadius,
                      ),
                      ..._buildMainRows(
                        notifier: notifier,
                        theme: theme,
                        buttonHeight: buttonHeight,
                        buttonFontSize: buttonFontSize,
                        buttonPadding: buttonPadding,
                        buttonRadius: buttonRadius,
                        expandVertically: false,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildScientificPanel(
                      state: state,
                      notifier: notifier,
                      theme: theme,
                      buttonHeight: buttonHeight,
                      buttonFontSize: buttonFontSize,
                      buttonPadding: buttonPadding,
                      buttonRadius: buttonRadius,
                    ),
                    ..._buildMainRows(
                      notifier: notifier,
                      theme: theme,
                      buttonHeight: buttonHeight,
                      buttonFontSize: buttonFontSize,
                      buttonPadding: buttonPadding,
                      buttonRadius: buttonRadius,
                      expandVertically: true,
                    ),
                  ],
                ),
        );
      },
    );
  }

  List<Widget> _buildMainRows({
    required CalculatorNotifier notifier,
    required ThemeData theme,
    required double buttonHeight,
    required double buttonFontSize,
    required double buttonPadding,
    required double buttonRadius,
    required bool expandVertically,
  }) {
    return [
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
      ], expandVertically: expandVertically),
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
      ], expandVertically: expandVertically),
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
      ], expandVertically: expandVertically),
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
      ], expandVertically: expandVertically),
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
      ], expandVertically: expandVertically),
    ];
  }

  Widget _buildScientificPanel({
    required CalculatorState state,
    required CalculatorNotifier notifier,
    required ThemeData theme,
    required double buttonHeight,
    required double buttonFontSize,
    required double buttonPadding,
    required double buttonRadius,
  }) {
    if (!state.isScientificExpanded) return const SizedBox.shrink();

    final h = (buttonHeight * 0.70).clamp(44.0, 64.0).toDouble();
    final fs = buttonFontSize * 0.70;
    final color = theme.colorScheme.secondary.withValues(alpha: 0.1);
    final textCol = theme.colorScheme.secondary;
    final inv = state.isInverseMode;

    return Column(
      children: [
        _buildRow([
          CalcButton(
            label: state.isRadianMode ? 'RAD' : 'DEG',
            onTap: notifier.toggleRadianMode,
            height: h,
            fontSize: fs * 0.8,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
            textColor: theme.colorScheme.tertiary,
          ),
          CalcButton(
            label: inv ? 'asin' : 'sin',
            onTap: () => notifier.append(inv ? 'asin(' : 'sin('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: inv ? 'acos' : 'cos',
            onTap: () => notifier.append(inv ? 'acos(' : 'cos('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: inv ? 'atan' : 'tan',
            onTap: () => notifier.append(inv ? 'atan(' : 'tan('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: 'π',
            onTap: () => notifier.append('π'),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
        ], expandVertically: false),
        _buildRow([
          CalcButton(
            label: '!',
            onTap: () => notifier.append('!'),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: inv ? 'e^x' : 'ln',
            onTap: () => notifier.append(inv ? 'e^' : 'ln('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: inv ? '10^x' : 'log',
            onTap: () => notifier.append(inv ? '10^' : 'log('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: 'e',
            onTap: () => notifier.append('e'),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: '^',
            onTap: () => notifier.append('^'),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
        ], expandVertically: false),
        _buildRow([
          CalcButton(
            label: '(',
            onTap: () => notifier.append('('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: ')',
            onTap: () => notifier.append(')'),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: '√',
            onTap: () => notifier.append('√('),
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: '±',
            onTap: notifier.plusMinus,
            height: h,
            fontSize: fs,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: color,
            textColor: textCol,
          ),
          CalcButton(
            label: 'INV',
            onTap: notifier.toggleInverseMode,
            height: h,
            fontSize: fs * 0.8,
            padding: buttonPadding,
            borderRadius: buttonRadius,
            color: inv
                ? theme.colorScheme.tertiary.withValues(alpha: 0.3)
                : theme.colorScheme.tertiary.withValues(alpha: 0.1),
            textColor: theme.colorScheme.tertiary,
          ),
        ], expandVertically: false),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildRow(List<Widget> children, {bool expandVertically = true}) {
    final row = Row(children: children);
    if (!expandVertically) {
      return row;
    }

    return Expanded(child: row);
  }
}
