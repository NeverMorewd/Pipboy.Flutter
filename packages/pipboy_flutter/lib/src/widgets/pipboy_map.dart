import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_color_palette.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Visual appearance of a [PipboyMapMarker].
enum PipboyMapMarkerKind {
  /// ▼ Downward-pointing teardrop pin (default).
  pin,

  /// Vertical pole with a triangular flag.
  flag,

  /// Five-pointed star.
  star,

  /// Skull icon — indicates danger or hostile territory.
  skull,

  /// Rotated square (rhombus).
  diamond,

  /// Filled circle — generic waypoint.
  circle,

  /// Plus / crosshair — typically a medical or objective marker.
  cross,

  /// Exclamation mark inside a triangle — quest / point of interest.
  quest,

  /// Animated expanding concentric rings — active beacon / signal.
  ripple,
}

/// Stroke style for a [PipboyMapLine].
enum PipboyMapLineStyle {
  /// Continuous stroke.
  solid,

  /// Evenly-spaced dashes.
  dashed,

  /// Small dots at regular intervals.
  dotted,

  /// Dashes that animate continuously toward the end point.
  dashedFlow,
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────

/// An immutable marker placed on a [PipboyMap].
///
/// [position] uses normalised world coordinates: `Offset(x, y)` where
/// both `x` and `y` are in **[0, 1]** (top-left = 0,0 · bottom-right = 1,1).
@immutable
class PipboyMapMarker {
  const PipboyMapMarker({
    required this.id,
    required this.position,
    this.kind = PipboyMapMarkerKind.pin,
    this.label,
    this.color,
    this.isVisible = true,
    this.isBlinking = false,
    this.tag,
  });

  final String id;

  /// Normalised world position `[0, 1] × [0, 1]`.
  final Offset position;
  final PipboyMapMarkerKind kind;
  final String? label;

  /// Overrides the theme primary color for this marker.
  final Color? color;
  final bool isVisible;

  /// When `true` the marker pulses at the global blink interval.
  final bool isBlinking;

  /// Arbitrary application payload — not rendered.
  final Object? tag;

  /// Returns a copy with the given fields replaced.
  PipboyMapMarker copyWith({
    String? id,
    Offset? position,
    PipboyMapMarkerKind? kind,
    String? label,
    Color? color,
    bool? isVisible,
    bool? isBlinking,
    Object? tag,
  }) => PipboyMapMarker(
    id: id ?? this.id,
    position: position ?? this.position,
    kind: kind ?? this.kind,
    label: label ?? this.label,
    color: color ?? this.color,
    isVisible: isVisible ?? this.isVisible,
    isBlinking: isBlinking ?? this.isBlinking,
    tag: tag ?? this.tag,
  );
}

/// An immutable line segment drawn on a [PipboyMap].
@immutable
class PipboyMapLine {
  const PipboyMapLine({
    required this.id,
    required this.start,
    required this.end,
    this.style = PipboyMapLineStyle.solid,
    this.isThick = false,
    this.color,
    this.isVisible = true,
    this.tag,
  });

  final String id;

  /// Normalised start position `[0, 1] × [0, 1]`.
  final Offset start;

  /// Normalised end position `[0, 1] × [0, 1]`.
  final Offset end;
  final PipboyMapLineStyle style;

  /// When `true` the stroke is drawn at 2× the base weight.
  final bool isThick;

  /// Overrides the theme primary color for this line.
  final Color? color;
  final bool isVisible;
  final Object? tag;
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

/// Mutable controller for [PipboyMap] markers, lines, and view state.
///
/// Extend with [ChangeNotifier] so that widgets listening to this controller
/// (e.g. via [ListenableBuilder]) rebuild when its content changes.
///
/// ```dart
/// final controller = PipboyMapController();
/// controller.addMarker(const PipboyMapMarker(id: '1', position: Offset(0.5, 0.5)));
/// ```
class PipboyMapController extends ChangeNotifier {
  final List<PipboyMapMarker> _markers = [];
  final List<PipboyMapLine> _lines = [];

