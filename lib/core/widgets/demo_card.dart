import 'package:material_ui/material_ui.dart';

const cyan = Color(0xFF38BDF8);
const mint = Color(0xFF2DD4BF);
const purple = Color(0xFFA78BFA);

Widget action(String label, VoidCallback onPressed) =>
    FilledButton.tonal(
      onPressed: onPressed,
      child: Text(label),
    );

Widget book({double size = 54}) => Icon(
  Icons.auto_stories_rounded,
  color: cyan,
  size: size,
);

Widget controls(List<Widget> children) =>
    Wrap(spacing: 8, runSpacing: 8, children: children);

Duration motionDuration(
  BuildContext context, [
  int ms = 700,
]) => MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : Duration(milliseconds: ms);

class DemoCard extends StatelessWidget {
  final String title,
      description,
      explanation,
      code,
      timing;
  final Widget preview, controls;
  final bool highlight;
  const DemoCard({
    super.key,
    required this.title,
    required this.description,
    required this.preview,
    required this.controls,
    required this.explanation,
    required this.code,
    this.timing = '700 ms · easeInOut',
    this.highlight = false,
  });
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: const Color(0xFF1E293B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: BorderSide(
        color: highlight ? purple : Colors.white10,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 12),
          Text(
            timing,
            style: const TextStyle(
              color: cyan,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1120),
              borderRadius: BorderRadius.circular(16),
            ),
            child: preview,
          ),
          const SizedBox(height: 12),
          controls,
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

class DemoGrid extends StatelessWidget {
  final List<Widget> children;
  const DemoGrid({super.key, required this.children});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final twoColumns = box.maxWidth >= 820;
      final width = twoColumns
          ? (box.maxWidth - 20) / 2
          : box.maxWidth;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          for (final child in children)
            SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

class ScreenBody extends StatelessWidget {
  final String title, subtitle;
  final Widget child;
  const ScreenBody({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  @override
  Widget build(
    BuildContext context,
  ) => SingleChildScrollView(
    key: PageStorageKey(title),
    padding: const EdgeInsets.all(20),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(subtitle),
            const SizedBox(height: 24),
            child,
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
