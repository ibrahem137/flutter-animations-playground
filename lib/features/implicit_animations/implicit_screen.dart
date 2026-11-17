import 'package:material_ui/material_ui.dart';

import '../../core/widgets/demo_card.dart';

class ImplicitScreen extends StatelessWidget {
  const ImplicitScreen({super.key});
  @override
  Widget build(BuildContext context) => const ScreenBody(
        title: 'Implicit Animations',
        subtitle:
            'Flutter automatically animates property changes between states.',
        child: DemoGrid(
          children: [
            ImplicitDemo(kind: 0),
            ImplicitDemo(kind: 1),
            ImplicitDemo(kind: 2),
            ImplicitDemo(kind: 3),
            ImplicitDemo(kind: 4),
            ImplicitDemo(kind: 5),
            ImplicitDemo(kind: 6),
          ],
        ),
      );
}

class ImplicitDemo extends StatefulWidget {
  const ImplicitDemo({super.key, required this.kind});
  final int kind;
  @override
  State<ImplicitDemo> createState() => _ImplicitDemoState();
}

class _ImplicitDemoState extends State<ImplicitDemo> {
  bool active = false;
  double alignment = -1, progress = .65;
  int duration = 700;
  bool linear = false;
  static const names = [
    'AnimatedContainer',
    'AnimatedOpacity',
    'AnimatedAlign',
    'AnimatedPadding',
    'AnimatedSwitcher',
    'AnimatedSize',
    'TweenAnimationBuilder',
  ];
  static const descriptions = [
    'Animate geometry, color, and corners with one state change.',
    'Fade a book between visible and transparent.',
    'Move a widget inside a bounded area.',
    'See the spacing change inside an outlined boundary.',
    'Switch keyed widgets with a scale and fade.',
    'Reveal book details with a smoothly changing height.',
    'Animate a number toward the slider target.',
  ];
  static const explanations = [
    'AnimatedContainer owns its controller and interpolates supported properties whenever the target changes.',
    'Opacity zero still allows hit testing. IgnorePointer disables interaction while hidden; ExcludeSemantics hides the invisible content from assistive technology.',
    'AnimatedAlign interpolates alignment. The bounded parent provides room to travel.',
    'The outer border stays fixed while AnimatedPadding interpolates the empty space around its child.',
    'Distinct ValueKeys tell AnimatedSwitcher that the child changed. Both outgoing and incoming children can coexist briefly.',
    'AnimatedSize observes child size changes. Its own internal controller animates the size; the content is clipped during the transition.',
    'The Tween defines the value range, duration defines timing, and builder receives each interpolated value. The widget owns the controller and the Tween.',
  ];
  static const snippets = [
    '''AnimatedContainer(
  duration: duration, curve: curve,
  width: expanded ? 210 : 100,
  height: expanded ? 110 : 70,
  decoration: BoxDecoration(
    color: expanded ? purple : cyan,
    borderRadius: BorderRadius.circular(expanded ? 32 : 8),
  ),
)''',
    '''IgnorePointer(
  ignoring: hidden,
  child: AnimatedOpacity(
    opacity: hidden ? 0 : 1,
    duration: duration, child: book,
  ),
)''',
    '''SizedBox(height: 130, child: AnimatedAlign(
  alignment: Alignment(targetX, 0),
  duration: duration, curve: curve, child: book,
))''',
    '''AnimatedPadding(
  padding: EdgeInsets.all(large ? 36 : 8),
  duration: duration, curve: curve,
  child: coloredBox,
)''',
    '''AnimatedSwitcher(
  duration: duration,
  transitionBuilder: (child, a) => FadeTransition(
    opacity: a,
    child: ScaleTransition(scale: a, child: child)),
  child: Icon(on ? Icons.favorite : Icons.favorite_border,
    key: ValueKey(on)),
)''',
    '''AnimatedSize(
  duration: duration, curve: curve,
  child: Column(children: [
    Text('The Flutter Handbook'),
    if (expanded) Text(details),
  ]),
)''',
    '''TweenAnimationBuilder<double>(
  tween: Tween(begin: 0, end: target),
  duration: duration, curve: curve,
  builder: (_, value, __) =>
    CircularProgressIndicator(value: value),
)''',
  ];
  void toggle() => setState(() => active = !active);
  @override
  Widget build(BuildContext context) {
    final d = motionDuration(context, duration);
    final curve = linear ? Curves.linear : Curves.easeInOut;
    late Widget preview;
    late Widget buttons;
    switch (widget.kind) {
      case 0:
        preview = SizedBox(
          height: 140,
          child: Center(
            child: AnimatedContainer(
              duration: d,
              curve: curve,
              width: active ? 210 : 100,
              height: active ? 110 : 70,
              decoration: BoxDecoration(
                color: active ? purple : cyan,
                borderRadius: BorderRadius.circular(active ? 32 : 8),
              ),
              child: const Icon(Icons.bolt, color: Color(0xFF0B1120), size: 34),
            ),
          ),
        );
        buttons = controls([
          action('Toggle', toggle),
          DropdownButton<int>(
            value: duration,
            items: [350, 700, 1200]
                .map((v) => DropdownMenuItem(value: v, child: Text('$v ms')))
                .toList(),
            onChanged: (v) => setState(() => duration = v!),
          ),
          FilterChip(
            label: const Text('Linear'),
            selected: linear,
            onSelected: (v) => setState(() => linear = v),
          ),
        ]);
      case 1:
        preview = SizedBox(
          height: 140,
          child: Center(
            child: IgnorePointer(
              ignoring: active,
              child: ExcludeSemantics(
                excluding: active,
                child: AnimatedOpacity(
                  opacity: active ? 0 : 1,
                  duration: d,
                  curve: curve,
                  child: book(),
                ),
              ),
            ),
          ),
        );
        buttons = action(active ? 'Show' : 'Hide', toggle);
      case 2:
        preview = SizedBox(
          height: 140,
          child: AnimatedAlign(
            alignment: Alignment(alignment, 0),
            duration: d,
            curve: curve,
            child: book(),
          ),
        );
        buttons = controls([
          for (final item in [
            (-1.0, 'Move Left'),
            (0.0, 'Center'),
            (1.0, 'Move Right'),
          ])
            action(item.$2, () => setState(() => alignment = item.$1)),
        ]);
      case 3:
        preview = Container(
          height: 140,
          decoration: BoxDecoration(border: Border.all(color: purple)),
          child: AnimatedPadding(
            duration: d,
            curve: curve,
            padding: EdgeInsets.all(active ? 36 : 8),
            child: Container(color: cyan.withAlpha(75), child: book(size: 36)),
          ),
        );
        buttons = action(active ? 'Small Padding' : 'Large Padding', toggle);
      case 4:
        preview = SizedBox(
          height: 140,
          child: Center(
            child: AnimatedSwitcher(
              duration: d,
              switchInCurve: curve,
              switchOutCurve: curve,
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: ScaleTransition(scale: a, child: child),
              ),
              child: Column(
                key: ValueKey(active),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    active ? Icons.favorite : Icons.favorite_border,
                    size: 54,
                    color: active ? purple : cyan,
                  ),
                  Text(active ? 'Favorite ON' : 'Favorite OFF'),
                ],
              ),
            ),
          ),
        );
        buttons = action('Toggle Favorite', toggle);
      case 5:
        preview = Align(
          alignment: Alignment.topCenter,
          child: AnimatedSize(
            duration: d,
            curve: curve,
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cyan.withAlpha(24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  book(size: 32),
                  const SizedBox(height: 8),
                  const Text('The Flutter Handbook'),
                  if (active)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Build expressive interfaces with widgets, state, and motion.\n\nChapter 7 explores implicit and explicit animations through practical examples.',
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        buttons = action(
          active ? 'Collapse Details' : 'Expand Details',
          toggle,
        );
      default:
        preview = SizedBox(
          height: 140,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: d,
              curve: curve,
              builder: (_, value, __) => SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        color: mint,
                        backgroundColor: Colors.white10,
                      ),
                    ),
                    Text(
                      '${(value * 100).round()}%',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        buttons = Slider(
          value: progress,
          label: '${(progress * 100).round()}%',
          onChanged: (v) => setState(() => progress = v),
        );
    }
    return DemoCard(
      title: names[widget.kind],
      description: descriptions[widget.kind],
      timing: '${d.inMilliseconds} ms · ${linear ? 'linear' : 'easeInOut'}',
      preview: preview,
      controls: buttons,
      explanation: explanations[widget.kind],
      code: snippets[widget.kind],
    );
  }
}
