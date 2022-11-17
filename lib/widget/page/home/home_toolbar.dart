import 'package:flutter/material.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/text.dart';

class HomeToolbar extends StatefulWidget {
  const HomeToolbar({Key? key}) : super(key: key);

  @override
  State<HomeToolbar> createState() => _HomeToolbarState();
}

class _HomeToolbarState extends State<HomeToolbar> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: Dimens.homeToolbarMaxHeight),
      child: Padding(
        padding: Pads.sym(
            h: Dimens.homeToolbarPadHorz, v: Dimens.homeToolbarPadVert),
        child: SizedBox(
          width: double.infinity,
          child: CardItem(
            padding: Pads.sym(
                h: Dimens.homeToolbarPadInnerHorz,
                v: Dimens.homeToolbarPadInnerVert),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Txt.footer(text: Vars.appName),
                IconBtn(
                  onPressed: () {},
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}