  /// Read-only view of current markers.
  List<PipboyMapMarker> get markers => List.unmodifiable(_markers);

  /// Read-only view of current lines.
  List<PipboyMapLine> get lines => List.unmodifiable(_lines);

  // ── Markers ────────────────────────────────────────────────────────────────

  void addMarker(PipboyMapMarker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void removeMarker(String id) {
    _markers.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  void updateMarker(PipboyMapMarker marker) {
    final i = _markers.indexWhere((m) => m.id == marker.id);
    if (i >= 0) {
      _markers[i] = marker;
      notifyListeners();
    }
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  // ── Lines ──────────────────────────────────────────────────────────────────

  void addLine(PipboyMapLine line) {
    _lines.add(line);
    notifyListeners();
  }

  void removeLine(String id) {
    _lines.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  void clearLines() {
    _lines.clear();
    notifyListeners();
  }

  void clearAll() {
    _markers.clear();
    _lines.clear();
    notifyListeners();
  }

  // ── View control ───────────────────────────────────────────────────────────

  _PipboyMapState? _state;
  void _attach(_PipboyMapState s) => _state = s;
  void _detach() => _state = null;

  /// Resets zoom to 1× and pan to origin.
  void fitToView() => _state?._fitToView();

  /// Zooms in by 25 %.
  void zoomIn() => _state?._zoomStep(1.25);

  /// Zooms out by 20 %.
  void zoomOut() => _state?._zoomStep(0.8);
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget
// ─────────────────────────────────────────────────────────────────────────────

/// A Pip-Boy styled interactive map with pan, zoom, markers, and lines.
///
/// All mutable content (markers, lines, view state) is managed through a
/// [PipboyMapController].  Display options (grid, crosshair …) are set via
/// widget properties and can be changed with [setState] in the parent.
///
/// ```dart
/// PipboyMap(
///   controller: _controller,
///   showGrid: true,
///   isMarkerPlacementEnabled: true,
///   onMarkerAdded: (m) => _controller.addMarker(m),
/// )
/// ```
class PipboyMap extends StatefulWidget {
  const PipboyMap({
    super.key,
    required this.controller,
    this.showGrid = true,
    this.showCrosshair = true,
    this.showScaleBar = true,
    this.showMarkerLabels = true,
    this.isPanEnabled = true,
    this.isZoomEnabled = true,
    this.isMarkerPlacementEnabled = false,
    this.defaultMarkerKind = PipboyMapMarkerKind.pin,
    this.defaultMarkerIsBlinking = false,
    this.minZoom = 0.5,
    this.maxZoom = 10.0,
    this.onMarkerAdded,
    this.onMarkerTapped,
    this.onCursorMoved,
  });

  final PipboyMapController controller;

  /// Whether to draw the 10×10 coordinate grid.
  final bool showGrid;

  /// Whether to draw dashed crosshair lines at the cursor.
  final bool showCrosshair;

  /// Whether to draw a scale bar in the bottom-left corner.
  final bool showScaleBar;

  /// Whether to draw text labels below markers.
  final bool showMarkerLabels;

  final bool isPanEnabled;
  final bool isZoomEnabled;

  /// When `true`, right-click / long-press places a new marker.
  final bool isMarkerPlacementEnabled;
  final PipboyMapMarkerKind defaultMarkerKind;
  final bool defaultMarkerIsBlinking;
  final double minZoom;
  final double maxZoom;

  /// Called when the user places a new marker (right-click / long-press).
  /// The caller is responsible for adding it to [controller] if desired.
  final void Function(PipboyMapMarker marker)? onMarkerAdded;

  /// Called when the user taps an existing marker.
  final void Function(PipboyMapMarker marker)? onMarkerTapped;

  /// Called whenever the cursor moves; `null` when cursor leaves the widget.
  /// Uses a callback rather than exposing internal state to avoid triggering
  /// expensive parent rebuilds — wire to a [ValueNotifier] for efficiency.
  final void Function(Offset? worldPosition)? onCursorMoved;

  @override
  State<PipboyMap> createState() => _PipboyMapState();
}

class _PipboyMapState extends State<PipboyMap>
    with SingleTickerProviderStateMixin {
  // ── Transform ──────────────────────────────────────────────────────────────
  double _scale = 1.0;
  Offset _translation = Offset.zero;
  Size _mapSize = Size.zero;

  // ── Gesture tracking ───────────────────────────────────────────────────────
  Offset? _focalOnStart;
  double _scaleOnStart = 1.0;
  Offset _translationOnStart = Offset.zero;
  Offset? _cursorWorld;

  // ── Animation & blink ─────────────────────────────────────────────────────
  late final AnimationController _animController;
  Timer? _blinkTimer;
  bool _blinkVisible = true;

  // ── Unique id counter ─────────────────────────────────────────────────────
  int _markerCounter = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _blinkVisible = !_blinkVisible);
    });

    widget.controller._attach(this);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(PipboyMap old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller._detach();
      old.controller.removeListener(_onControllerChanged);
      widget.controller._attach(this);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _blinkTimer?.cancel();
    widget.controller._detach();
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  // ── Coordinate helpers ─────────────────────────────────────────────────────

  Offset _screenToWorld(Offset screen) => Offset(
    (screen.dx - _translation.dx) / (_mapSize.width * _scale),
    (screen.dy - _translation.dy) / (_mapSize.height * _scale),
  );

  void _fitToView() => setState(() {
    _scale = 1.0;
    _translation = Offset.zero;
  });

  void _zoomStep(double factor, {Offset? focalPoint}) {
    final fp = focalPoint ?? Offset(_mapSize.width / 2, _mapSize.height / 2);
    final newScale = (_scale * factor).clamp(widget.minZoom, widget.maxZoom);
    setState(() {
      _translation = fp + (_translation - fp) * (newScale / _scale);
      _scale = newScale;
    });
  }

  // ── Gestures ───────────────────────────────────────────────────────────────

  void _onScaleStart(ScaleStartDetails d) {
    _focalOnStart = d.localFocalPoint;
    _scaleOnStart = _scale;
    _translationOnStart = _translation;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (!mounted) return;
    setState(() {
      if (widget.isZoomEnabled && d.scale != 1.0) {
        final newScale = (_scaleOnStart * d.scale).clamp(
          widget.minZoom,
          widget.maxZoom,
        );
        _translation =
            d.localFocalPoint +
            (_translationOnStart - _focalOnStart!) * (newScale / _scaleOnStart);
        _scale = newScale;
      } else if (widget.isPanEnabled) {
        _translation =
            _translationOnStart + (d.localFocalPoint - _focalOnStart!);
      }
      _cursorWorld = _screenToWorld(d.localFocalPoint);
    });
    widget.onCursorMoved?.call(_cursorWorld);
  }

  void _onPointerMove(PointerEvent event) {
    final w = _screenToWorld(event.localPosition);
    if (w != _cursorWorld) {
      setState(() => _cursorWorld = w);
      widget.onCursorMoved?.call(w);
    }
  }

  void _onPointerExit(PointerExitEvent _) {
    setState(() => _cursorWorld = null);
    widget.onCursorMoved?.call(null);
  }

  void _onScrollWheel(PointerSignalEvent event) {
    if (!widget.isZoomEnabled) return;
    if (event is! PointerScrollEvent) return;
    final factor = event.scrollDelta.dy > 0 ? 0.85 : 1.18;
    _zoomStep(factor, focalPoint: event.localPosition);
  }

  void _onLongPressStart(LongPressStartDetails d) =>
      _placeMarker(d.localPosition);

  void _onSecondaryTapDown(TapDownDetails d) => _placeMarker(d.localPosition);

  void _placeMarker(Offset localPos) {
    if (!widget.isMarkerPlacementEnabled) return;
    final pos = _screenToWorld(localPos);
    final marker = PipboyMapMarker(
      id: 'marker_${++_markerCounter}',
      position: pos,
      kind: widget.defaultMarkerKind,
      isBlinking: widget.defaultMarkerIsBlinking,
    );
    widget.onMarkerAdded?.call(marker);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        _mapSize = Size(constraints.maxWidth, constraints.maxHeight);

        return ClipRect(
          child: MouseRegion(
            cursor: SystemMouseCursors.precise,
            onExit: _onPointerExit,
            child: Listener(
              onPointerMove: _onPointerMove,
              onPointerSignal: _onScrollWheel,
              child: GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                onLongPressStart: _onLongPressStart,
                onSecondaryTapDown: _onSecondaryTapDown,
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) => CustomPaint(
                    size: _mapSize,
                    painter: _MapPainter(
                      palette: palette,
                      markers: widget.controller.markers,
                      lines: widget.controller.lines,
                      scale: _scale,
                      translation: _translation,
                      mapSize: _mapSize,
                      showGrid: widget.showGrid,
                      showCrosshair: widget.showCrosshair,
                      showScaleBar: widget.showScaleBar,
                      showMarkerLabels: widget.showMarkerLabels,
                      cursorWorld: _cursorWorld,
                      blinkVisible: _blinkVisible,
                      animValue: _animController.value,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painter
// ─────────────────────────────────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.palette,
    required this.markers,
    required this.lines,
    required this.scale,
    required this.translation,
    required this.mapSize,
    required this.showGrid,
    required this.showCrosshair,
    required this.showScaleBar,
    required this.showMarkerLabels,
    required this.cursorWorld,
    required this.blinkVisible,
    required this.animValue,
  });

  final PipboyColorPalette palette;
  final List<PipboyMapMarker> markers;
  final List<PipboyMapLine> lines;
  final double scale;
  final Offset translation;
  final Size mapSize;
  final bool showGrid;
  final bool showCrosshair;
  final bool showScaleBar;
  final bool showMarkerLabels;
  final Offset? cursorWorld;
  final bool blinkVisible;
  final double animValue;

  // World → screen coordinate transform.
  Offset _w2s(Offset world) => Offset(
    world.dx * mapSize.width * scale + translation.dx,
    world.dy * mapSize.height * scale + translation.dy,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // 1 — Background
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.background);

    // 2 — Grid
    if (showGrid) _drawGrid(canvas, size);

    // 3 — Lines
    for (final l in lines) {
      if (!l.isVisible) continue;
      _drawLine(canvas, l);
    }

    // 4 — Markers
    for (final m in markers) {
      if (!m.isVisible) continue;
      if (m.isBlinking && !blinkVisible) continue;
      _drawMarker(canvas, m, size);
    }

    // 5 — Crosshair (screen space, drawn after canvas elements)
    if (showCrosshair && cursorWorld != null) {
      _drawCrosshair(canvas, size);
    }

    // 6 — Scale bar (screen space, fixed position)
    if (showScaleBar) _drawScaleBar(canvas, size);

    // 7 — Corner brackets (Pip-Boy aesthetic frame)
    _drawCornerBrackets(canvas, size);
  }

  // ── Grid ───────────────────────────────────────────────────────────────────

  void _drawGrid(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = palette.border.withValues(alpha: 0.30)
      ..strokeWidth = 0.8;

    const labelPaint = TextStyle(fontSize: 9.0, letterSpacing: 0.5);
    const divisions = 10;
    const cols = 'ABCDEFGHIJ';

    for (int i = 0; i <= divisions; i++) {
      final t = i / divisions;
      final sx = t * mapSize.width * scale + translation.dx;
      final sy = t * mapSize.height * scale + translation.dy;

      // Vertical line
      if (sx >= -1 && sx <= size.width + 1) {
        _dashedLine(
          canvas,
          Offset(sx, 0),
          Offset(sx, size.height),
          linePaint,
          dashLen: 3,
          gapLen: 6,
        );
      }
      // Horizontal line
      if (sy >= -1 && sy <= size.height + 1) {
        _dashedLine(
          canvas,
          Offset(0, sy),
          Offset(size.width, sy),
          linePaint,
          dashLen: 3,
          gapLen: 6,
        );
      }

      // Column label (A-J) centred in each cell
      if (i < divisions) {
        final midX =
            ((i + 0.5) / divisions) * mapSize.width * scale + translation.dx;
        if (midX > 12 && midX < size.width - 4) {
          _paintLabel(
            canvas,
            cols[i],
            Offset(midX, 5),
            palette.border.withValues(alpha: 0.55),
            labelPaint,
          );
        }
      }
      // Row label (1-10)
      if (i < divisions) {
        final midY =
            ((i + 0.5) / divisions) * mapSize.height * scale + translation.dy;
        if (midY > 8 && midY < size.height - 4) {
          _paintLabel(
            canvas,
            '${i + 1}',
            Offset(6, midY),
            palette.border.withValues(alpha: 0.55),
            labelPaint,
          );
        }
      }
    }
  }

  // ── Lines ──────────────────────────────────────────────────────────────────

  void _drawLine(Canvas canvas, PipboyMapLine l) {
    final p1 = _w2s(l.start);
    final p2 = _w2s(l.end);
    final color = l.color ?? palette.primary;
    final baseW = l.isThick ? 2.5 : 1.5;

    final paint = Paint()
      ..color = color
      ..strokeWidth = baseW
      ..strokeCap = StrokeCap.square;

    switch (l.style) {
      case PipboyMapLineStyle.solid:
        canvas.drawLine(p1, p2, paint);
      case PipboyMapLineStyle.dashed:
        _dashedLine(canvas, p1, p2, paint, dashLen: 10);
      case PipboyMapLineStyle.dotted:
        _dashedLine(
          canvas,
          p1,
          p2,
          paint
            ..strokeCap = StrokeCap.round
            ..strokeWidth = baseW + 0.5,
          dashLen: 1.5,
          gapLen: 4,
        );
      case PipboyMapLineStyle.dashedFlow:
        _dashedLine(canvas, p1, p2, paint, dashLen: 10, flowPhase: animValue);
    }

    // Arrow head at end point
    _drawArrow(canvas, p1, p2, paint..strokeWidth = baseW);
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Paint paint) {
    final vec = to - from;
    if (vec.distance < 12) return;
    final dir = vec / vec.distance;
    const al = 7.0; // arrow leg length
    const aa = 0.45; // angle in radians
    final lp =
        to -
        Offset(
          dir.dx * al * math.cos(aa) - dir.dy * al * math.sin(aa),
          dir.dy * al * math.cos(aa) + dir.dx * al * math.sin(aa),
        );
    final rp =
        to -
        Offset(
          dir.dx * al * math.cos(aa) + dir.dy * al * math.sin(aa),
          dir.dy * al * math.cos(aa) - dir.dx * al * math.sin(aa),
        );
    canvas.drawLine(to, lp, paint);
    canvas.drawLine(to, rp, paint);
  }

  // ── Dashed line helper ─────────────────────────────────────────────────────

  void _dashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    double dashLen = 8.0,
    double gapLen = 5.0,
    double flowPhase = 0.0,
  }) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final total = math.sqrt(dx * dx + dy * dy);
    if (total < 0.5) return;
    final ux = dx / total;
    final uy = dy / total;

    final period = dashLen + gapLen;
    // Shifting start by (flowPhase-1)*period makes dashes flow toward p2
    // as flowPhase increases 0→1.
    double t = (flowPhase - 1.0) * period;

    while (t < total) {
      final s = t.clamp(0.0, total);
      final e = (t + dashLen).clamp(0.0, total);
      if (e > s) {
        canvas.drawLine(
          Offset(p1.dx + ux * s, p1.dy + uy * s),
          Offset(p1.dx + ux * e, p1.dy + uy * e),
          paint,
        );
      }
      t += period;
    }
  }

  // ── Markers ────────────────────────────────────────────────────────────────

  static const double _iconR = 9.0; // screen-space icon half-size

  void _drawMarker(Canvas canvas, PipboyMapMarker m, Size size) {
    final pos = _w2s(m.position);
    // Cull off-screen (with generous margin for labels)
    if (pos.dx < -40 || pos.dx > size.width + 40) return;
    if (pos.dy < -40 || pos.dy > size.height + 40) return;

    final color = m.color ?? palette.primary;

    switch (m.kind) {
      case PipboyMapMarkerKind.pin:
        _drawPin(canvas, pos, color);
      case PipboyMapMarkerKind.flag:
        _drawFlag(canvas, pos, color);
      case PipboyMapMarkerKind.star:
        _drawStar(canvas, pos, color);
      case PipboyMapMarkerKind.skull:
        _drawSkull(canvas, pos, color);
      case PipboyMapMarkerKind.diamond:
        _drawDiamond(canvas, pos, color);
      case PipboyMapMarkerKind.circle:
        canvas.drawCircle(pos, _iconR * 0.85, Paint()..color = color);
      case PipboyMapMarkerKind.cross:
        _drawCrossMarker(canvas, pos, color);
      case PipboyMapMarkerKind.quest:
        _drawQuest(canvas, pos, color);
      case PipboyMapMarkerKind.ripple:
        _drawRipple(canvas, pos, color);
    }

    // Optional label
    if (showMarkerLabels && m.label != null) {
      _paintLabel(
        canvas,
        m.label!,
        pos + const Offset(0, _iconR + 5),
        color,
        const TextStyle(fontSize: 8.0, letterSpacing: 1.0),
      );
    }
  }

  void _drawPin(Canvas canvas, Offset pos, Color c) {
    final fill = Paint()..color = c;
    // Circle head
    canvas.drawCircle(
      Offset(pos.dx, pos.dy - _iconR * 0.85),
      _iconR * 0.45,
      fill,
    );
    // Downward-pointing teardrop body
    final path = Path()
      ..moveTo(pos.dx, pos.dy + _iconR)
      ..lineTo(pos.dx - _iconR * 0.6, pos.dy - _iconR * 0.35)
      ..lineTo(pos.dx + _iconR * 0.6, pos.dy - _iconR * 0.35)
      ..close();
    canvas.drawPath(path, fill);
  }

  void _drawFlag(Canvas canvas, Offset pos, Color c) {
    final paint = Paint()
      ..color = c
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    // Pole
    canvas.drawLine(
      Offset(pos.dx - _iconR * 0.3, pos.dy + _iconR),
      Offset(pos.dx - _iconR * 0.3, pos.dy - _iconR),
      paint,
    );
    // Flag body
    final path = Path()
      ..moveTo(pos.dx - _iconR * 0.3, pos.dy - _iconR)
      ..lineTo(pos.dx + _iconR * 0.9, pos.dy - _iconR * 0.35)
      ..lineTo(pos.dx - _iconR * 0.3, pos.dy + _iconR * 0.15)
      ..close();
    canvas.drawPath(path, Paint()..color = c);
  }

  void _drawStar(Canvas canvas, Offset pos, Color c) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? _iconR : _iconR * 0.42;
      final angle = (i * math.pi / 5) - math.pi / 2;
      final p = Offset(
        pos.dx + r * math.cos(angle),
        pos.dy + r * math.sin(angle),
      );
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = c);
  }

