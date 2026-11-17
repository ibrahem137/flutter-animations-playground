import 'package:material_ui/material_ui.dart';

import '../core/widgets/demo_card.dart';
import '../features/implicit_animations/implicit_screen.dart';
import '../features/explicit_animations/explicit_screen.dart';
import '../features/page_transitions/transitions_screen.dart';
import 'navigation/transition_settings.dart';

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Animations Playground',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: cyan,
            secondary: purple,
            surface: Color(0xFF111827),
            onSurface: Color(0xFFF8FAFC),
          ),
          scaffoldBackgroundColor: const Color(0xFF0B1120),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0B1120)),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFF111827),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
          ),
        ),
        home: const PlaygroundShell(),
      );
}

class PlaygroundShell extends StatefulWidget {
  const PlaygroundShell({super.key});
  @override
  State<PlaygroundShell> createState() => _PlaygroundShellState();
}

class _PlaygroundShellState extends State<PlaygroundShell> {
  final settings = TransitionSettings();
  int tab = 0;
  @override
  void dispose() {
    settings.dispose();
    super.dispose();
  }

  void select(int index) {
    if (index != tab) setState(() => tab = index);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          final wide = MediaQuery.sizeOf(context).width >= 1000;
          final screen = switch (tab) {
            0 => const ImplicitScreen(),
            1 => const ExplicitScreen(),
            _ => TransitionsScreen(settings: settings),
          };
          // Reinstall the transition builder only when mode changes. Changing tabs
          // keeps the same builder so existing flights retain their transition.
          final transitionBuilder = _builders[settings.type]!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Animations Playground'),
              actions: [
                IconButton(
                  tooltip: 'Animation performance guide',
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const PerformanceDialog(),
                  ),
                  icon: const Icon(Icons.info_outline),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: SafeArea(
              child: Row(
                children: [
                  if (wide) ...[
                    NavigationRail(
                      selectedIndex: tab,
                      onDestinationSelected: select,
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.auto_awesome),
                          label: Text('Implicit'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.tune),
                          label: Text('Explicit'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.swap_horiz),
                          label: Text('Transitions'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                  ],
                  Expanded(
                    child: ClipRect(
                      child: AnimatedSwitcher(
                        duration: settings.duration(context),
                        reverseDuration: settings.duration(context),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: transitionBuilder,
                        layoutBuilder: (current, previous) => Stack(
                          fit: StackFit.expand,
                          children: [
                            for (final old in previous)
                              Positioned.fill(
                                child: ExcludeSemantics(
                                  child: IgnorePointer(
                                    child:
                                        TickerMode(enabled: false, child: old),
                                  ),
                                ),
                              ),
                            if (current != null)
                              Positioned.fill(child: current),
                          ],
                        ),
                        child: KeyedSubtree(key: ValueKey(tab), child: screen),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: wide
                ? null
                : NavigationBar(
                    selectedIndex: tab,
                    onDestinationSelected: select,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.auto_awesome),
                        label: 'Implicit',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.tune),
                        label: 'Explicit',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.swap_horiz),
                        label: 'Transitions',
                      ),
                    ],
                  ),
          );
        },
      );
  static final _builders =
      <AppTransitionType, AnimatedSwitcherTransitionBuilder>{
    for (final type in AppTransitionType.values)
      type: (child, animation) => transitionFor(type, animation, child),
  };
}

class PerformanceDialog extends StatelessWidget {
  const PerformanceDialog({super.key});
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Animation Performance'),
        content: const SingleChildScrollView(
          child: Text(
            'Educational guidance · no live FPS measurement\n\n'
            'Implicit: simple state-driven property changes.\n'
            'Explicit: direct playback and timing control.\n\n'
            'Frame budget\n60 Hz ≈ 16.67 ms per frame\n120 Hz ≈ 8.33 ms per frame\n\n'
            'Avoid expensive work during animation frames. Isolate frequently rebuilt widgets. '
            'Use AnimatedBuilder.child for stable subtrees. It does not eliminate all painting or layout cost.\n\n'
            'Layout-heavy animations can cost more than transforms. Use RepaintBoundary only when profiling shows a benefit. '
            'Test real devices in Profile Mode with Flutter DevTools.\n\n'
            'Reduced motion: implicit and navigation durations become zero; explicit playback jumps to endpoints '
            'and repeat is disabled. Ticker muting suppresses callbacks but does not freeze elapsed time.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      );
}
