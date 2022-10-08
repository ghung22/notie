import 'package:flutter/material.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/widget/common/container.dart';

import 'text.dart';

class IconBtn extends StatelessWidget {
  final Widget child;
  final Color? color;
  final String tooltipText;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool showText;
  final bool elevated;

  const IconBtn({
    Key? key,
    required this.child,
    this.color,
    this.tooltipText = '',
    this.onPressed,
    this.onLongPressed,
    this.showText = false,
    this.elevated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CaseContainer(
      cases: [
        Case(
          condition: showText && !elevated,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
              padding: Pads.horz(Dimens.btnIconPaddingHorz),
              shape: Borders.btnRounded,
              textStyle: Styles.iconBtnLabel,
            ),
            onPressed: onPressed,
            onLongPress: onLongPressed,
            icon: child,
            label: Txt(text: tooltipText),
          ),
        ),
        Case(
          condition: elevated,
          child: Builder(builder: (context) {
            final bgColor = color ?? Theme.of(context).colorScheme.surface;
            return CaseContainer(
              cases: [
                Case(
                  condition: showText,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      foregroundColor: ColorBuilder.onColor(bgColor),
                      padding: Pads.horz(Dimens.btnIconPaddingHorz),
                      shape: Borders.btnRounded,
                      textStyle: Styles.iconBtnLabel,
                    ),
                    onPressed: onPressed,
                    onLongPress: onLongPressed,
                    icon: child,
                    label: Txt(text: tooltipText),
                  ),
                ),
              ],
              child: Tooltip(
                message: tooltipText,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: ColorBuilder.onColor(bgColor),
                    padding: Pads.none,
                    shape: Borders.btnCircle,
                  ),
                  onPressed: onPressed,
                  onLongPress: onLongPressed,
                  child: child,
                ),
              ),
            );
          }),
        ),
      ],
      child: Tooltip(
        message: tooltipText,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
            padding: Pads.none,
            shape: Borders.btnCircle,
          ),
          onPressed: onPressed,
          onLongPress: onLongPressed,
          child: child,
        ),
      ),
    );
  }
}