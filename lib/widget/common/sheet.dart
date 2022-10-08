import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/widget/common/text.dart';

class Sheet extends StatelessWidget {
  final String title;
  final Widget child;

  const Sheet({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: Dimens.sheetTitleHeight,
          child: Center(child: Txt.header(text: title)),
        ),
        child,
      ],
    );
  }
}