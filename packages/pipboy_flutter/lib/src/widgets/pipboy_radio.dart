import 'package:flutter/material.dart';
import 'package:pipboy_flutter/src/theme/pipboy_theme_data.dart';

/// A sharp-cornered terminal-style radio button for the Pip-Boy UI.
///
/// Flutter's built-in [Radio] is always circular and provides no shape
/// override.  [PipboyRadio] renders a square outer border with a smaller
/// filled square centre when selected — matching the zero-radius design
/// language of the rest of the theme.
///
/// ```
/// Unselected:  ┌──┐     Selected:  ┌──┐
///              │  │                 │■ │
///              └──┘                 └──┘
/// ```
///
/// Typical usage inside a list:
///
/// ```dart
/// Column(
///   children: List.generate(options.length, (i) =>
///     PipboyRadioTile<int>(
///       value: i,
///       groupValue: _selected,
///       onChanged: (v) => setState(() => _selected = v ?? _selected),
///       title: Text(options[i]),
///     ),
///   ),
/// )
/// ```
class PipboyRadio<T> extends StatelessWidget {
  const PipboyRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  /// The value this button represents.
  final T value;

  /// The currently selected value for this group.
  final T? groupValue;

  /// Called when the user selects this button.  Pass null to disable.
  final ValueChanged<T?>? onChanged;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final p = PipboyThemeData.paletteOf(context);
    final enabled = onChanged != null;
    final selected = _selected;

    final borderColor = !enabled
        ? p.disabled
        : selected
        ? p.primary
        : p.border;
    final innerColor = selected ? (enabled ? p.primary : p.disabled) : null;

    return GestureDetector(
      onTap: enabled ? () => onChanged!(value) : null,
      child: MouseRegion(
        cursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: SizedBox(
          width: 18,
          height: 18,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1.5),
            ),
            // Inner filled square when selected.
            child: innerColor != null
                ? Padding(
                    padding: const EdgeInsets.all(4),
                    child: ColoredBox(color: innerColor),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// A [ListTile]-style row with a leading [PipboyRadio].
///
/// Drop-in replacement for [RadioListTile] that uses the fully rectangular
/// [PipboyRadio] instead of the built-in circular Material radio button.
class PipboyRadioTile<T> extends StatelessWidget {
  const PipboyRadioTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.contentPadding,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Widget title;
  final Widget? subtitle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PipboyRadio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      title: title,
      subtitle: subtitle,
      contentPadding: contentPadding,
      onTap: () => onChanged(value),
    );
  }
}
