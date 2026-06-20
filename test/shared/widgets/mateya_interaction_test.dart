import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/widgets/mateya_interaction.dart';
import 'package:mateya_app/shared/widgets/mateya_motion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('MateyaPressable triggers tap callback', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MateyaPressable(
            onTap: () => tapped = true,
            enableHapticFeedback: false,
            borderRadius: BorderRadius.circular(12),
            child: const SizedBox(width: 80, height: 40),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(MateyaPressable));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('MateyaFadeSlideSwitcher swaps keyed children', (tester) async {
    var first = true;

    Widget buildApp() {
      return MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        first = !first;
                      });
                    },
                    child: const Text('toggle'),
                  ),
                  Expanded(
                    child: MateyaFadeSlideSwitcher(
                      child: ColoredBox(
                        key: ValueKey<bool>(first),
                        color: first ? Colors.red : Colors.blue,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }

    await tester.pumpWidget(buildApp());
    expect(find.byKey(const ValueKey<bool>(true)), findsOneWidget);

    await tester.tap(find.text('toggle'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));

    expect(find.byKey(const ValueKey<bool>(false)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
