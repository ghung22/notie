import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/container.dart';
import 'package:provider/provider.dart';

class EditorAppbar extends StatefulWidget {
  const EditorAppbar({Key? key}) : super(key: key);

  @override
  State<EditorAppbar> createState() => _EditorAppbarState();
}

class _EditorAppbarState extends State<EditorAppbar> {
  EditorStore? _store;

  Note get _note => _store?.note ?? const Note();

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (context) {
      return AppBar(
        backgroundColor: _note.color,
        foregroundColor: ColorBuilder.onColor(_note.color),
        title: Observer(builder: (_) {
          return TextField(
            controller: _store!.titleCtrl,
            focusNode: _store!.titleFocus,
            autofocus: _note.isEmpty,
            readOnly: _store!.readOnly,
            maxLines: 1,
            style: TextStyle(color: ColorBuilder.onColor(_note.color)),
            decoration: Styles.inputBorderless
                .copyWith(hintText: AppLocalizations.of(context)!.title),
          );
        }),
        actions: [
          IconBtn(
            color: ColorBuilder.onColor(_note.color),
            onPressed: () => _store!.toggleReadOnly(),
            child: CaseContainer(
              cases: [
                Case(
                  condition: _store!.readOnly,
                  child: const Icon(Icons.edit_rounded),
                ),
              ],
              child: const Icon(Icons.remove_red_eye_rounded),
            ),
          ),
        ],
      );
    });
  }
}