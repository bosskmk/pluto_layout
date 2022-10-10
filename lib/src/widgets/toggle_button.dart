import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({
    required this.title,
    this.icon,
    this.enabled,
    this.changed,
    super.key,
  });

  final String title;

  final bool? enabled;

  final Widget? icon;

  final void Function(bool)? changed;

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();

    _enabled = widget.enabled == true;
  }

  void onTap() {
    setState(() {
      _enabled = !_enabled;
    });

    if (widget.changed != null) widget.changed!(_enabled);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = TextButton.styleFrom(
      foregroundColor:
          _enabled ? theme.toggleableActiveColor : theme.disabledColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    );

    final title = Text(widget.title);

    return widget.icon != null
        ? TextButton.icon(
            style: style,
            icon: widget.icon!,
            onPressed: onTap,
            label: title,
          )
        : TextButton(
            style: style,
            onPressed: onTap,
            child: title,
          );
  }
}
