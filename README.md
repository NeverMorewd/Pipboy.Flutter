# Pipboy.Flutter

A Flutter theme library and widget kit inspired by the Pip-Boy HUD from the **Fallout** series. Built on Material 3 with a monochromatic HSL palette, CRT effects, and a full custom widget set.

**[Live Demo →](https://nevermorewd.github.io/Pipboy.Flutter/)**

---

## Features

- **Full Material 3 theme** — buttons, inputs, toggles, sliders, tabs, dialogs, badges, progress — all styled
- **Monochromatic HSL palette** — all colors derived from one primary; 8 presets (green, amber, blue, red, cyan, purple, white, orange) and any custom color
- **CRT effects** — scanlines (animated scroll), scan beam, vignette, screen flicker, static noise
- **Custom widgets** — Panel, SegmentedBar, RatedAttribute, BlinkText, BracketHighlight, TerminalPanel, Countdown, TabStrip/TabbedView, Map
- **Interactive map** — pan/zoom (scroll + pinch), 9 marker kinds, 4 line styles, animated dashedFlow, world map SVG background, tap-to-place markers, line drawing mode
- **Zero border radius** — sharp retro aesthetic throughout
- **Share Tech Mono** font — consistent CRT monospace on all platforms including Windows

## Installation

```yaml
dependencies:
  pipboy_flutter:
    git:
      url: https://github.com/NevermoreWD/Pipboy.Flutter
      path: packages/pipboy_flutter
```

## Quick Start

```dart
void main() {
  runApp(
    PipboyThemeManager(
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PipboyThemeManager.of(context).currentTheme,
          home: const MyPage(),
        ),
      ),
    ),
  );
}
```

Change the primary color at runtime:
```dart
PipboyThemeManager.of(context).setPrimaryColor(const Color(0xFFFFAA00));
```

## Presets

| Name   | Color     |
|--------|-----------|
| Green  | `#15FF52` |
| Amber  | `#FFB300` |
| Blue   | `#00CFFF` |
| Red    | `#FF3131` |
| Cyan   | `#00FFC8` |
| Purple | `#C060FF` |
| White  | `#E8E8E8` |
| Orange | `#FF6A00` |

## Widget Reference

See the [live demo](https://nevermorewd.github.io/Pipboy.Flutter/) for interactive examples of every widget and every Material 3 component.

| Widget | Description |
|--------|-------------|
| `PipboyButton` | 4 variants: standard, accent, ghost, danger |
| `PipboyPanel` | Bordered panel with `─[ TITLE ]─` header |
| `PipboySegmentedBar` | Discrete HP/AP-style fill bar |
| `PipboyRatedAttribute` | S.P.E.C.I.A.L. dot-rating row |
| `PipboyBlinkText` | Blinking cursor/text |
| `PipboyBracketHighlight` | Animated `> … <` selection brackets |
| `PipboyCrtDisplay` | Full CRT effect stack (scanlines, beam, vignette, noise, flicker) |
| `PipboyScanlineOverlay` | Standalone scanline layer |
| `PipboyVignetteOverlay` | Standalone vignette layer |
| `PipboyTerminalPanel` | Typewriter-effect text terminal |
| `PipboyCountdown` | Precision countdown timer |
| `PipboyTabStrip` / `PipboyTabbedView` | Horizontal tab navigation |
| `PipboyMap` | Interactive vector map with pan/zoom, markers, lines |

## Architecture

```
packages/
  pipboy_flutter/       ← publishable library
    lib/
      src/
        theme/          ← PipboyColorPalette, PipboyThemeData, PipboyTheme, PipboyThemeManager
        widgets/        ← all custom widgets
apps/
  pipboy_flutter_demo/  ← showcase app (Flutter Web + Windows desktop)
```

## CI / CD

| Workflow | Trigger | Actions |
|----------|---------|---------|
| `ci.yml` | push / PR | analyze · test · build web · build Windows |
| `deploy-web.yml` | push → main | deploy to GitHub Pages |
| `publish.yml` | tag `v*.*.*` | publish to pub.dev |

## License

MIT
