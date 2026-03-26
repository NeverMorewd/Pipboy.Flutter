<div align="center">

# ☢ Pipboy Flutter

**A Flutter theme library and widget kit inspired by the Pip-Boy HUD from the Fallout series**

[![Built with Claude Code](https://img.shields.io/badge/Built%20with-Claude%20Code-blueviolet?logo=anthropic)](https://claude.ai/claude-code)
[![CI](https://github.com/NeverMorewd/Pipboy.Flutter/actions/workflows/ci.yml/badge.svg)](https://github.com/NeverMorewd/Pipboy.Flutter/actions/workflows/ci.yml)
[![Deploy Web Demo](https://github.com/NeverMorewd/Pipboy.Flutter/actions/workflows/deploy-web.yml/badge.svg)](https://github.com/NeverMorewd/Pipboy.Flutter/actions/workflows/deploy-web.yml)
[![pub.dev](https://img.shields.io/pub/v/pipboy_flutter?logo=dart&logoColor=white&color=00b4ab)](https://pub.dev/packages/pipboy_flutter)
[![pub points](https://img.shields.io/pub/points/pipboy_flutter?logo=dart&logoColor=white)](https://pub.dev/packages/pipboy_flutter/score)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22-54C5F8?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%5E3.11-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/github/license/NeverMorewd/Pipboy.Flutter?color=green)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#)
[![Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-brightgreen?logo=github)](https://nevermorewd.github.io/Pipboy.Flutter/)
[![Stars](https://img.shields.io/github/stars/NeverMorewd/Pipboy.Flutter?style=social)](https://github.com/NeverMorewd/Pipboy.Flutter/stargazers)

> 🎮 The Flutter counterpart of [Pipboy.Avalonia](https://github.com/NeverMorewd/Pipboy.Avalonia) — the same retro-terminal aesthetic, now for every Flutter platform.

**[Live Demo →](https://nevermorewd.github.io/Pipboy.Flutter/)**

</div>

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
