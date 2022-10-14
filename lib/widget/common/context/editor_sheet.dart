import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

  // region Button enable checks

  bool get _inlineEnabled =>
      !_store!.hasStyle(Attribute.codeBlock) &&
      !_store!.hasStyle(Attribute.blockQuote);

  bool get _codeEnabled =>
      !_store!.hasStyle(Attribute.inlineCode) &&
      !_store!.hasStyle(Attribute.blockQuote);

  bool get _quoteEnabled =>
      !_store!.hasStyle(Attribute.codeBlock) &&
      !_store!.hasStyle(Attribute.inlineCode);

  bool get _linkEnabled =>
      !_store!.hasStyle(Attribute.codeBlock) &&
      !_store!.hasStyle(Attribute.inlineCode);

  bool get _imageEnabled => true;

  bool get _videoEnabled => true;

  bool get _formulaEnabled => true;

  // endregion

  // region Button highlight checks

  bool get _inlineActive => _store!.hasStyle(Attribute.inlineCode);

  bool get _codeActive => _store!.hasStyle(Attribute.codeBlock);

  bool get _quoteActive => _store!.hasStyle(Attribute.blockQuote);

  bool get _linkActive => _store!.hasStyle(Attribute.link);

  bool get _imageActive => false;

  bool get _videoActive => false;

  bool get _formulaActive => false;

  // endregion

  void _prepareSelection({
    bool forParagraphs = false,
    bool forWords = false,
    Attribute? forAttribute,
  }) {
    // Expand selection to fit any content being applied given style
    if (forAttribute != null) {
      if (_store!.expandStyle(forAttribute)) return;
    }

    // Expand both ends if selecting something, or move the cursor if not
    if (!forParagraphs && !forWords) return;
    final quillCtrl = _store!.quillCtrl;
    final sel = quillCtrl.selection;
    Pattern sep = '\n';
    if (forWords) sep = RegExp(r'\s');
    if (sel.isCollapsed) {
      final txt = quillCtrl.document.toPlainText();
      final end = txt.indexOf(sep, sel.baseOffset);
      quillCtrl.moveCursorToPosition(end);
    } else {
      _store!.expandSelection(separator: sep);
    }
    _store!.contentFocus.unfocus();
  }

  Future<void> _btnClicked(EditorContentType type) async {
    // Run specific actions (may return without showing any dialog)
    var isScrollControlled = false;
    String? value;
    switch (type) {
      case EditorContentType.inline:
        _prepareSelection(
          forWords: true,
          forAttribute: Attribute.inlineCode,
        );
        break;
      case EditorContentType.code:
        isScrollControlled = true;
        _prepareSelection(
          forParagraphs: true,
          forAttribute: Attribute.codeBlock,
        );
        break;
      case EditorContentType.quote:
        isScrollControlled = true;
        _prepareSelection(
          forParagraphs: true,
          forAttribute: Attribute.blockQuote,
        );
        break;
      case EditorContentType.link:
        _prepareSelection(forAttribute: Attribute.link);
        value = _store!.getValue(Attribute.link);
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
          builder: (_, __) => EditorContent(
            contentType: type,
            value: value,
          ),
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
              enabled: _inlineEnabled,
              color: _inlineActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.inline),
              child: const Icon(Icons.code_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.codeblock,
              elevated: true,
              showText: true,
              enabled: _codeEnabled,
              color: _codeActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.code),
              child: const Icon(Icons.data_array_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.quote,
              elevated: true,
              showText: true,
              enabled: _quoteEnabled,
              color: _quoteActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.quote),
              child: const Icon(Icons.format_quote_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.link,
              elevated: true,
              showText: true,
              enabled: _linkEnabled,
              color: _linkActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.link),
              child: const Icon(Icons.link_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.image,
              elevated: true,
              showText: true,
              enabled: _imageEnabled,
              color: _imageActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.image),
              child: const Icon(Icons.image_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.video,
              elevated: true,
              showText: true,
              enabled: _videoEnabled,
              color: _videoActive ? Theme.of(context).primaryColor : null,
              onPressed: () => _btnClicked(EditorContentType.video),
              child: const Icon(Icons.videocam_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.formula,
              elevated: true,
              showText: true,
              enabled: _formulaEnabled,
              color: _formulaActive ? Theme.of(context).primaryColor : null,
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