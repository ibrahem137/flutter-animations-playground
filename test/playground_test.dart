import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animations_playground/app/app.dart';
import 'package:flutter_animations_playground/app/navigation/transition_settings.dart';
import 'package:flutter_animations_playground/features/implicit_animations/implicit_screen.dart';
import 'package:flutter_animations_playground/features/explicit_animations/explicit_screen.dart';
import 'package:flutter_animations_playground/features/page_transitions/transitions_screen.dart';

void main() {
  test('session settings retain selected mode and duration', () {
    final settings = TransitionSettings();
    var changes = 0;
    settings.addListener(() => changes++);
    settings.select(AppTransitionType.scale);
    settings.setDuration(500);
    expect(settings.type, AppTransitionType.scale);
    expect(settings.milliseconds, 500);
    expect(changes, 2);
    settings.dispose();
  });

  testWidgets('seven real implicit examples render at mobile width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PlaygroundApp());
    expect(find.byType(ImplicitDemo), findsNWidgets(7));
    await tester.tap(find.text('Toggle').first);
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('global mode survives tabs and Hero uses real routes', (
    tester,
  ) async {
    await tester.pumpWidget(const PlaygroundApp());
    await tester.tap(find.text('Transitions').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('FADE Transition'));
    await tester.tap(find.text('FADE Transition'));
    await tester.tap(find.text('Explicit').last);
    await tester.pumpAndSettle();
    expect(find.byType(ExplicitDemo), findsNWidgets(6));
    await tester.tap(find.text('Transitions').last);
    await tester.pumpAndSettle();
    final screen = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, '350 ms'),
    );
    expect(screen.selected, isTrue);
    await tester.ensureVisible(find.text('Open Hero Demo'));
    await tester.tap(find.text('Open Hero Demo'));
    await tester.pumpAndSettle();
    expect(find.byType(Hero), findsOneWidget);
    await tester.tap(find.text('Fly to Details'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(find.text('Same book. New route.'), findsOneWidget);
    await tester.tap(find.text('Return Book'));
    await tester.pumpAndSettle();
    expect(find.text('Fly to Details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit controller controls restart and dispose safely', (
    tester,
  ) async {
    await tester.pumpWidget(const PlaygroundApp());
    await tester.tap(find.text('Explicit').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Play').first);
    await tester.tap(find.text('Play').first);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.ensureVisible(find.text('Pause').first);
    await tester.tap(find.text('Pause').first);
    await tester.pump();
    expect(find.textContaining('Stopped · Forward'), findsOneWidget);
    await tester.tap(find.text('Reverse').first);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Reset').first);
    await tester.pump();
    expect(find.text('Value 0.00 · dismissed'), findsOneWidget);
    await tester.ensureVisible(find.text('Repeat').first);
    await tester.tap(find.text('Repeat').first);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Implicit').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion and narrow landscape avoid overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(667, 375);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(667, 375),
            disableAnimations: true,
          ),
          child: const PlaygroundShell(),
        ),
      ),
    );
    await tester.tap(find.text('Explicit').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Play').first);
    await tester.tap(find.text('Play').first);
    await tester.pump();
    expect(find.text('Value 1.00 · completed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('all global transitions retain selection and duration', (
    tester,
  ) async {
    await tester.pumpWidget(const PlaygroundApp());
    for (final mode in AppTransitionType.values) {
      await tester.tap(find.text('Transitions').last);
      await tester.pumpAndSettle();
      final option = find.text(
        mode == AppTransitionType.hero
            ? 'Hero Animation'
            : '${mode.name.toUpperCase()} Transition',
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.ensureVisible(find.text('500 ms'));
      await tester.tap(find.text('500 ms'));
      await tester.tap(find.text('Implicit').last);
      await tester.pump(const Duration(milliseconds: 100));
      final switcher = tester.widget<AnimatedSwitcher>(
        find.byType(AnimatedSwitcher).first,
      );
      expect(switcher.duration, const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Transitions').last);
      await tester.pumpAndSettle();
      final selected = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, '500 ms'),
      );
      expect(selected.selected, isTrue);
      // The settings instance is shell-owned, not recreated with the screen.
      final panel = tester.widget<TransitionsScreen>(
        find.byType(TransitionsScreen),
      );
      expect(panel.settings.type, mode);
    }
    expect(tester.takeException(), isNull);
  });
}
