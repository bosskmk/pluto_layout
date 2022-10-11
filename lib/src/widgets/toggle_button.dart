import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    required this.title,
    required this.enabled,
    this.icon,
    this.changed,
    super.key,
  });

  final String title;

  final bool enabled;

  final Widget? icon;

  final void Function(bool)? changed;

  void onTap() {
    if (changed != null) changed!(!enabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = TextButton.styleFrom(
      foregroundColor:
          enabled ? theme.toggleableActiveColor : theme.disabledColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );

    final label = Text(title);

    return icon != null
        ? TextButton.icon(
            style: style,
            icon: icon!,
            onPressed: onTap,
            label: label,
          )
        : TextButton(
            style: style,
            onPressed: onTap,
            child: label,
          );
  }
}
