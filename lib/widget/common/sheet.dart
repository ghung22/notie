import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/widget/common/text.dart';

class Sheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? titleColor;
  final Alignment alignment;
  final bool bottomPadding;

  const Sheet({
    Key? key,
    required this.title,
    required this.child,
    this.titleColor,
    this.alignment = Alignment.topCenter,
    this.bottomPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimens.sheetTitleHeight,
          child: Center(child: Txt.header(text: title, color: titleColor)),
        ),
        Expanded(
          child: Align(
            alignment: alignment,
            child: child,
          ),
        ),
        if (bottomPadding && MediaQuery.of(context).viewInsets.bottom <= 0)
          const SizedBox(height: Dimens.sheetTitleHeight),
      ],
    );
  }
}