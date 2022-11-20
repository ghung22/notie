import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/store/page/home_store.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/context/button_item.dart';
import 'package:provider/provider.dart';

class HomeToolbar extends StatefulWidget {
  const HomeToolbar({Key? key}) : super(key: key);

  @override
  State<HomeToolbar> createState() => _HomeToolbarState();
}

class _HomeToolbarState extends State<HomeToolbar> {
  HomeStore? _store;

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    // TODO: Select note state
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
              children: [
                Expanded(
                  child: Observer(builder: (_) {
                    return TextField(
                      controller: _store!.searchCtrl,
                      focusNode: _store!.searchFocus,
                      maxLines: 1,
                      style: Styles.footer,
                      decoration: Styles.inputBorderless.copyWith(
                          hintText: AppLocalizations.of(context)!.search_note),
                    );
                  }),
                ),
                const SortTypeBtn(),
                const SortOrderBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}