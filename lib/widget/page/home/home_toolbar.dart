import 'package:flutter/material.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/text.dart';

class HomeToolbar extends StatefulWidget {
  const HomeToolbar({Key? key}) : super(key: key);

  @override
  State<HomeToolbar> createState() => _HomeToolbarState();
}

class _HomeToolbarState extends State<HomeToolbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Txt.header(text: Vars.appName),
      actions: [
        IconBtn(
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}