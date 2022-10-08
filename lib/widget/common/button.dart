import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';

import 'text.dart';

class IconBtn extends StatelessWidget {
  final Widget child;
  final Color? color;
  final String tooltipText;
  final VoidCallback? onPressed;
  final bool showText;

  const IconBtn({
    Key? key,
    required this.child,
    this.color,
    this.tooltipText = '',
    this.onPressed,
    this.showText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showText) {
      return Tooltip(
        message: tooltipText,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
            padding: EdgeInsets.zero,
            shape: Borders.btnCircle,
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
    }
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
        padding: Pads.horz(Dimens.btnIconPaddingHorz),
        shape: Borders.btnRounded,
        textStyle: Styles.iconBtnLabel,
      ),
      onPressed: onPressed,
      icon: child,
      label: Txt(text: tooltipText),
    );
  }
}