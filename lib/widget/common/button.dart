import 'package:flutter/material.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/widget/common/container.dart';

import 'text.dart';

class IconBtn extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool? enabled;
  final String tooltipText;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool showText;
  final bool elevated;

  const IconBtn({
    Key? key,
    required this.child,
    this.color,
    this.enabled,
    this.tooltipText = '',
    this.onPressed,
    this.onLongPressed,
    this.showText = false,
    this.elevated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled ?? onPressed != null;
    final bgColor = color ?? Theme.of(context).colorScheme.surface;
    return CaseContainer(
      cases: [
        Case(
          condition: showText,
          child: TextBtn(
            icon: child,
            color: bgColor,
            enabled: enabled,
            onPressed: enabled ? onPressed : null,
            onLongPressed: enabled ? onLongPressed : null,
            elevated: elevated,
            child: Txt(text: tooltipText),
          ),
        ),
      ],
      child: CaseContainer(
        cases: [
          Case(
            condition: elevated,
            child: Tooltip(
              message: tooltipText,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  foregroundColor: ColorBuilder.onColor(bgColor),
                  padding: Pads.none,
                  shape: Borders.btnCircle,
                ),
                onPressed: enabled ? onPressed : null,
                onLongPress: enabled ? onLongPressed : null,
                child: child,
              ),
            ),
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
            onPressed: enabled ? onPressed : null,
            onLongPress: enabled ? onLongPressed : null,
            child: child,
          ),
        ),
      ),
    );
  }
}

class TextBtn extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  final Color? color;
  final bool? enabled;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;
  final bool elevated;

  const TextBtn({
    Key? key,
    required this.child,
    this.icon,
    this.color,
    this.enabled,
    this.onPressed,
    this.onLongPressed,
    this.elevated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final enabled = this.enabled ?? onPressed != null;
    final bgColor = color ?? Theme.of(context).colorScheme.surface;
    return CaseContainer(
      cases: [
        Case(
          condition: elevated,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: ColorBuilder.onColor(bgColor),
              padding: Pads.sym(
                h: Dimens.btnPaddingHorz,
                v: Dimens.btnPaddingVert,
              ),
              shape: Borders.btnRounded,
              textStyle: Styles.iconBtnLabel,
            ),
            onPressed: enabled ? onPressed : null,
            onLongPress: enabled ? onLongPressed : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Padding(
                    padding: Pads.right(Dimens.btnIconLabelGap),
                    child: icon!,
                  ),
                child,
              ],
            ),
          ),
        ),
      ],
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
          padding: Pads.sym(
            h: Dimens.btnPaddingHorz,
            v: Dimens.btnPaddingVert,
          ),
          shape: Borders.btnRounded,
          textStyle: Styles.iconBtnLabel,
        ),
        onPressed: enabled ? onPressed : null,
        onLongPress: enabled ? onLongPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: Pads.right(Dimens.btnIconLabelGap),
                child: icon!,
              ),
            child,
          ],
        ),
      ),
    );
  }
}