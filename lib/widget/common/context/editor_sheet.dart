import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:provider/provider.dart';

import '../container.dart';
import '../sheet.dart';
import 'editor_content_sheet.dart';

enum EditorSheets {
  content,
  textFormat,
  textColor,
  backgroundColor,
  undo,
  redo,
}

enum EditorDialogResult {
  success,
  failure,
  canceled,
}

// region Editor content sheet

class EditorContentSheet extends StatefulWidget {
  const EditorContentSheet({Key? key}) : super(key: key);

  @override
  State<EditorContentSheet> createState() => _EditorContentSheetState();
}

class _EditorContentSheetState extends State<EditorContentSheet> {
  EditorStore? _store;

  void _prepareSelection({bool forParagraphs = false, bool forWords = false}) {
    if (!forParagraphs && !forWords) return;
    final quillCtrl = _store!.quillCtrl;
    final sel = quillCtrl.selection;
    Pattern sep = '\n';
    if (forWords) sep = RegExp(r'\s');

    // Expand both ends if selecting something, or move the cursor if not
    if (sel.isCollapsed) {
      final txt = quillCtrl.document.toPlainText();
      final end = txt.indexOf(sep, sel.baseOffset);
      quillCtrl.moveCursorToPosition(end);
    } else {
      _store!.expandSelection(separator: sep);
    }
  }

  Future<void> _btnClicked(EditorContentType type) async {
    // Run specific actions (may return without showing any dialog)
    var isScrollControlled = false;
    switch (type) {
      case EditorContentType.inline:
        _prepareSelection(forWords: true);
        break;
      case EditorContentType.code:
        isScrollControlled = true;
        _prepareSelection(forParagraphs: true);
        break;
      default:
    }

    // Show dialog of corresponding type
    await showModalBottomSheet(
      context: context,
      backgroundColor: _store!.note.color,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Provider(
          create: (_) => _store!,
          builder: (_, __) {
            switch (type) {
              case EditorContentType.inline:
                return const EditorContentInline();
              case EditorContentType.code:
                return const EditorContentCodeblock();
              default:
            }
            return const Nothing();
          },
        );
      },
    ).then((result) {
      if (result == EditorDialogResult.success) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (context) {
      return Sheet(
        title: AppLocalizations.of(context)!.add_content,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: Dimens.editorToolPadding,
          runSpacing: Dimens.editorToolPadding,
          children: [
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.code_inline,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.inline),
              child: const Icon(Icons.code_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.codeblock,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.code),
              child: const Icon(Icons.data_array_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.quote,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.quote),
              child: const Icon(Icons.format_quote_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.link,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.link),
              child: const Icon(Icons.link_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.image,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.image),
              child: const Icon(Icons.image_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.video,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.video),
              child: const Icon(Icons.videocam_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.formula,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.formula),
              child: const Icon(Icons.functions_rounded),
            ),
          ],
        ),
      );
    });
  }
}

// endregion

// region Editor format sheet

class EditorFormatSheet extends StatelessWidget {
  const EditorFormatSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sheet(
      title: AppLocalizations.of(context)!.text_format,
      child: const Nothing(),
    );
  }
}

// endregion

// region Editor color sheet

class EditorColorSheet extends StatelessWidget {
  final bool forText;

  const EditorColorSheet({Key? key, this.forText = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = forText ? ColorOptions.textColors : ColorOptions.noteColors;
    return Sheet(
      title: forText
          ? AppLocalizations.of(context)!.text_color
          : AppLocalizations.of(context)!.background_color,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .75,
        child: Center(
          child: Builder(builder: (context) {
            final names = options.keys.toList();
            final colors = options.values.toList();
            return Wrap(
              children: List.generate(names.length, (index) {
                return IconBtn(
                  tooltipText: Strings.capitalize(names[index]),
                  color: colors[index],
                  elevated: true,
                  onPressed: () {},
                  child: const Nothing(),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

// endregion

// region Editor undo sheet

class EditorUndoSheet extends StatelessWidget {
  final bool isUndo;

  const EditorUndoSheet({Key? key, this.isUndo = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sheet(
      title: isUndo
          ? AppLocalizations.of(context)!.undo
          : AppLocalizations.of(context)!.redo,
      child: const Nothing(),
    );
  }
}

// endregion