  void _drawSkull(Canvas canvas, Offset pos, Color c) {
    final fill = Paint()..color = c;
    final cut = Paint()..color = palette.background;
    const r = _iconR;

    // Cranium
    canvas.drawOval(
      Rect.fromCenter(
        center: pos - const Offset(0, r * 0.15),
        width: r * 1.8,
        height: r * 1.55,
      ),
      fill,
    );
    // Jaw
    canvas.drawRect(
      Rect.fromCenter(
        center: pos + const Offset(0, r * 0.65),
        width: r * 1.4,
        height: r * 0.55,
      ),
      fill,
    );
    // Eye sockets
    canvas.drawCircle(pos - const Offset(r * 0.38, r * 0.18), r * 0.27, cut);
    canvas.drawCircle(pos + const Offset(r * 0.38, -r * 0.18), r * 0.27, cut);
    // Teeth
    for (int t = 0; t < 3; t++) {
      canvas.drawRect(
        Rect.fromLTWH(
          pos.dx - r * 0.55 + t * r * 0.55,
          pos.dy + r * 0.45,
          r * 0.35,
          r * 0.4,
        ),
        cut,
      );
    }
  }

  void _drawDiamond(Canvas canvas, Offset pos, Color c) {
    const r = _iconR;
    final path = Path()
      ..moveTo(pos.dx, pos.dy - r)
      ..lineTo(pos.dx + r * 0.65, pos.dy)
      ..lineTo(pos.dx, pos.dy + r)
      ..lineTo(pos.dx - r * 0.65, pos.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = c);
    // Inner outline
    final inner = Path()
      ..moveTo(pos.dx, pos.dy - r * 0.5)
      ..lineTo(pos.dx + r * 0.3, pos.dy)
      ..lineTo(pos.dx, pos.dy + r * 0.5)
      ..lineTo(pos.dx - r * 0.3, pos.dy)
      ..close();
    canvas.drawPath(
      inner,
      Paint()
        ..color = palette.background
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  void _drawCrossMarker(Canvas canvas, Offset pos, Color c) {
    final paint = Paint()
      ..color = c
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      pos - const Offset(_iconR, 0),
      pos + const Offset(_iconR, 0),
      paint,
    );
    canvas.drawLine(
      pos - const Offset(0, _iconR),
      pos + const Offset(0, _iconR),
      paint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: pos, width: 3.5, height: 3.5),
      Paint()..color = palette.background,
    );
  }

