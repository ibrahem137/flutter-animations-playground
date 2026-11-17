import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../core/widgets/demo_card.dart';

class ExplicitScreen extends StatelessWidget {
  const ExplicitScreen({super.key});
  @override
  Widget build(BuildContext context) => const ScreenBody(
        title: 'Explicit Animations',
        subtitle:
            'Directly control animation timing, values, playback, and lifecycle.',
        child: Column(
          children: [
            DemoGrid(
              children: [
                ExplicitDemo(kind: 0),
                ExplicitDemo(kind: 1),
                ExplicitDemo(kind: 2),
                ExplicitDemo(kind: 3),
                TickerDemo(),
              ],
            ),
            SizedBox(height: 20),
            ExplicitDemo(kind: 5),
          ],
        ),
      );
}

class TickerDemo extends StatefulWidget {
  const TickerDemo({super.key});
  @override
  State<TickerDemo> createState() => _TickerDemoState();
}

class _TickerDemoState extends State<TickerDemo> {
  bool enabled = true;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          TickerMode(enabled: enabled, child: const ExplicitDemo(kind: 4)),
          SwitchListTile(
            title: const Text('Ticker callbacks enabled'),
            value: enabled,
            subtitle: const Text(
              'Muting is not pausing: elapsed time still passes.',
            ),
            onChanged: (v) => setState(() => enabled = v),
          ),
        ],
      );
}

class ExplicitDemo extends StatefulWidget {
  const ExplicitDemo({super.key, required this.kind});
  final int kind;
  @override
  State<ExplicitDemo> createState() => _ExplicitDemoState();
}

