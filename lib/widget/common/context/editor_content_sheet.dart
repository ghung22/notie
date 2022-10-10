import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/text.dart';
import 'package:provider/provider.dart';

import '../button.dart';
import '../sheet.dart';
import 'editor_sheet.dart';

enum EditorContentType {
  code,
  inline,
  quote,
  link,
  image,
  video,
  formula,
}

// region Codeblock

class EditorContentCodeblock extends StatefulWidget {
  const EditorContentCodeblock({Key? key}) : super(key: key);

  @override
  State<EditorContentCodeblock> createState() => _EditorContentCodeblockState();
}

class _EditorContentCodeblockState extends State<EditorContentCodeblock> {
  @override
  Widget build(BuildContext context) {
    final store = context.read<EditorStore>();
    final quillCtrl = store.quillCtrl;
    final selText = quillCtrl.getPlainText();
    final ctrl = TextEditingController(text: selText);
    return FractionallySizedBox(
      heightFactor: .9,
      child: SafeArea(
        child: Sheet(
          title: AppLocalizations.of(context)!.codeblock,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: Styles.mono,
                    decoration: Styles.inputOutlined.copyWith(
                      hintText: AppLocalizations.of(context)!.paste_code_here,
                    ),
                  ),
                ),
                Padding(
                  padding: Pads.sym(
                    h: Dimens.editorToolContentPaddingHorz,
                    v: Dimens.editorToolContentPaddingVert,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Txt(
                                  text: AppLocalizations.of(context)!.language),
                            ),
                            const DropdownMenuItem(
                              value: 'java',
                              child: Txt(text: 'Java'),
                            ),
                          ],
                          onChanged: (item) {},
                        ),
                      ),
                      const SizedBox(
                          width: Dimens.editorToolContentPaddingHorz),
                      TextBtn(
                        elevated: true,
                        onPressed: () {
                          final sel = quillCtrl.selection;
                          quillCtrl.replaceText(
                              sel.baseOffset,
                              sel.extentOffset - sel.baseOffset,
                              ctrl.text,
                              sel);
                          quillCtrl.formatSelection(Attribute.codeBlock);
                          Navigator.of(context).pop(EditorDialogResult.success);
                        },
                        child: Txt(text: AppLocalizations.of(context)!.insert),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// endregion