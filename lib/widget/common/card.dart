import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';

class CardItem extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final VoidCallback? onPressed;

  const CardItem({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(Dimens.cardPadding),
    this.color,
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
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );
  }
}