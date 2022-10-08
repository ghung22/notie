import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/context/sheet_item.dart';

class EditorToolbar extends StatefulWidget {
  final Note note;
  final QuillController quillController;
  final ScrollController scrollController;

  const EditorToolbar({
    Key? key,
    required this.note,
    required this.quillController,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  Note _note = const Note();
  late final QuillController _quillCtrl;
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _quillCtrl = widget.quillController;
    _scrollCtrl = widget.scrollController;
  }

  Future<void> _btnClicked(EditorSheets type) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: _note.color,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .4,
        maxHeight: MediaQuery.of(context).size.height * .4,
      ),
      builder: (context) {
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
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.add_content,
            onPressed: () => _btnClicked(EditorSheets.content),
            child: const Icon(Icons.add_box_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.text_format,
            onPressed: () => _btnClicked(EditorSheets.textFormat),
            child: const Icon(Icons.format_size_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.text_color,
            onPressed: () => _btnClicked(EditorSheets.textColor),
            child: const Icon(Icons.format_color_text_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.background_color,
            onPressed: () => _btnClicked(EditorSheets.backgroundColor),
            child: const Icon(Icons.format_color_fill_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.undo,
            onPressed: () {},
            onLongPressed: () => _btnClicked(EditorSheets.undo),
            child: const Icon(Icons.undo_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.redo,
            onPressed: () {},
            onLongPressed: () => _btnClicked(EditorSheets.redo),
            child: const Icon(Icons.redo_rounded),
          ),
        ],
      ),
    );
  }
}