  void _drawQuest(Canvas canvas, Offset pos, Color c) {
    const r = _iconR;
    // Warning triangle
    final path = Path()
      ..moveTo(pos.dx, pos.dy - r)
      ..lineTo(pos.dx + r * 0.9, pos.dy + r * 0.65)
      ..lineTo(pos.dx - r * 0.9, pos.dy + r * 0.65)
      ..close();
    canvas.drawPath(path, Paint()..color = c);
    // Exclamation mark (background color cutout)
    final cut = Paint()..color = palette.background;
    canvas.drawRect(
      Rect.fromCenter(
        center: pos - const Offset(0, r * 0.1),
        width: 2.0,
        height: r * 0.75,
      ),
      cut,
    );
    canvas.drawRect(
      Rect.fromCenter(
        center: pos + const Offset(0, r * 0.52),
        width: 2.0,
        height: 2.0,
      ),
      cut,
    );
  }

  void _drawRipple(Canvas canvas, Offset pos, Color c) {
    // Animated expanding rings — driven by animValue (0→1 loop)
    for (int i = 0; i < 3; i++) {
      final phase = (animValue + i / 3.0) % 1.0;
      final radius = _iconR * 0.4 + phase * _iconR * 2.2;
      final alpha = (1.0 - phase).clamp(0.0, 1.0);
      canvas.drawCircle(
        pos,
        radius,
        Paint()
          ..color = c.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
    // Solid centre dot
    canvas.drawCircle(pos, _iconR * 0.35, Paint()..color = c);
  }

  // ── Crosshair ──────────────────────────────────────────────────────────────

  void _drawCrosshair(Canvas canvas, Size size) {
    if (cursorWorld == null) return;
    final pos = _w2s(cursorWorld!);
    final paint = Paint()
      ..color = palette.primary.withValues(alpha: 0.40)
      ..strokeWidth = 1.0;
    _dashedLine(
      canvas,
      Offset(0, pos.dy),
      Offset(size.width, pos.dy),
      paint,
      dashLen: 6,
      gapLen: 4,
    );
    _dashedLine(
      canvas,
      Offset(pos.dx, 0),
      Offset(pos.dx, size.height),
      paint,
      dashLen: 6,
      gapLen: 4,
    );
  }

  // ── Scale bar ──────────────────────────────────────────────────────────────

  void _drawScaleBar(Canvas canvas, Size size) {
    // Choose a world-unit length that renders as a "nice" pixel width.
    final worldWidthOnScreen = 1.0 / scale; // world units visible
    final target = worldWidthOnScreen * 0.18;
    const nice = [0.01, 0.02, 0.05, 0.1, 0.2, 0.25, 0.5, 1.0];
    final unit = nice.firstWhere((u) => u >= target, orElse: () => 1.0);
    final barPx = unit * mapSize.width * scale;

    const x0 = 20.0;
    final y0 = size.height - 20.0;
    final x1 = x0 + barPx;

    final paint = Paint()
      ..color = palette.textDim
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(x0, y0), Offset(x1, y0), paint);
    canvas.drawLine(Offset(x0, y0 - 4), Offset(x0, y0 + 4), paint);
    canvas.drawLine(Offset(x1, y0 - 4), Offset(x1, y0 + 4), paint);

    final pct = (unit * 100).round();
    _paintLabel(
      canvas,
      pct < 100 ? '$pct%' : '100%',
      Offset(x0 + barPx / 2, y0 - 9),
      palette.textDim,
      const TextStyle(fontSize: 8.0),
    );
  }

  // ── Corner brackets ────────────────────────────────────────────────────────

  void _drawCornerBrackets(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = palette.border.withValues(alpha: 0.70)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const m = 5.0; // margin
    const len = 14.0; // bracket arm length

    void corner(Offset a, Offset b, Offset c) {
      canvas.drawLine(a, b, paint);
      canvas.drawLine(b, c, paint);
    }

    corner(
      const Offset(m, m + len),
      const Offset(m, m),
      const Offset(m + len, m),
    );
    corner(
      Offset(size.width - m - len, m),
      Offset(size.width - m, m),
      Offset(size.width - m, m + len),
    );
    corner(
      Offset(m, size.height - m - len),
      Offset(m, size.height - m),
      Offset(m + len, size.height - m),
    );
    corner(
      Offset(size.width - m - len, size.height - m),
      Offset(size.width - m, size.height - m),
      Offset(size.width - m, size.height - m - len),
    );
  }

  // ── Text helper ────────────────────────────────────────────────────────────

  void _paintLabel(
    Canvas canvas,
    String text,
    Offset centre,
    Color color,
    TextStyle base,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: base.copyWith(
          color: color,
          fontFamily: PipboyColorPalette.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, centre - Offset(tp.width / 2, tp.height / 2));
  }

  // ── shouldRepaint ──────────────────────────────────────────────────────────

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.scale != scale ||
      old.translation != translation ||
      old.markers != markers ||
      old.lines != lines ||
      old.showGrid != showGrid ||
      old.showCrosshair != showCrosshair ||
      old.showScaleBar != showScaleBar ||
      old.showMarkerLabels != showMarkerLabels ||
      old.cursorWorld != cursorWorld ||
      old.blinkVisible != blinkVisible ||
      old.animValue != animValue ||
      old.palette.primary != palette.primary;
}
