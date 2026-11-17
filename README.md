# Flutter Animations Playground ✨

An interactive Flutter application for exploring **implicit animations**, **explicit animations**, and **page transitions** through practical demos, clear explanations, and Dart code examples.

Built with a responsive dark Material 3 interface for learning, experimentation, and technical presentations.

## Features

- Three main screens: **Implicit**, **Explicit**, and **Page Transitions**.
- Seven interactive implicit animation demos.
- Five explicit animation demos and one combined example.
- Global transition selection with configurable duration.
- A real Hero shared-element animation between routes.
- Expandable **How It Works** sections with code snippets.
- Responsive layouts with bottom navigation on compact screens and a navigation rail on wider screens.
- Support for system reduced-motion preferences.
- Educational guidance on animation performance.

## Animation Demos

### Implicit Animations

| API | Demonstration |
| --- | --- |
| `AnimatedContainer` | Animate dimensions, color, and border radius |
| `AnimatedOpacity` | Fade content in and out |
| `AnimatedAlign` | Move a widget between alignment positions |
| `AnimatedPadding` | Animate spacing inside a fixed boundary |
| `AnimatedSwitcher` | Switch between keyed favorite states |
| `AnimatedSize` | Expand and collapse book details |
| `TweenAnimationBuilder<double>` | Animate progress toward a slider-controlled target |

### Explicit Animations

| Building Block | Demonstration |
| --- | --- |
| `AnimationController` | Play, pause, reverse, reset, repeat, and stop |
| `Tween<double>` | Map animation progress to horizontal movement |
| `CurvedAnimation` | Compare linear motion with different easing curves |
| `AnimatedBuilder` | Animate a transform while reusing a stable child |
| `TickerProvider` / `vsync` | Explore frame-synchronized callbacks and ticker muting |

The **Putting Everything Together** demo combines these building blocks to animate a book’s position, rotation, and scale.

## Page Transitions

Choose a transition style for navigation between the three main screens:

- **Slide:** incoming content moves from right to left.
- **Fade:** outgoing and incoming content cross-fade.
- **Scale:** incoming content scales from `0.92` to `1.0` while fading in.
- **Hero:** tab navigation uses Fade, with a separate interaction for a genuine shared-element transition.

Available transition durations: **200 ms**, **350 ms**, and **500 ms**.

Selection remains active for the current application session.

### How the Hero Demo Works

Hero animations connect matching elements on different Navigator routes.

Select **Open Hero Demo**, then **Fly to Details** to animate a shared book between a source route and a destination route. Returning reverses the flight.

Each route contains one Hero with the matching tag:

```dart
Hero(
  tag: 'playground-book',
  child: /* shared book widget */,
)
```

Hero is presented as a shared-element technique, rather than a generic whole-screen transition.

## Getting Started

### Requirements

- Flutter **3.47.0 or newer**
- Dart **3.13.0 or newer**
- Chrome for Web, or a configured Android/iOS development environment

Validated with **Flutter 3.50.0 stable** and **Dart 3.14.0**.

### Installation

From the project directory:

```bash
flutter pub get
```

### Run on Web

```bash
flutter run -d chrome
```

### Run on a Connected Device

```bash
flutter devices
flutter run -d <device-id>
```

Android requires the Android SDK and a device or emulator. iOS requires macOS and Xcode.

### Build for Web

```bash
flutter build web --release
```

## Project Structure

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── navigation/
│       └── transition_settings.dart
├── core/
│   └── widgets/
│       └── demo_card.dart
└── features/
    ├── implicit_animations/
    │   └── implicit_screen.dart
    ├── explicit_animations/
    │   └── explicit_screen.dart
    └── page_transitions/
        └── transitions_screen.dart

test/
├── demos_test.dart
└── playground_test.dart
```

## Implementation Notes

- Uses native Flutter animation APIs.
- Uses Flutter’s official `material_ui` package for Material 3.
- Keeps animation state local to each demo.
- Stores shared transition settings in a lightweight `ChangeNotifier`.
- Disposes owned animation controllers and curved animations.
- Uses distinct keys for animated content and expandable explanations.
- Disables interaction and ticker callbacks for outgoing tab content.
- Resets demo state when a tab is recreated; transition settings remain shared.

## Accessibility and Performance

The application respects reduced-motion preferences:

- Implicit and navigation animations use zero duration.
- Explicit playback jumps to endpoints.
- Repeating explicit animations are disabled.

An educational performance dialog explains frame budgets, rebuild isolation, layout and painting costs, and profiling guidance.

No simulated FPS measurements are displayed.

> Muting a ticker suppresses callbacks; elapsed time still passes. Unmuting can therefore cause the animation value to jump forward.

## Validation

```bash
dart format .
flutter analyze
flutter test
```

Completed checks:

- Static analysis: **no issues found**
- Automated tests: **9 passed**
- Web release build: **successful**
- Web Server launch: **successful**

Automated coverage includes demo interactions, controller playback and disposal, transition settings, Hero navigation, ticker muting, and reduced-motion behavior.

Android and iOS device execution, physical-device performance profiling, and manual browser visual verification have not been completed.

See [`VALIDATION.md`](VALIDATION.md) for details.

## Author

**Ibrahem Alhuossien**

[GitHub](https://github.com/ibrahem137)