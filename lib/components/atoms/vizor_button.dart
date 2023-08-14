import 'package:flutter/material.dart';
import 'package:vizor/vizor.dart';

class VizorButton extends StatelessWidget {
  final Widget label;
  final VoidCallback onPressed;
  final Widget icon;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final SoundEffect soundEffectOnPressed;

  const VizorButton({
    Key key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
    this.padding,
    this.soundEffectOnPressed,
  }) : super(key: key);

  factory VizorButton.success({
    Key key,
    required Widget label,
    Widget icon,
    EdgeInsets padding,
    VoidCallback onPressed,
  }) {
    return VizorButton(
      key: key,
      label: label,
      icon: icon,
      padding: padding,
      onPressed: onPressed,
      color: Colors.green,
      textColor: Colors.green,
      borderColor: Colors.lightGreenAccent,
      soundEffectOnPressed: SoundEffect.information,
    );
  }

  factory VizorButton.active({
    Key key,
    Widget label,
    Widget icon,
    EdgeInsets padding,
    VoidCallback onPressed,
  }) {
    return VizorButton(
      key: key,
      label: label,
      icon: icon,
      padding: padding,
      onPressed: onPressed,
      color: Colors.tealAccent,
      textColor: Colors.tealAccent,
      backgroundColor: Colors.black.withOpacity(0.9),
      borderColor: Colors.tealAccent,
      soundEffectOnPressed: SoundEffect.click,
    );
  }

  factory VizorButton.cancel({
    Key key,
    Widget label,
    Widget icon,
    EdgeInsets padding,
    VoidCallback onPressed,
  }) {
    return VizorButton(
      key: key,
      label: label,
      icon: icon,
      padding: padding,
      onPressed: onPressed,
      color: Colors.tealAccent,
      textColor: Colors.tealAccent,
      backgroundColor: Colors.black.withOpacity(0.9),
      borderColor: Colors.tealAccent,
      soundEffectOnPressed: SoundEffect.error,
    );
  }

  factory VizorButton.error({
    Key key,
    Widget label,
    Widget icon,
    EdgeInsets padding,
    VoidCallback onPressed,
  }) {
    return VizorButton(
      key: key,
      label: label,
      icon: icon,
      padding: padding,
      onPressed: onPressed,
      color: Colors.red,
      textColor: Colors.red,
      borderColor: Colors.redAccent,
      soundEffectOnPressed: SoundEffect.error,
    );
  }

  void _onPressed(BuildContext context) {
    onPressed?.call();
    SoundProvider.of(context)?.get(soundEffectOnPressed)?.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = VizorTheme.of(context)?.buttonTheme ??
        VizorThemeData.fallback()?.buttonTheme;

    return VizorFrame(
      color: backgroundColor,
      lineColor: borderColor ?? theme.borderColor,
      child: _buildFlatButton(context),
    );
  }

  Widget _buildFlatButton(BuildContext context) {
    final theme = VizorTheme.of(context)?.buttonTheme ??
        VizorThemeData.fallback()?.buttonTheme;

    final color = this.color ?? theme.color;
    final splashColor = color.withOpacity(0.3);

    if (icon == null) {
      return TextButton(
        onPressed: () => _onPressed(context),
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: splashColor,
          minimumSize: Size.zero,
          padding: padding ?? EdgeInsets.all(16.0),
        ),
        child: label,
      );
    } else if (label == null) {
      return IconButton(
        onPressed: () => _onPressed(context),
        color: color,
        splashColor: splashColor,
        padding: padding ?? theme.padding,
        icon: icon,
      );
    } else {
      return TextButton.icon(
        onPressed: () => _onPressed(context),
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? theme.textColor,
          backgroundColor: splashColor,
          minimumSize: Size.zero,
          padding: padding ?? theme.padding,
        ),
        icon: icon,
        label: label,
      );
    }
  }
}
