import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// A sharp-cornered terminal-style toggle switch for the Pip-Boy UI.
///
/// Flutter's built-in [Switch] uses rounded shapes that cannot be overridden
/// via [SwitchThemeData].  [PipboySwitch] renders a fully rectangular track
/// and thumb with no border-radius anywhere, staying true to the CRT-terminal
/// aesthetic.
///
/// ```dart
/// PipboySwitch(
///   value: _enabled,
///   onChanged: (v) => setState(() => _enabled = v),
/// )
/// ```
///
/// For a list-tile layout use [PipboySwitchTile].
class PipboySwitch extends StatefulWidget {
  const PipboySwitch({super.key, required this.value, this.onChanged});

  /// Current toggle state.
  final bool value;

  /// Called when the user taps the switch.  Pass null to disable.
  final ValueChanged<bool>? onChanged;

  @override
  State<PipboySwitch> createState() => _PipboySwitchState();
}

class _PipboySwitchState extends State<PipboySwitch>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _thumb;

  static const _trackW = 44.0;
  static const _trackH = 22.0;
  static const _thumbSize = 16.0;
  static const _pad = (_trackH - _thumbSize) / 2;
  static const _travel = _trackW - _thumbSize - _pad * 2;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      value: widget.value ? 1.0 : 0.0,
    );
    _thumb = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(PipboySwitch old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    final enabled = widget.onChanged != null;

    return GestureDetector(
      onTap: enabled ? () => widget.onChanged!(!widget.value) : null,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: AnimatedBuilder(
          animation: _thumb,
          builder: (context, _) {
            final t = _thumb.value;
            final on = widget.value;

            // Track
            final trackColor = !enabled
                ? p.disabled.withValues(alpha: 0.25)
                : on
                ? p.primary
                : p.surface;
            final borderColor = !enabled
                ? p.disabled.withValues(alpha: 0.4)
                : on
                ? Colors.transparent
                : p.border;

            // Thumb
            final thumbColor = !enabled
                ? p.disabled
                : on
                ? p.background
                : p.textDim;

            return SizedBox(
              width: _trackW,
              height: _trackH,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: trackColor,
                  border: Border.all(color: borderColor),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: _pad + t * _travel,
                      top: _pad,
                      child: SizedBox(
                        width: _thumbSize,
                        height: _thumbSize,
                        child: ColoredBox(color: thumbColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A [ListTile]-style row with a [PipboySwitch] as its trailing widget.
///
/// Mirrors the API of [SwitchListTile] but uses the fully rectangular
/// [PipboySwitch] instead of the rounded Material [Switch].
class PipboySwitchTile extends StatelessWidget {
  const PipboySwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget title;
  final Widget? subtitle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      trailing: PipboySwitch(value: value, onChanged: onChanged),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}
