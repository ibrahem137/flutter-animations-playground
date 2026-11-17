import 'package:material_ui/material_ui.dart';

enum AppTransitionType { slide, fade, scale, hero }

class TransitionSettings extends ChangeNotifier {
  AppTransitionType type = AppTransitionType.slide;
  int milliseconds = 350;
  void select(AppTransitionType value) {
    type = value;
    notifyListeners();
  }

  void setDuration(int value) {
    milliseconds = value;
    notifyListeners();
  }

  Duration duration(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : Duration(milliseconds: milliseconds);
}

Widget transitionFor(
  AppTransitionType type,
  Animation<double> animation,
  Widget child,
) {
  switch (type) {
    case AppTransitionType.slide:
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    case AppTransitionType.scale:
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .92, end: 1).animate(animation),
          child: child,
        ),
      );
    case AppTransitionType.fade:
    case AppTransitionType.hero:
      return FadeTransition(opacity: animation, child: child);
  }
}

PageRouteBuilder<void> demoRoute(
  BuildContext context,
  TransitionSettings settings,
  Widget destination,
) {
  return PageRouteBuilder<void>(
    transitionDuration: settings.duration(context),
    reverseTransitionDuration: settings.duration(context),
    pageBuilder: (_, __, ___) => destination,
    transitionsBuilder: (_, animation, __, child) => transitionFor(
      settings.type,
      animation.drive(CurveTween(curve: Curves.easeInOut)),
      child,
    ),
  );
}
