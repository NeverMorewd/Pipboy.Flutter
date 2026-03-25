<div align="center">

# ☢ Pipboy Flutter

**A professional Flutter theme library inspired by the Pip-Boy UI from the Fallout series**

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

## What is this?

`pipboy_flutter` is a complete Material 3 theme library that transforms a Flutter app into a retro terminal UI reminiscent of the Vault-Tec Pip-Boy device. It ships a full `ThemeData` covering every built-in Material widget, a set of purpose-built Pip-Boy widgets, and a runtime color-switching system — all driven by a single primary `Color`.

---

## Design Philosophy

### 1 · Monochromatic HSL Palette

The entire color system is derived from **one primary color** using HSL math. A saturation scaling factor `ss = min(S / 0.25, 1.0)` is applied so that desaturated primaries (e.g. amber, grey) produce cohesive palettes without blowing out. All 18 semantic roles — `background`, `surface`, `border`, `primary`, `text`, `textDim`, `selection`, `success`, `warning`, `error`, … — are computed automatically.

```dart
PipboyThemeManager(
  primaryColor: Color(0xFF15FF52), // phosphor green
  child: MyApp(),
)
```

### 2 · Zero Radius, Sharp Retro

Every shape in the theme uses `BorderRadius.zero`. No rounded corners, no card shadows — just flat, crisp rectangles that evoke a late-80s green-phosphor terminal.

### 3 · Full Material 3 Coverage

`PipboyTheme.buildThemeData()` overrides every component theme in Flutter's `ThemeData`: AppBar, Card, all Button variants, InputDecoration, Checkbox, Radio, Switch, Slider, ProgressIndicator, ListTile, TabBar, Tooltip, SnackBar, Dialog, Drawer, NavigationBar, NavigationRail, FAB, Chip, PopupMenu, BottomSheet, DropdownMenu, ExpansionTile, Badge, DatePicker, TimePicker, SearchBar.

### 4 · ThemeExtension Access Pattern

The palette is injected as a `ThemeExtension` so any widget can read it from context without an extra `InheritedWidget`:

```dart
final palette = PipboyThemeData.paletteOf(context);
```

### 5 · CRT Authenticity

The library ships layered `CustomPainter`-based effects — scanlines, a travelling scan-beam, vignette gradient, and random flicker — all composited at runtime, no image assets required. Effects are individually toggleable.

---

## Packages & Apps

```
Pipboy.Flutter/
├── packages/
│   └── pipboy_flutter/        # Theme library (pub.dev package)
│       ├── lib/src/theme/     # Palette · ThemeData · ThemeExtension · ThemeManager
│       └── lib/src/widgets/   # 11 custom Pip-Boy widgets
└── apps/
    └── pipboy_flutter_demo/   # Interactive demo app (12 pages)
```

Managed with [Melos](https://melos.invertase.dev/) — `melos analyze`, `melos test`, `melos build:web`.

---

## Custom Widgets

| Widget | Description |
|---|---|
| `PipboyPanel` | Bordered panel with `─[ TITLE ]─` header, variants: standard / accent / warning |
| `PipboySegmentedBar` | Block-segment progress bar drawn with `CustomPainter` |
| `PipboyRatedAttribute` | S.P.E.C.I.A.L.-style dot-rating row |
| `PipboyBlinkText` | Animated blinking text (cursor, alert labels) |
| `PipboyBracketHighlight` | Sliding `[ selection ]` bracket animation |
| `PipboyScanlineOverlay` | CRT horizontal scanline overlay |
| `PipboyCrtDisplay` | Full CRT stack: scanlines + scan-beam + vignette + flicker |
| `PipboyTabStrip` / `PipboyTabbedView` | Tab strip with bracket-highlight selection |
| `PipboyTerminalPanel` | Typewriter-effect text terminal with blinking cursor |
| `PipboyCountdown` | Precision countdown timer (seconds / tenths / hundredths) |
| `PipboyButton` | Button variants: standard / accent / ghost / danger |

---

## Quick Start

```yaml
# pubspec.yaml
dependencies:
  pipboy_flutter: ^0.1.0
```

```dart
import 'package:pipboy_flutter/pipboy_flutter.dart';

void main() {
  runApp(
    PipboyThemeManager(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = PipboyThemeManager.of(context).currentTheme;
    return MaterialApp(
      theme: theme,
      home: const MyHomePage(),
    );
  }
}
```

Switch color at runtime:

```dart
PipboyThemeManager.of(context).setPrimaryColor(Color(0xFFFF6E00)); // amber
```

Built-in presets: `green` · `amber` · `blue` · `red` · `cyan` · `purple` · `white` · `orange`

---

## Demo

The demo app covers 12 pages — every Material widget themed, all 11 custom widgets, CRT effects, live theme switching, and a real-time FPS counter.

🔗 **https://nevermorewd.github.io/Pipboy.Flutter/**

---

## CI / CD

| Workflow | Trigger | Action |
|---|---|---|
| **CI** | push / PR → `main` | dart format check · flutter analyze · 78 unit tests · web build · Windows build |
| **Deploy Web Demo** | push → `main` | `flutter build web` → GitHub Pages |
| **Publish to pub.dev** | tag `v*.*.*` | pana score check → `flutter pub publish` (OIDC, no API key) |

---

<div align="center">

*"War never changes — but your UI can."*

</div>
