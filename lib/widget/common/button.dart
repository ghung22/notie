import 'package:flutter/material.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/widget/common/container.dart';

import 'text.dart';

// region Icon and Text

class IconBtn extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double size;
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
    this.size = Dimens.btnIconMinSize,
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
                  minimumSize: Size.square(size),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              minimumSize: Size.square(size),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

// endregion

// region Toggle

class ToggleBtn extends StatefulWidget {
  final List<Widget> children;
  final List<bool> isSelected;
  final List<String>? tooltipTexts;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? activeColor;
  final bool? enabled;
  final bool? elevated;
  final ValueChanged<int>? onChanged;

  const ToggleBtn({
    Key? key,
    required this.children,
    required this.isSelected,
    this.tooltipTexts,
    this.foregroundColor,
    this.backgroundColor,
    this.activeColor,
    this.enabled,
    this.elevated,
    this.onChanged,
  })  : assert(children.length == isSelected.length),
        super(key: key);

  @override
  State<ToggleBtn> createState() => _ToggleBtnState();
}

class _ToggleBtnState extends State<ToggleBtn> {
  late List<bool> isSelected;

  List<Widget> get _children => widget.children;

  List<bool> get _selected => widget.isSelected;

  List<String>? get _tooltipTexts => widget.tooltipTexts;

  Color? get _fg => widget.foregroundColor;

  Color? get _bg => widget.backgroundColor;

  Color? get _active => widget.activeColor;

  bool? get _enabled => widget.enabled;

  bool? get _elevated => widget.elevated;

  ValueChanged<int>? get _onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: Rads.btnRounded,
        color: _bg ?? Theme.of(context).colorScheme.onSurface.withOpacity(.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _children.map((child) {
          final i = _children.indexOf(child);
          final selected = _selected[i];
          final active =
              _active ?? _fg ?? Theme.of(context).colorScheme.surface;
          final onActive =
              _active != null ? ColorBuilder.onColor(active) : null;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: i == 0
                    ? const Radius.circular(Dimens.btnRadius)
                    : Radius.zero,
                bottomLeft: i == 0
                    ? const Radius.circular(Dimens.btnRadius)
                    : Radius.zero,
                topRight: i == _children.length - 1
                    ? const Radius.circular(Dimens.btnRadius)
                    : Radius.zero,
                bottomRight: i == _children.length - 1
                    ? const Radius.circular(Dimens.btnRadius)
                    : Radius.zero,
              ),
              color: (selected && _elevated == false) ? active : null,
            ),
            child: IconBtn(
              tooltipText: _tooltipTexts?[_children.indexOf(child)] ?? '',
              color: selected ? ((_elevated == true) ? active : onActive) : _fg,
              size: Dimens.btnToggleMinSize,
              elevated: _elevated ?? selected,
              enabled: _enabled,
              onPressed: () => _onChanged?.call(_children.indexOf(child)),
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// endregion