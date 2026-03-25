import 'package:flutter/material.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// Demo page for [PipboyMap] — showcases all marker kinds, line styles,
/// pan/zoom, and interactive marker placement.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final PipboyMapController _controller;

  // Display toggles
  bool _showGrid = true;
  bool _showCrosshair = true;
  bool _showScaleBar = true;
  bool _showLabels = true;
  bool _placementEnabled = true;

  // Selected defaults for placement
  PipboyMapMarkerKind _markerKind = PipboyMapMarkerKind.pin;

  // Status bar — use ValueNotifier to avoid rebuilding the whole page on
  // every mouse-move.
  final _cursor = ValueNotifier<Offset?>(null);

  @override
  void initState() {
    super.initState();
    _controller = PipboyMapController();
    _loadSampleData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursor.dispose();
    super.dispose();
  }

  // ── Sample data ────────────────────────────────────────────────────────────

  void _loadSampleData() {
    const ms = [
      PipboyMapMarker(
        id: 's_pin',
        position: Offset(0.15, 0.25),
        kind: PipboyMapMarkerKind.pin,
        label: 'VAULT 111',
        isBlinking: true,
      ),
      PipboyMapMarker(
        id: 's_flag',
        position: Offset(0.55, 0.30),
        kind: PipboyMapMarkerKind.flag,
        label: 'BASE CAMP',
      ),
      PipboyMapMarker(
        id: 's_skull',
        position: Offset(0.30, 0.65),
        kind: PipboyMapMarkerKind.skull,
        label: 'DANGER',
      ),
      PipboyMapMarker(
        id: 's_star',
        position: Offset(0.75, 0.50),
        kind: PipboyMapMarkerKind.star,
        label: 'REWARD',
      ),
      PipboyMapMarker(
        id: 's_quest',
        position: Offset(0.45, 0.18),
        kind: PipboyMapMarkerKind.quest,
        label: 'MISSION',
      ),
      PipboyMapMarker(
        id: 's_diamond',
        position: Offset(0.65, 0.80),
        kind: PipboyMapMarkerKind.diamond,
        label: 'CACHE',
      ),
      PipboyMapMarker(
        id: 's_circle',
        position: Offset(0.87, 0.28),
        kind: PipboyMapMarkerKind.circle,
        label: 'WAYPOINT',
      ),
      PipboyMapMarker(
        id: 's_cross',
        position: Offset(0.22, 0.78),
        kind: PipboyMapMarkerKind.cross,
        label: 'MEDKIT',
      ),
      PipboyMapMarker(
        id: 's_ripple',
        position: Offset(0.50, 0.50),
        kind: PipboyMapMarkerKind.ripple,
        label: 'SIGNAL',
      ),
    ];

    const ls = [
      PipboyMapLine(
        id: 'l_solid',
        start: Offset(0.15, 0.25),
        end: Offset(0.55, 0.30),
        style: PipboyMapLineStyle.solid,
        isThick: true,
      ),
      PipboyMapLine(
        id: 'l_dashed',
        start: Offset(0.55, 0.30),
        end: Offset(0.75, 0.50),
        style: PipboyMapLineStyle.dashed,
      ),
      PipboyMapLine(
        id: 'l_dotted',
        start: Offset(0.30, 0.65),
        end: Offset(0.65, 0.80),
        style: PipboyMapLineStyle.dotted,
      ),
      PipboyMapLine(
        id: 'l_flow',
        start: Offset(0.45, 0.18),
        end: Offset(0.87, 0.28),
        style: PipboyMapLineStyle.dashedFlow,
      ),
    ];

    for (final m in ms) {
      _controller.addMarker(m);
    }
    for (final l in ls) {
      _controller.addLine(l);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _gridLabel(Offset? world) {
    if (world == null) return '---';
    final col = (world.dx * 10).floor().clamp(0, 9);
    final row = (world.dy * 10).floor().clamp(0, 9);
    final c = String.fromCharCode('A'.codeUnitAt(0) + col);
    final x = world.dx.clamp(0.0, 1.0).toStringAsFixed(2);
    final y = world.dy.clamp(0.0, 1.0).toStringAsFixed(2);
    return '$c${row + 1}  ($x, $y)';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final palette = PipboyThemeData.paletteOf(context);

    return Column(
      children: [
        _buildToolbar(palette),
        _buildMarkerBar(palette),
        Expanded(
          child: PipboyMap(
            controller: _controller,
            showGrid: _showGrid,
            showCrosshair: _showCrosshair,
            showScaleBar: _showScaleBar,
            showMarkerLabels: _showLabels,
            isMarkerPlacementEnabled: _placementEnabled,
            defaultMarkerKind: _markerKind,
            defaultMarkerIsBlinking: false,
            onMarkerAdded: _controller.addMarker,
            onCursorMoved: (pos) => _cursor.value = pos,
          ),
        ),
        _buildStatusBar(palette),
      ],
    );
  }

  // ── Toolbar ────────────────────────────────────────────────────────────────

  Widget _buildToolbar(PipboyColorPalette palette) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          _ToggleBtn(
            label: 'GRID',
            active: _showGrid,
            palette: palette,
            onTap: () => setState(() => _showGrid = !_showGrid),
          ),
          _ToggleBtn(
            label: 'CROSSHAIR',
            active: _showCrosshair,
            palette: palette,
            onTap: () => setState(() => _showCrosshair = !_showCrosshair),
          ),
          _ToggleBtn(
            label: 'SCALE',
            active: _showScaleBar,
            palette: palette,
            onTap: () => setState(() => _showScaleBar = !_showScaleBar),
          ),
          _ToggleBtn(
            label: 'LABELS',
            active: _showLabels,
            palette: palette,
            onTap: () => setState(() => _showLabels = !_showLabels),
          ),
          _ToggleBtn(
            label: 'PLACE',
            active: _placementEnabled,
            palette: palette,
            onTap: () => setState(() => _placementEnabled = !_placementEnabled),
          ),
          const Spacer(),
          // Zoom controls
          _IconBtn(
            icon: Icons.add,
            palette: palette,
            tooltip: 'Zoom in',
            onTap: _controller.zoomIn,
          ),
          _IconBtn(
            icon: Icons.remove,
            palette: palette,
            tooltip: 'Zoom out',
            onTap: _controller.zoomOut,
          ),
          _IconBtn(
            icon: Icons.fit_screen_outlined,
            palette: palette,
            tooltip: 'Fit to view',
            onTap: _controller.fitToView,
          ),
          const SizedBox(width: 8),
          _IconBtn(
            icon: Icons.delete_sweep_outlined,
            palette: palette,
            tooltip: 'Clear placed markers',
            onTap: () {
              // Remove only user-placed markers (those not in sample data)
              final sampleIds = {
                's_pin',
                's_flag',
                's_skull',
                's_star',
                's_quest',
                's_diamond',
                's_circle',
                's_cross',
                's_ripple',
              };
              final toRemove = _controller.markers
                  .where((m) => !sampleIds.contains(m.id))
                  .map((m) => m.id)
                  .toList();
              for (final id in toRemove) {
                _controller.removeMarker(id);
              }
            },
          ),
        ],
      ),
    );
  }

  // ── Marker kind selector ───────────────────────────────────────────────────

  Widget _buildMarkerBar(PipboyColorPalette palette) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            'MARKER:',
            style: TextStyle(
              fontFamily: PipboyColorPalette.fontFamily,
              fontSize: 9,
              color: palette.textDim,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          ...PipboyMapMarkerKind.values.map(
            (k) => _MarkerKindBtn(
              kind: k,
              selected: _markerKind == k,
              palette: palette,
              onTap: () => setState(() => _markerKind = k),
            ),
          ),
          const Spacer(),
          Text(
            'RIGHT-CLICK OR LONG-PRESS TO PLACE',
            style: TextStyle(
              fontFamily: PipboyColorPalette.fontFamily,
              fontSize: 8,
              color: palette.textDim.withValues(alpha: 0.55),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ── Status bar ─────────────────────────────────────────────────────────────

  Widget _buildStatusBar(PipboyColorPalette palette) {
    final labelStyle = TextStyle(
      fontFamily: PipboyColorPalette.fontFamily,
      fontSize: 9,
      color: palette.textDim,
      letterSpacing: 1.2,
    );

    return Container(
      height: 26,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text('CURSOR:', style: labelStyle),
          const SizedBox(width: 4),
          ValueListenableBuilder<Offset?>(
            valueListenable: _cursor,
            builder: (context, pos, _) => Text(
              _gridLabel(pos),
              style: labelStyle.copyWith(color: palette.primary),
            ),
          ),
          _divider(palette),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => Text(
              'MARKERS: ${_controller.markers.length}',
              style: labelStyle,
            ),
          ),
          _divider(palette),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) =>
                Text('LINES: ${_controller.lines.length}', style: labelStyle),
          ),
          const Spacer(),
          Text(
            'PAN: DRAG   ZOOM: SCROLL / PINCH',
            style: labelStyle.alpha(0.50),
          ),
        ],
      ),
    );
  }

  Widget _divider(PipboyColorPalette p) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: SizedBox(
      height: 12,
      child: VerticalDivider(color: p.border, width: 1),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Local helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.label,
    required this.active,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool active;
  final PipboyColorPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 24,
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: active ? palette.selection : Colors.transparent,
            border: Border.all(
              color: active ? palette.primary : palette.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: PipboyColorPalette.fontFamily,
              fontSize: 9,
              color: active ? palette.primary : palette.textDim,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.palette,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final PipboyColorPalette palette;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 26,
          height: 26,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(border: Border.all(color: palette.border)),
          child: Icon(icon, size: 14, color: palette.primary),
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}

/// Small button showing a marker icon for the kind-selector bar.
class _MarkerKindBtn extends StatelessWidget {
  const _MarkerKindBtn({
    required this.kind,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final PipboyMapMarkerKind kind;
  final bool selected;
  final PipboyColorPalette palette;
  final VoidCallback onTap;

  static const _labels = {
    PipboyMapMarkerKind.pin: 'PIN',
    PipboyMapMarkerKind.flag: 'FLAG',
    PipboyMapMarkerKind.star: 'STAR',
    PipboyMapMarkerKind.skull: 'SKULL',
    PipboyMapMarkerKind.diamond: 'DMD',
    PipboyMapMarkerKind.circle: 'DOT',
    PipboyMapMarkerKind.cross: 'CROSS',
    PipboyMapMarkerKind.quest: '(!)  ',
    PipboyMapMarkerKind.ripple: 'SIG',
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[kind] ?? kind.name.toUpperCase();
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 22,
          margin: const EdgeInsets.only(right: 3),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: selected ? palette.selection : Colors.transparent,
            border: Border.all(
              color: selected ? palette.primary : palette.border,
              width: selected ? 1.0 : 0.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: PipboyColorPalette.fontFamily,
              fontSize: 8,
              color: selected ? palette.primary : palette.textDim,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to adjust text style opacity conveniently.
extension on TextStyle {
  TextStyle alpha(double a) => copyWith(color: color?.withValues(alpha: a));
}
