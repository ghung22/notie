import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/data/model/folder.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/store/page/home_store.dart';
import 'package:provider/provider.dart';

import '../button.dart';
import '../text.dart';

// region Home buttons

class SortTypeBtn extends StatefulWidget {
  const SortTypeBtn({Key? key}) : super(key: key);

  @override
  State<SortTypeBtn> createState() => _SortTypeBtnState();
}

class _SortTypeBtnState extends State<SortTypeBtn> {
  HomeStore? _store;

  Future<void> _buttonPressed() async {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final x = offset.dx, y = offset.dy, w = box.size.width, h = box.size.height;
    final result = await showMenu<SortType>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(x, y, 0, 0),
        Rect.fromLTWH(0, 0, w, h),
      ),
      shape: Borders.card,
      items: [
        PopupMenuItem(
          value: SortType.byDefault,
          child: Txt(text: AppLocalizations.of(context)!.sort_default),
        ),
        PopupMenuItem(
          value: SortType.byName,
          child: Txt(text: AppLocalizations.of(context)!.sort_name),
        ),
        PopupMenuItem(
          value: SortType.byColor,
          child: Txt(text: AppLocalizations.of(context)!.sort_color),
        ),
        PopupMenuItem(
          value: SortType.byCreateTime,
          child: Txt(text: AppLocalizations.of(context)!.sort_create),
        ),
        PopupMenuItem(
          value: SortType.byUpdateTime,
          child: Txt(text: AppLocalizations.of(context)!.sort_update),
        ),
        if (_store!.path == FolderPaths.trash)
          PopupMenuItem(
            value: SortType.byDeleteTime,
            child: Txt(text: AppLocalizations.of(context)!.sort_delete),
          ),
      ],
    );
    if (result == null) return;
    _store!.sort(result);
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    return Observer(builder: (context) {
      return IconBtn(
        onPressed: () => _buttonPressed(),
        child: Icon(_store!.sortTypeIcon),
      );
    });
  }
}

class SortOrderBtn extends StatefulWidget {
  const SortOrderBtn({Key? key}) : super(key: key);

  @override
  State<SortOrderBtn> createState() => _SortOrderBtnState();
}

class _SortOrderBtnState extends State<SortOrderBtn> {
  HomeStore? _store;

  Future<void> _buttonPressed() async => _store!.reverseOrder();

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    return Observer(builder: (context) {
      return AnimatedRotation(
        turns: _store!.sortOrder == SortOrder.descending ? 0 : -1 / 2,
        duration: Vars.animationFast,
        child: IconBtn(
          onPressed: () => _buttonPressed(),
          child: const Icon(Icons.arrow_circle_down_rounded),
        ),
      );
    });
  }
}

class SelectCancelBtn extends StatefulWidget {
  const SelectCancelBtn({Key? key}) : super(key: key);

  @override
  State<SelectCancelBtn> createState() => _SelectCancelBtnState();
}

class _SelectCancelBtnState extends State<SelectCancelBtn> {
  HomeStore? _store;

  Future<void> _buttonPressed() async => _store!.unselect();

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    return IconBtn(
      onPressed: () => _buttonPressed(),
      child: const Icon(Icons.close_rounded),
    );
  }
}

class SelectAllBtn extends StatefulWidget {
  const SelectAllBtn({Key? key}) : super(key: key);

  @override
  State<SelectAllBtn> createState() => _SelectAllBtnState();
}

class _SelectAllBtnState extends State<SelectAllBtn> {
  HomeStore? _store;

  Future<void> _buttonPressed() async => _store!.selectAll();

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    return Observer(builder: (context) {
      return IconBtn(
        onPressed: () => _buttonPressed(),
        child: Icon(_store!.allSelected
            ? CupertinoIcons.square_grid_2x2_fill
            : CupertinoIcons.square_grid_2x2),
      );
    });
  }
}

// endregion