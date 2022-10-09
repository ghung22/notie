import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/widget/common/text.dart';

class Sheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Alignment alignment;

  const Sheet({
    Key? key,
    required this.title,
    required this.child,
    this.alignment = Alignment.topCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimens.sheetTitleHeight,
          child: Center(child: Txt.header(text: title)),
        ),
        Expanded(
          child: Align(
            alignment: alignment,
            child: child,
          ),
        ),
        const SizedBox(height: Dimens.sheetTitleHeight),
      ],
    );
  }
}