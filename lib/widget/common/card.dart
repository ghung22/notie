import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';

import 'container.dart';

class CardItem extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final VoidCallback? onPressed;

  const CardItem({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimens.cardPadding),
    this.color,
    this.elevation,
    this.shape,
    this.onPressed,
  }) : super(key: key);

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      elevation: widget.elevation,
      shape: widget.shape,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: Rads.card,
        child: Padding(
          padding: widget.padding,
          child: widget.child,
        ),
      ),
    );
  }
}

class Dropdown extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final Widget? hint;
  final Widget? disabledHint;
  final bool isExpanded;
  final bool enabled;
  final Color? color;
  final Function(int?)? onChanged;

  const Dropdown({
    Key? key,
    required this.items,
    this.value,
    this.hint,
    this.disabledHint,
    this.isExpanded = false,
    this.enabled = true,
    this.color,
    this.onChanged,
  }) : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _value;

  List<DropdownMenuItem<String>> get _items => widget.items;

  Widget? get _hint => widget.hint;

  Widget? get _disabledHint => widget.disabledHint;

  bool get _enabled => widget.enabled;

  Color? get _color => widget.color;

  Function(int?)? get _onChanged => widget.onChanged;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return CardItem(
      padding: Pads.horz(Dimens.dropdownPaddingHorz),
      elevation: Dimens.dropdownElevation,
      shape: Borders.btnRounded,
      color: _color,
      child: DropdownButton<String>(
        hint: _hint,
        disabledHint: _disabledHint,
        isExpanded: widget.isExpanded,
        underline: const Nothing(),
        borderRadius: Rads.card,
        onChanged: _enabled ? (item) => _onChanged?.call(item as int) : null,
        menuMaxHeight: Dimens.dropdownMenuMaxHeight,
        items: _items,
        value: _value,
      ),
    );
  }
}