import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pipboy_flutter/pipboy_flutter.dart';

/// Demo page for [PipboyMap] — showcases all marker kinds, line styles,
/// pan/zoom, interactive placement, and drag/tap-tap line drawing.
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

  // Selected marker kind for placement
  PipboyMapMarkerKind _markerKind = PipboyMapMarkerKind.pin;

  // Line drawing
  bool _lineMode = false;
  PipboyMapLineStyle _lineStyle = PipboyMapLineStyle.solid;

  // Status bar — ValueNotifier avoids rebuilding the whole page on mouse-move
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

    for (final m in ms) _controller.addMarker(m);
    for (final l in ls) _controller.addLine(l);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _MapLayout(constraints.maxWidth);
        return Column(
          children: [
            _buildToolbar(palette, layout),
            if (_lineMode) _buildLineBar(palette, layout),
            _buildMarkerBar(palette, layout),
            Expanded(child: _buildMap(palette)),
            _buildStatusBar(palette, layout),
          ],
        );
      },
    );
  }

  // ── Map ────────────────────────────────────────────────────────────────────

  Widget _buildMap(PipboyColorPalette palette) {
    return PipboyMap(
      controller: _controller,
      showGrid: _showGrid,
      showCrosshair: _showCrosshair,
      showScaleBar: _showScaleBar,
      showMarkerLabels: _showLabels,
      isMarkerPlacementEnabled: _placementEnabled,
      isLineDrawingEnabled: _lineMode,
      defaultMarkerKind: _markerKind,
      defaultMarkerIsBlinking: false,
      defaultLineStyle: _lineStyle,
      // Adding a marker auto-adds it to the controller
      onMarkerAdded: _controller.addMarker,
      // Tapping an existing marker removes it
      onMarkerTapped: (m) => _controller.removeMarker(m.id),
      // Completing a line auto-adds it and exits line mode
      onLineAdded: (line) {
        _controller.addLine(line);
        setState(() => _lineMode = false);
      },
      onCursorMoved: (pos) => _cursor.value = pos,
      mapBackground: SvgPicture.asset(
        'assets/world.svg',
        fit: BoxFit.fill,
        colorFilter: ColorFilter.mode(
          palette.primary.withValues(alpha: 0.40),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  // ── Toolbar ────────────────────────────────────────────────────────────────

  Widget _buildToolbar(PipboyColorPalette palette, _MapLayout layout) {
    return Container(
      height: layout.toolbarH,
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // Toggle buttons — scrollable on narrow screens
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ToggleBtn(
                    label: 'GRID',
                    active: _showGrid,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () => setState(() => _showGrid = !_showGrid),
                  ),
                  _ToggleBtn(
                    label: 'CROSSHAIR',
                    active: _showCrosshair,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () =>
                        setState(() => _showCrosshair = !_showCrosshair),
                  ),
                  _ToggleBtn(
                    label: 'SCALE',
                    active: _showScaleBar,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () =>
                        setState(() => _showScaleBar = !_showScaleBar),
                  ),
                  _ToggleBtn(
                    label: 'LABELS',
                    active: _showLabels,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () => setState(() => _showLabels = !_showLabels),
                  ),
                  _ToggleBtn(
                    label: 'PLACE',
                    active: _placementEnabled,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () =>
                        setState(() => _placementEnabled = !_placementEnabled),
                  ),
                  _ToggleBtn(
                    label: 'LINE',
                    active: _lineMode,
                    palette: palette,
                    height: layout.btnH,
                    fontSize: layout.fontSize,
                    onTap: () => setState(() {
                      _lineMode = !_lineMode;
                      if (_lineMode) _placementEnabled = false;
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Zoom / utility icon buttons
          _IconBtn(
            icon: Icons.add,
            palette: palette,
            size: layout.iconBtnSz,
            iconSize: layout.iconSize,
            tooltip: 'Zoom in',
            onTap: _controller.zoomIn,
          ),
          _IconBtn(
            icon: Icons.remove,
            palette: palette,
            size: layout.iconBtnSz,
            iconSize: layout.iconSize,
            tooltip: 'Zoom out',
            onTap: _controller.zoomOut,
          ),
          _IconBtn(
            icon: Icons.fit_screen_outlined,
            palette: palette,
            size: layout.iconBtnSz,
            iconSize: layout.iconSize,
            tooltip: 'Fit to view',
            onTap: _controller.fitToView,
          ),
          const SizedBox(width: 6),
          _IconBtn(
            icon: Icons.delete_sweep_outlined,
            palette: palette,
            size: layout.iconBtnSz,
            iconSize: layout.iconSize,
            tooltip: 'Clear placed markers & lines',
            onTap: _clearUserContent,
          ),
        ],
      ),
    );
  }

  void _clearUserContent() {
    const sampleMarkerIds = {
      's_pin', 's_flag', 's_skull', 's_star', 's_quest',
      's_diamond', 's_circle', 's_cross', 's_ripple',
    };
    const sampleLineIds = {'l_solid', 'l_dashed', 'l_dotted', 'l_flow'};

    final markersToRemove = _controller.markers
        .where((m) => !sampleMarkerIds.contains(m.id))
        .map((m) => m.id)
        .toList();
    for (final id in markersToRemove) _controller.removeMarker(id);

    final linesToRemove = _controller.lines
        .where((l) => !sampleLineIds.contains(l.id))
        .map((l) => l.id)
        .toList();
    for (final id in linesToRemove) _controller.removeLine(id);
  }

  // ── Line bar ───────────────────────────────────────────────────────────────

  Widget _buildLineBar(PipboyColorPalette palette, _MapLayout layout) {
    return Container(
      height: layout.lineBarH,
      color: palette.selection,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(
            'LINE DRAW',
            style: TextStyle(
              fontFamily: PipboyColorPalette.fontFamily,
              fontSize: layout.fontSize,
              color: palette.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 12),
          // Style selector — scrollable on narrow screens
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: PipboyMapLineStyle.values
                    .map(
                      (s) => _ToggleBtn(
                        label: s.name.toUpperCase(),
                        active: _lineStyle == s,
                        palette: palette,
                        height: layout.btnH - 2,
                        fontSize: layout.fontSizeSmall,
                        onTap: () => setState(() => _lineStyle = s),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _ToggleBtn(
            label: 'CANCEL',
            active: false,
            palette: palette,
            height: layout.btnH - 2,
            fontSize: layout.fontSize,
            onTap: () => setState(() => _lineMode = false),
          ),
        ],
      ),
    );
  }

  // ── Marker kind selector ───────────────────────────────────────────────────

  Widget _buildMarkerBar(PipboyColorPalette palette, _MapLayout layout) {
    final labelStyle = TextStyle(
      fontFamily: PipboyColorPalette.fontFamily,
      fontSize: layout.fontSizeSmall,
      color: palette.textDim,
      letterSpacing: 1.5,
    );

    return Container(
      height: layout.markerBarH,
      decoration: BoxDecoration(
        color: palette.background,
        border: Border(bottom: BorderSide(color: palette.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text('MARKER:', style: labelStyle),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: PipboyMapMarkerKind.values
                    .map(
                      (k) => _MarkerKindBtn(
                        kind: k,
                        selected: _markerKind == k,
                        palette: palette,
                        height: layout.markerBtnH,
                        fontSize: layout.fontSizeSmall,
                        onTap: () => setState(() => _markerKind = k),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'TAP / LONG-PRESS / RIGHT-CLICK TO PLACE  ·  TAP MARKER TO REMOVE',
            style: labelStyle.copyWith(
              fontSize: layout.fontSizeSmall - 1,
              color: palette.textDim.withValues(alpha: 0.50),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  // ── Status bar ─────────────────────────────────────────────────────────────

  Widget _buildStatusBar(PipboyColorPalette palette, _MapLayout layout) {
    final labelStyle = TextStyle(
      fontFamily: PipboyColorPalette.fontFamily,
      fontSize: layout.fontSize,
      color: palette.textDim,
      letterSpacing: 1.2,
    );

    return Container(
      height: layout.statusBarH,
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
            style: labelStyle.copyWith(
              color: palette.textDim.withValues(alpha: 0.50),
            ),
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
// Responsive layout helper
// ─────────────────────────────────────────────────────────────────────────────

class _MapLayout {
  _MapLayout(double width) : _compact = width < 600;
  final bool _compact;

  double get toolbarH    => _compact ? 48.0 : 44.0;
  double get lineBarH    => _compact ? 44.0 : 36.0;
  double get markerBarH  => _compact ? 46.0 : 38.0;
  double get statusBarH  => _compact ? 36.0 : 30.0;
  double get btnH        => _compact ? 36.0 : 28.0;
  double get iconBtnSz   => _compact ? 34.0 : 28.0;
  double get markerBtnH  => _compact ? 32.0 : 26.0;
  // Always use the palette's readable size — never below 10px
  double get fontSize      => PipboyColorPalette.fontSizeSmall; // 11.0
  double get fontSizeSmall => 10.0;
  double get iconSize    => _compact ? 18.0 : 15.0;
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
    this.height = 28.0,
    this.fontSize = 11.0,
  });

  final String label;
  final bool active;
  final PipboyColorPalette palette;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: height,
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
              fontSize: fontSize,
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
    this.size = 28.0,
    this.iconSize = 15.0,
    this.tooltip,
  });

  final IconData icon;
  final PipboyColorPalette palette;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final btn = GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(border: Border.all(color: palette.border)),
          child: Icon(icon, size: iconSize, color: palette.primary),
        ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: btn) : btn;
  }
}

class _MarkerKindBtn extends StatelessWidget {
  const _MarkerKindBtn({
    required this.kind,
    required this.selected,
    required this.palette,
    required this.onTap,
    this.height = 26.0,
    this.fontSize = 10.0,
  });

  final PipboyMapMarkerKind kind;
  final bool selected;
  final PipboyColorPalette palette;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  static const _labels = {
    PipboyMapMarkerKind.pin:     'PIN',
    PipboyMapMarkerKind.flag:    'FLAG',
    PipboyMapMarkerKind.star:    'STAR',
    PipboyMapMarkerKind.skull:   'SKULL',
    PipboyMapMarkerKind.diamond: 'DMD',
    PipboyMapMarkerKind.circle:  'DOT',
    PipboyMapMarkerKind.cross:   'CROSS',
    PipboyMapMarkerKind.quest:   '(!)',
    PipboyMapMarkerKind.ripple:  'SIG',
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[kind] ?? kind.name.toUpperCase();
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: height,
          margin: const EdgeInsets.only(right: 3),
          padding: const EdgeInsets.symmetric(horizontal: 8),
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
              fontSize: fontSize,
              color: selected ? palette.primary : palette.textDim,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
