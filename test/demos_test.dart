import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animations_playground/features/implicit_animations/implicit_screen.dart';
import 'package:flutter_animations_playground/features/explicit_animations/explicit_screen.dart';

Widget host(Widget child) => MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );

void main() {
  testWidgets('implicit target properties and keyed content change', (
    tester,
  ) async {
    await tester.pumpWidget(host(const ImplicitDemo(kind: 1)));
    await tester.tap(find.text('Hide'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      0,
    );
    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
      1,
    );

    await tester.pumpWidget(
      host(const ImplicitDemo(key: ValueKey(2), kind: 2)),
    );
    await tester.tap(find.text('Move Right'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AnimatedAlign>(find.byType(AnimatedAlign)).alignment,
      Alignment.centerRight,
    );

    await tester.pumpWidget(
      host(const ImplicitDemo(key: ValueKey(3), kind: 3)),
    );
    await tester.tap(find.text('Large Padding'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<AnimatedPadding>(find.byType(AnimatedPadding)).padding,
      const EdgeInsets.all(36),
    );

    await tester.pumpWidget(
      host(const ImplicitDemo(key: ValueKey(4), kind: 4)),
    );
    await tester.tap(find.text('Toggle Favorite'));
    await tester.pumpAndSettle();
    expect(find.text('Favorite ON'), findsOneWidget);
    expect(find.text('Favorite OFF'), findsNothing);

    await tester.pumpWidget(
      host(const ImplicitDemo(key: ValueKey(5), kind: 5)),
    );
    await tester.tap(find.text('Expand Details'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chapter 7'), findsOneWidget);
    await tester.tap(find.text('Collapse Details'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chapter 7'), findsNothing);

    await tester.pumpWidget(
      host(const ImplicitDemo(key: ValueKey(6), kind: 6)),
    );
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(1);
    await tester.pumpAndSettle();
    expect(find.text('100%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit building blocks and combined demo play and reset', (
    tester,
  ) async {
    for (final kind in [1, 2, 3, 4, 5]) {
      await tester.pumpWidget(
        host(ExplicitDemo(key: ValueKey(kind), kind: kind)),
      );
      final start = find.text(kind == 2 ? 'Replay' : 'Start');
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Reset'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('ticker mode changes while animation runs', (tester) async {
    await tester.pumpWidget(host(const TickerDemo()));
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.ensureVisible(find.byType(Switch));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Ticker callbacks: muted'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(find.text('Ticker callbacks: enabled'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
