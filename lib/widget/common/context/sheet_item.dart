import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/widget/common/button.dart';

import '../container.dart';
import '../sheet.dart';

enum EditorSheets {
  content,
  textFormat,
  textColor,
  backgroundColor,
  undo,
  redo,
}

class EditorContentSheet extends StatelessWidget {
  const EditorContentSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sheet(
      title: AppLocalizations.of(context)!.add_content,
      child: const Nothing(),
    );
  }
}

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
                  color: colors[index],
                  elevated: true,
                  onPressed: () {},
                  tooltipText: Strings.capitalize(names[index]),
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