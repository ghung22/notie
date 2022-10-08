import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/styles.dart';

import 'animated.dart';

class Txt extends StatelessWidget {
  final String? text;
  final String Function()? textCallback;
  final Color? color;
  final TextStyle? style;
  final bool spaced;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final bool softWrap;

  // region Constructors

  const Txt({
    Key? key,
    this.text,
    this.textCallback,
    this.color,
    this.style,
    this.spaced = false,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  })  : assert(text != null && textCallback == null ||
            textCallback != null && text == null),
        super(key: key);

  Txt.header({
    Key? key,
    this.text,
    this.textCallback,
    this.color,
    this.spaced = false,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  })  : style = Styles.header,
        assert(text != null && textCallback == null ||
            textCallback != null && text == null),
        super(key: key);

  Txt.subheader({
    Key? key,
    this.text,
    this.textCallback,
    this.color,
    this.spaced = false,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  })  : style = Styles.subheader,
        assert(text != null && textCallback == null ||
            textCallback != null && text == null),
        super(key: key);

  Txt.footer({
    Key? key,
    this.text,
    this.textCallback,
    this.color,
    this.spaced = false,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  })  : style = Styles.footer,
        assert(text != null && textCallback == null ||
            textCallback != null && text == null),
        super(key: key);

  Txt.error({
    Key? key,
    this.text,
    this.textCallback,
    this.color,
    this.spaced = false,
    this.padding = EdgeInsets.zero,
    this.textAlign = TextAlign.start,
    this.softWrap = false,
  })  : style = Styles.error,
        assert(text != null && textCallback == null ||
            textCallback != null && text == null),
        super(key: key);

  // endregion

  Widget get textWidget => Text(
        text ?? textCallback!(),
        textAlign: textAlign,
        softWrap: softWrap,
        style: style?.copyWith(
          color: color ?? style?.color,
          letterSpacing:
              spaced ? Styles.spacedText.letterSpacing : style?.letterSpacing,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedLanguageUpdate(
      child: Padding(
        padding: padding,
        child: text != null
            ? textWidget
            : Observer(builder: (context) => textWidget),
      ),
    );
  }
}