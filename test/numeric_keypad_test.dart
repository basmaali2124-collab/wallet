import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_app/features/transactions/presentation/add_transaction/widgets/numeric_keypad.dart';

void main() {
  late List<String> events;

  Future<void> showKeypad(WidgetTester tester) async {
    events = [];

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: NumericKeypad(
                onKeyPressed: (key) => events.add(key),
                onBackspace: () => events.add('backspace'),
                onClear: () => events.add('clear'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('tapping number keys sends them in order', (tester) async {
    await showKeypad(tester);

    await tester.tap(find.byKey(const Key('key_1')));
    await tester.tap(find.byKey(const Key('key_5')));

    expect(events, ['1', '5']);
  });

  testWidgets('tapping the dot sends a dot', (tester) async {
    await showKeypad(tester);

    await tester.tap(find.byKey(const Key('key_.')));

    expect(events, ['.']);
  });

  testWidgets('tapping backspace calls onBackspace', (tester) async {
    await showKeypad(tester);

    await tester.tap(find.byKey(const Key('key_backspace')));

    expect(events, ['backspace']);
  });

  testWidgets('long press on backspace calls onClear', (tester) async {
    await showKeypad(tester);

    await tester.longPress(find.byKey(const Key('key_backspace')));

    expect(events, ['clear']);
  });
}
