import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/context/sheet_item.dart';
import 'package:provider/provider.dart';

class EditorToolbar extends StatefulWidget {
  const EditorToolbar({Key? key}) : super(key: key);

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  EditorStore? _store;

  Note get _note => _store?.note ?? const Note();

  Future<void> _btnClicked(EditorSheets type) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: _note.color,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .4,
        maxHeight: MediaQuery.of(context).size.height * .4,
      ),
      builder: (_) {
        return Provider(
          create: (_) => _store!,
          builder: (_, __) {
            switch (type) {
              case EditorSheets.content:
                return const EditorContentSheet();
              case EditorSheets.textFormat:
                return const EditorTextFormatSheet();
              case EditorSheets.textColor:
                return const EditorColorSheet();
              case EditorSheets.backgroundColor:
                return const EditorColorSheet(forText: false);
              case EditorSheets.undo:
                return const EditorUndoSheet();
              case EditorSheets.redo:
                return const EditorUndoSheet(isUndo: false);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (context) {
      return BottomAppBar(
        color: _note.color,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.add_content,
              color: ColorBuilder.onColor(_note.color),
              onPressed: () => _btnClicked(EditorSheets.content),
              child: const Icon(Icons.add_box_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.text_format,
              color: ColorBuilder.onColor(_note.color),
              onPressed: () => _btnClicked(EditorSheets.textFormat),
              child: const Icon(Icons.format_size_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.text_color,
              color: ColorBuilder.onColor(_note.color),
              onPressed: () => _btnClicked(EditorSheets.textColor),
              child: const Icon(Icons.format_color_text_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.background_color,
              color: ColorBuilder.onColor(_note.color),
              onPressed: () => _btnClicked(EditorSheets.backgroundColor),
              child: const Icon(Icons.format_color_fill_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.undo,
              color: ColorBuilder.onColor(_note.color),
              enabled: _store!.quillCtrl.hasUndo,
              onPressed: () => _store!.quillCtrl.undo(),
              onLongPressed: () => _btnClicked(EditorSheets.undo),
              child: const Icon(Icons.undo_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.redo,
              color: ColorBuilder.onColor(_note.color),
              enabled: _store!.quillCtrl.hasRedo,
              onPressed: () => _store!.quillCtrl.redo(),
              onLongPressed: () => _btnClicked(EditorSheets.redo),
              child: const Icon(Icons.redo_rounded),
            ),
          ],
        ),
      );
    });
  }
}