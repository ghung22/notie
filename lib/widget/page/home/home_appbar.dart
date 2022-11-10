import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/widget/common/button.dart';

class HomeAppbar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppbar({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: Dimens.bottomAppBarNotchMargin,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.navigation,
            onPressed: () => widget.scaffoldKey.currentState!.openDrawer(),
            child: const Icon(Icons.menu),
          ),
          IconBtn(
            onPressed: () {},
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}