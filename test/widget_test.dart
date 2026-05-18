import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dilcalculate/main.dart';

void main() {
  testWidgets('Calculator UI renders and functions correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MainApp(),
      ),
    );

    // Wait for the initialization animations to finish
    await tester.pumpAndSettle();

    // Verify that the initial state shows '0' in the display, and there's a '0' button
    expect(find.text('0'), findsNWidgets(2));

    // Verify that we have the calculator buttons (7, 8, 9, etc.)
    expect(find.text('7'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);

    // Tap '7' and then '8'
    await tester.tap(find.text('7'));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();

    // The display expression should show '78'
    expect(find.text('78'), findsOneWidget);
  });
}
