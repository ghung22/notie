import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:provider/provider.dart';

import '../container.dart';
import '../sheet.dart';

// region Editor sheets

enum EditorSheets {
  content,
  textFormat,
  textColor,
  backgroundColor,
  undo,
  redo,
}

// region Editor content sheet

enum EditorContentType {
  code,
  quote,
  link,
  image,
  video,
  formula,
}

class EditorContentSheet extends StatefulWidget {
  const EditorContentSheet({Key? key}) : super(key: key);

  @override
  State<EditorContentSheet> createState() => _EditorContentSheetState();
}

class _EditorContentSheetState extends State<EditorContentSheet> {
  EditorStore? _store;

  Future<void> _btnClicked(EditorContentType type) async {
    // Run specific actions (may return without showing any dialog)
    // final quillCtrl = _store!.quillCtrl;
    // final sel = quillCtrl.selection;
    switch (type) {
      case EditorContentType.code:
        _store!.expandSelection();
        break;
      default:
    }

    // Show dialog of corresponding type
    await showModalBottomSheet(
      context: context,
      backgroundColor: _store!.note.color,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * .35,
        maxHeight: MediaQuery.of(context).size.height * .35,
      ),
      builder: (context) {
        switch (type) {
          case EditorContentType.image:
            // TODO: Handle this case.
            break;
          case EditorContentType.link:
            // TODO: Handle this case.
            break;
          default:
        }
        return const Nothing();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (context) {
      return Sheet(
        title: AppLocalizations.of(context)!.add_content,
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: Dimens.editorToolPadding,
          runSpacing: Dimens.editorToolPadding,
          children: [
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.codeblock,
              elevated: true,
              showText: true,
              onPressed: () => _btnClicked(EditorContentType.code),
              child: const Icon(Icons.code_rounded),
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

class EditorContentCodeSheet extends StatelessWidget {
  const EditorContentCodeSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sheet(
      title: AppLocalizations.of(context)!.text_format,
      child: const Nothing(),
    );
  }
}

// endregion

class EditorTextFormatSheet extends StatelessWidget {
  const EditorTextFormatSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sheet(
      title: AppLocalizations.of(context)!.text_format,
      child: const Nothing(),
    );
  }
}

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