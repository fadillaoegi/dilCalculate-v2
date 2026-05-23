import re

with open('lib/features/calculator/presentation/pages/calculator_page.dart', 'r') as f:
    content = f.read()

# 1. Add toggle scientific button to Display Panel next to history button
history_button = """                  IconButton(
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
                  ),"""

new_buttons = """                  IconButton(
                    tooltip: 'Scientific Mode',
                    constraints: BoxConstraints.tightFor(
                      width: isCompactHeight ? 40 : 48,
                      height: isCompactHeight ? 40 : 48,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: notifier.toggleScientificMode,
                    icon: Icon(
                      state.isScientificExpanded ? Icons.science : Icons.science_outlined,
                      size: isCompactHeight ? 20 : 24,
                      color: state.isScientificExpanded ? theme.colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(width: 8),
""" + history_button

content = content.replace(history_button, new_buttons)


# 2. Inject _buildScientificPanel function
scientific_panel_func = """  Widget _buildScientificPanel({
    required CalculatorState state,
    required CalculatorNotifier notifier,
    required ThemeData theme,
    required double buttonHeight,
    required double buttonFontSize,
    required double buttonPadding,
    required double buttonRadius,
  }) {
    if (!state.isScientificExpanded) return const SizedBox.shrink();
    
    final h = buttonHeight * 0.70;
    final fs = buttonFontSize * 0.70;
    final color = theme.colorScheme.secondary.withValues(alpha: 0.1);
    final textCol = theme.colorScheme.secondary;
    final inv = state.isInverseMode;
    
    return Column(
      children: [
        _buildRow([
          CalcButton(label: state.isRadianMode ? 'RAD' : 'DEG', onTap: notifier.toggleRadianMode, height: h, fontSize: fs * 0.8, padding: buttonPadding, borderRadius: buttonRadius, color: theme.colorScheme.tertiary.withValues(alpha: 0.2), textColor: theme.colorScheme.tertiary),
          CalcButton(label: inv ? 'asin' : 'sin', onTap: () => notifier.append(inv ? 'asin(' : 'sin('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: inv ? 'acos' : 'cos', onTap: () => notifier.append(inv ? 'acos(' : 'cos('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: inv ? 'atan' : 'tan', onTap: () => notifier.append(inv ? 'atan(' : 'tan('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: 'π', onTap: () => notifier.append('π'), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
        ]),
        _buildRow([
          CalcButton(label: '!', onTap: () => notifier.append('!'), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: inv ? 'e^x' : 'ln', onTap: () => notifier.append(inv ? 'e^' : 'ln('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: inv ? '10^x' : 'log', onTap: () => notifier.append(inv ? '10^' : 'log('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: 'e', onTap: () => notifier.append('e'), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: '^', onTap: () => notifier.append('^'), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
        ]),
        _buildRow([
          CalcButton(label: '(', onTap: () => notifier.append('('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: ')', onTap: () => notifier.append(')'), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: '√', onTap: () => notifier.append('√('), height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: '±', onTap: notifier.plusMinus, height: h, fontSize: fs, padding: buttonPadding, borderRadius: buttonRadius, color: color, textColor: textCol),
          CalcButton(label: 'INV', onTap: notifier.toggleInverseMode, height: h, fontSize: fs * 0.8, padding: buttonPadding, borderRadius: buttonRadius, color: inv ? theme.colorScheme.tertiary.withValues(alpha: 0.3) : theme.colorScheme.tertiary.withValues(alpha: 0.1), textColor: theme.colorScheme.tertiary),
        ]),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildRow(List<Widget> children) {
"""

content = content.replace("  Widget _buildRow(List<Widget> children) {", scientific_panel_func)


# 3. Add scientific panel to _buildButtonsPanel
old_build_buttons_panel_start = """  Widget _buildButtonsPanel({
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
        children: ["""

new_build_buttons_panel_start = """  Widget _buildButtonsPanel({
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
          _buildScientificPanel(
            state: state,
            notifier: notifier,
            theme: theme,
            buttonHeight: buttonHeight,
            buttonFontSize: buttonFontSize,
            buttonPadding: buttonPadding,
            buttonRadius: buttonRadius,
          ),"""

content = content.replace(old_build_buttons_panel_start, new_build_buttons_panel_start)

# We need to pass `state` into `_buildButtonsPanel` calls.
# Call 1 (Landscape)
content = content.replace("""                              child: _buildButtonsPanel(
                                notifier: notifier,""", """                              child: _buildButtonsPanel(
                                state: state,
                                notifier: notifier,""")

# Call 2 (Portrait)
content = content.replace("""                              child: _buildButtonsPanel(
                                notifier: notifier,""", """                              child: _buildButtonsPanel(
                                state: state,
                                notifier: notifier,""")

with open('lib/features/calculator/presentation/pages/calculator_page.dart', 'w') as f:
    f.write(content)

