import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/store/global/language_store.dart';
import 'package:provider/provider.dart';

class AnimatedLanguageUpdate extends StatelessWidget {
  final Widget child;

  const AnimatedLanguageUpdate({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      Strings.isEn;
      return AnimatedOpacity(
        duration: Vars.animationFast,
        opacity: context.read<LanguageStore>().changingLanguage ? 0 : 1,
        child: child,
      );
    });
  }
}