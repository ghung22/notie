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
  image,
  link,
}

class EditorContentSheet extends StatefulWidget {
  const EditorContentSheet({Key? key}) : super(key: key);

  @override
  State<EditorContentSheet> createState() => _EditorContentSheetState();
}

class _EditorContentSheetState extends State<EditorContentSheet> {
  EditorStore? _store;

  Future<void> _btnClicked(EditorContentType type) async {
    final quillCtrl = _store!.quillCtrl;
    final sel = quillCtrl.selection;
    switch (type) {
      case EditorContentType.code:
        quillCtrl.formatSelection(Attribute.codeBlock);
        return;
      default:
    }
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
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: Center(
            child: Wrap(
              children: [
                IconBtn(
                  tooltipText: 'Code',
                  elevated: true,
                  onPressed: () => _btnClicked(EditorContentType.code),
                  child: const Icon(Icons.code_rounded),
                ),
              ],
            ),
          ),
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