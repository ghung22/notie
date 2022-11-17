import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/container.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: Pads.all(Dimens.drawerPad),
        child: CardItem(
          child: Observer(builder: (_) {
            return ListView(
              children: [
                Stack(
                  children: [
                    const DrawerHeader(child: Nothing()),
                    Padding(
                      padding: Pads.vert(Dimens.drawerItemPad),
                      child: const Nothing(),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}