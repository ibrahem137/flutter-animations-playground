import 'package:material_ui/material_ui.dart';

import '../../app/navigation/transition_settings.dart';
import '../../core/widgets/demo_card.dart';

class TransitionsScreen extends StatelessWidget {
  const TransitionsScreen({super.key, required this.settings});
  final TransitionSettings settings;
  static const icons = [
    Icons.swipe_left,
    Icons.gradient,
    Icons.zoom_in,
    Icons.auto_stories,
  ];
  static const descriptions = [
    'Incoming content slides from right to left.',
    'Outgoing and incoming content cross-fade.',
    'Subtle 0.92 → 1.0 scale with a fade.',
    'Real shared-element flight between two routes. Tabs use Fade.',
  ];
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: settings,
        builder: (context, _) => ScreenBody(
          title: 'Page Transitions',
          subtitle: 'Choose the motion used throughout this session.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DemoGrid(
                children: [
                  for (final type in AppTransitionType.values)
                    Card(
                      color: settings.type == type
                          ? const Color(0xFF163449)
                          : const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: settings.type == type ? cyan : Colors.white10,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => settings.select(type),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Icon(icons[type.index], color: cyan, size: 32),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type == AppTransitionType.hero
                                          ? 'Hero Animation'
                                          : '${type.name.toUpperCase()} Transition',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(descriptions[type.index]),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                settings.type == type
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                semanticLabel: settings.type == type
                                    ? 'Selected'
                                    : 'Not selected',
                                color: cyan,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Transition duration'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  for (final ms in [200, 350, 500])
                    ChoiceChip(
                      label: Text('$ms ms'),
                      selected: settings.milliseconds == ms,
                      onSelected: (_) => settings.setDuration(ms),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              controls([
                action(
                  'Test Transition',
                  () => Navigator.of(context).push(
                      demoRoute(context, settings, const TestDestination())),
                ),
                action(
                  'Open Hero Demo',
                  () => Navigator.of(context).push(
                    demoRoute(
                        context, settings, HeroSource(settings: settings)),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              const Text(
                'Slide, Fade, and Scale apply to all three navigation destinations. '
                'Hero is a shared-element technique, so Hero mode uses Fade for tabs. '
                'Open Hero Demo to fly a real shared book between two Navigator routes. '
                'System reduced-motion preferences override animated durations.',
              ),
              const SizedBox(height: 24),
              DemoCard(
                title: 'Transition implementation',
                description:
                    'Shared session settings drive the shell and test routes.',
                timing:
                    '${settings.duration(context).inMilliseconds} ms · easeInOut',
                preview: const SizedBox(
                  height: 60,
                  child: Center(
                    child: Icon(Icons.swap_horiz, size: 42, color: purple),
                  ),
                ),
                controls: const SizedBox.shrink(),
                explanation:
                    'The shell uses one AnimatedSwitcher. Outgoing content cannot receive input, semantics, or ticker callbacks. '
                    'Distinct destination keys trigger transitions. Controllers inside inactive demos are disposed when outgoing content is removed.',
                code: '''AnimatedSwitcher(
  duration: settings.duration(context),
  transitionBuilder: (child, animation) =>
    transitionFor(settings.type, animation, child),
  child: KeyedSubtree(key: ValueKey(tab), child: screen),
)''',
              ),
            ],
          ),
        ),
      );
}

class TestDestination extends StatelessWidget {
  const TestDestination({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Transition Test')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                book(size: 90),
                const SizedBox(height: 24),
                const Text('The selected transition brought you here.'),
                const SizedBox(height: 16),
                action('Back to Playground', () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      );
}

class HeroSource extends StatelessWidget {
  const HeroSource({super.key, required this.settings});
  final TransitionSettings settings;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Hero · Source')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('A shared book will fly to a larger destination.'),
              const SizedBox(height: 24),
              const HeroBook(size: 80),
              const SizedBox(height: 24),
              action(
                'Fly to Details',
                () => Navigator.of(context).push(
                    demoRoute(context, settings, const HeroDestination())),
              ),
              const SizedBox(height: 16),
              const Text(
                'Matching tags across two routes. One Hero per route. Return to reverse the flight.',
              ),
              const SizedBox(height: 16),
              const SelectableText(
                "Hero(tag: 'playground-book', child: BookLogo(size: size))\nNavigator.of(context).push(route);",
                style: TextStyle(fontFamily: 'monospace', color: mint),
              ),
            ],
          ),
        ),
      );
}

class HeroBook extends StatelessWidget {
  const HeroBook({super.key, required this.size});
  final double size;
  @override
  Widget build(BuildContext context) => Hero(
        tag: 'playground-book',
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFF163449),
              borderRadius: BorderRadius.circular(20),
            ),
            child: book(size: size * .6),
          ),
        ),
      );
}

class HeroDestination extends StatelessWidget {
  const HeroDestination({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Hero · Details')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const HeroBook(size: 220),
                const SizedBox(height: 32),
                const Text('Same book. New route.'),
                const SizedBox(height: 16),
                action('Return Book', () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      );
}