class _ExplicitDemoState extends State<ExplicitDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late CurvedAnimation curved;
  late Animation<double> interpolated;
  bool reduced = false;
  String selectedCurve = 'EaseInOut';
  static const curves = <String, Curve>{
    'Linear': Curves.linear,
    'EaseIn': Curves.easeIn,
    'EaseOut': Curves.easeOut,
    'EaseInOut': Curves.easeInOut,
    'BounceOut': Curves.bounceOut,
  };
  static const names = [
    'AnimationController',
    'Tween',
    'CurvedAnimation',
    'AnimatedBuilder',
    'TickerProvider / vsync',
    'Putting Everything Together',
  ];
  static const descriptions = [
    'Own time and playback, then observe the live value.',
    'Map normalized progress to a position between A and B.',
    'Compare a linear baseline with an eased animation.',
    'Animate a transform while reusing a stable child.',
    'Connect the controller to frame-synchronized callbacks.',
    'A coordinated book animation built from all five building blocks.',
  ];
  static const explanations = [
    'The controller produces values over time. Play continues forward; Pause preserves the current value; Reverse changes direction; Reset returns to zero. Repeat runs back and forth until stopped. The controller is disposed with this State.',
    'Tween<double>(begin: 0, end: 1) maps animation progress to a normalized position. LayoutBuilder converts that result into available horizontal travel. A Tween does not control time.',
    'Both dots share one controller and duration. The second uses a real CurvedAnimation. Easing redistributes progress over time without changing the endpoint or total duration.',
    'AnimatedBuilder runs its builder on animation notifications. Its child is created outside that callback and reused. This avoids rebuilding that subtree, but layout and painting costs can still exist.',
    'SingleTickerProviderStateMixin supplies a ticker to this controller through vsync. The ancestor TickerMode can mute its callbacks. Elapsed time still passes while muted, so resuming may jump ahead. This does not change the display refresh rate.',
    'TickerProvider supplies a ticker to AnimationController. CurvedAnimation transforms its progress; Tween maps the curved progress into a value range. AnimatedBuilder listens and uses those values to transform its stable child.',
  ];
  static const snippets = [
    '''class _DemoState extends State<Demo>
    with SingleTickerProviderStateMixin {
  late final c = AnimationController(
    vsync: this, duration: const Duration(seconds: 2));
  // c.forward(); c.stop(); c.reverse();
  // c.reset(); c.repeat(reverse: true);
  @override
  void dispose() { c.dispose(); super.dispose(); }
}''',
    '''final position = Tween<double>(begin: 0, end: 1)
    .animate(controller);
// Inside AnimatedBuilder + bounded LayoutBuilder:
Transform.translate(
  offset: Offset(position.value * travel, 0),
  child: circle,
)''',
    '''final eased = CurvedAnimation(
  parent: controller, curve: Curves.bounceOut);
// Linear baseline uses controller.value.
// Comparison uses eased.value, over the same travel.
// Dispose eased when it is replaced or no longer used.''',
    '''AnimatedBuilder(
  animation: controller,
  child: const Icon(Icons.auto_stories, size: 54),
  builder: (_, child) => Transform.rotate(
    angle: controller.value * 2 * pi,
    child: child,
  ),
)''',
    '''// TickerMode must be ABOVE the State that supplies vsync.
TickerMode(enabled: enabled, child: TickerDemoChild());
// In TickerDemoChild State:
// with SingleTickerProviderStateMixin
controller = AnimationController(vsync: this,
  duration: const Duration(seconds: 2));''',
    '''final eased = CurvedAnimation(
  parent: controller, curve: Curves.easeInOut);
final value = Tween<double>(begin: 0, end: 1).animate(eased);
AnimatedBuilder(animation: controller, child: book,
  builder: (_, child) => Transform.translate(
    offset: Offset(80 * value.value, 0),
    child: Transform.rotate(angle: value.value * pi / 2,
      child: Transform.scale(scale: .7 + .5 * value.value,
        child: child))));''',
  ];
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    curved = CurvedAnimation(parent: controller, curve: curves[selectedCurve]!);
    interpolated = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(widget.kind == 1 ? controller : curved);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reduced = MediaQuery.disableAnimationsOf(context);
    if (reduced && controller.isAnimating) controller.stop();
  }

  void play({bool restart = false, bool reverse = false, bool repeat = false}) {
    if (reduced) {
      controller.value = reverse ? 0 : 1;
    } else if (repeat) {
      controller.repeat(reverse: true);
    } else if (reverse) {
      controller.reverse();
    } else {
      controller.forward(from: restart || controller.isCompleted ? 0 : null);
    }
    setState(() {});
  }

  void stop() {
    controller.stop();
    setState(() {});
  }

  void reset() {
    controller.reset();
    setState(() {});
  }

  void chooseCurve(String value) {
    controller.stop();
    curved.dispose();
    selectedCurve = value;
    curved = CurvedAnimation(parent: controller, curve: curves[value]!);
    interpolated = Tween<double>(begin: 0, end: 1).animate(curved);
    controller.reset();
    setState(() {});
  }

  @override
  void dispose() {
    curved.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget track(double value, Color color, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (_, box) => SizedBox(
              height: 30,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: Offset(value * math.max(0, box.maxWidth - 26), 0),
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final tickerEnabled = TickerMode.valuesOf(context).enabled;
    final preview = AnimatedBuilder(
      animation: controller,
      child: book(),
      builder: (_, stableBook) {
        final v = interpolated.value;
        Widget visual;
        if (kind == 0) {
          visual = Column(
            children: [
              LinearProgressIndicator(
                value: controller.value,
                color: cyan,
                minHeight: 12,
              ),
              const SizedBox(height: 12),
              Text(
                'Value ${controller.value.toStringAsFixed(2)} · ${controller.status.name}',
              ),
              Text(
                '${controller.isAnimating ? 'Running' : 'Stopped'} · '
                '${controller.status == AnimationStatus.reverse ? 'Reverse' : controller.status == AnimationStatus.forward ? 'Forward' : 'Idle'}',
              ),
            ],
          );
        } else if (kind == 1) {
          visual = Column(
            children: [
              track(v, cyan, 'A → B'),
              Text('Interpolated value: ${v.toStringAsFixed(3)}'),
            ],
          );
        } else if (kind == 2) {
          visual = Column(
            children: [
              track(controller.value, cyan, 'Linear baseline'),
              const SizedBox(height: 12),
              track(curved.value, purple, selectedCurve),
            ],
          );
        } else if (kind == 3) {
          visual = Transform.rotate(
            angle: controller.value * math.pi * 2,
            child: stableBook,
          );
        } else if (kind == 4) {
          visual = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(scale: .7 + .5 * v, child: stableBook),
              const SizedBox(height: 8),
              Text(
                'Value ${controller.value.toStringAsFixed(2)} · '
                '${controller.isAnimating ? 'Active' : 'Stopped'}',
              ),
              Text('Ticker callbacks: ${tickerEnabled ? 'enabled' : 'muted'}'),
            ],
          );
        } else {
          visual = LayoutBuilder(
            builder: (_, box) => Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: Offset(math.max(0, box.maxWidth - 90) * v, 0),
                child: Transform.rotate(
                  angle: v * math.pi / 2,
                  child: Transform.scale(scale: .7 + .5 * v, child: stableBook),
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: kind == 2 ? 170 : 155,
          child: Center(child: visual),
        );
      },
    );
    final buttons = <Widget>[];
    if (kind == 2) {
      buttons.add(
        DropdownButton<String>(
          value: selectedCurve,
          items: curves.keys
              .map((name) => DropdownMenuItem(value: name, child: Text(name)))
              .toList(),
          onChanged: (value) => chooseCurve(value!),
        ),
      );
      buttons.add(action('Replay', () => play(restart: true)));
    } else {
      buttons.add(
        action(
          kind == 0 ? 'Play' : 'Start',
          () => play(repeat: kind == 3 || kind == 4),
        ),
      );
      buttons.add(action(kind == 0 ? 'Pause' : 'Stop', stop));
      if (kind == 0) {
        buttons.add(action('Reverse', () => play(reverse: true)));
        buttons.add(action('Repeat', () => play(repeat: true)));
        buttons.add(action('Stop', stop));
      }
    }
    buttons.add(action('Reset', reset));
    return DemoCard(
      title: names[kind],
      description: descriptions[kind],
      timing: reduced
          ? 'Reduced motion · immediate endpoints'
          : '2000 ms · ${kind == 1 || kind == 0 || kind == 3 ? 'linear' : selectedCurve}',
      preview: preview,
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controls(buttons),
          if (kind == 5) ...[
            const SizedBox(height: 16),
            const Text('Animation data flow', style: TextStyle(color: purple)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final label in [
                  'TickerProvider',
                  'AnimationController',
                  'CurvedAnimation',
                  'Tween',
                  'AnimatedBuilder',
                  'UI',
                ]) ...[
                  Chip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                  ),
                  if (label != 'UI')
                    const Icon(Icons.arrow_forward, size: 16, color: purple),
                ],
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'AnimatedBuilder listens to the controller and reads the mapped value.',
            ),
          ],
        ],
      ),
      explanation: explanations[kind],
      code: snippets[kind],
      highlight: kind == 5,
    );
  }
}
