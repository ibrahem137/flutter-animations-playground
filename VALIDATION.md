# Validation record

## Environment

Validated on 2026-11-17 using Flutter 3.50.0 stable (ab2912035e), Dart 3.14.0, Linux x64. The SDK was installed for this task from the official stable Flutter repository.

## Executed checks

- `flutter pub get`: passed.
- `dart format .`: passed.
- `flutter analyze`: passed, no issues found.
- `flutter test`: passed, 9 tests.
- `flutter run -d web-server --release`: started successfully and reported the app being served.
- `flutter build web --release`: passed. Wasm dry-run compilation also succeeded; a production Wasm deployment was not tested.

Tests cover implicit property changes, explicit play/pause/reverse/reset/repeat and disposal, each explicit building block and combined example, TickerMode muting, navigation and settings retention, transition duration, real Hero routes and return navigation, mobile layout and reduced-motion landscape behavior.

The initial test run found an ExpansionTile/PageStorage collision after scrolling and returning to a screen. Unique PageStorage keys for each explanation panel resolved it; all tests passed on rerun.

## Limits

- Android and iOS host projects are included, but native builds/device execution were not tested in this Linux workspace. iOS requires macOS/Xcode.
- The connected browser could not reach the workspace's localhost preview (`ERR_CONNECTION_REFUSED`), so no manual browser visual or interaction verification is claimed.
- No physical-device performance profiling or real FPS instrumentation was performed.
- All main-screen demos intentionally reset when their tab is recreated. Transition settings persist for the current session.

## Manual acceptance checklist

- Toggle container size, color, corners; choose different timing/curve.
- Hide/show opacity; align left/center/right; change padding.
- Switch favorite repeatedly; expand/collapse book; change progress target.
- Play, pause, reverse, reset, repeat, and stop the controller; observe values.
- Replay Tween; compare all five CurvedAnimation options.
- Start/stop/reset AnimatedBuilder; observe stable icon transform.
- Run ticker demo, mute then unmute callbacks; observe elapsed-time jump.
- Run/reset combined translation, rotation, and scale demo.
- Select Slide/Fade/Scale and 200/350/500 ms; switch all tabs, including rapid taps.
- Verify settings remain selected after leaving and returning to Transitions.
- Test destination and back for each transition.
- Select Hero, open its demo, fly to details and back; check shared-element flight.
- Check narrow portrait, landscape, tablet, desktop, and large text settings.
- Enable system reduced motion; ensure instant endpoints and no repeat.
- Profile on physical devices using DevTools; check lifecycle and layout errors.
