import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/text.dart';
import 'package:provider/provider.dart';

import '../button.dart';
import '../container.dart';
import '../sheet.dart';
import 'editor_sheet.dart';

enum EditorContentType {
  inline,
  code,
  quote,
  link,
  image,
  video,
  formula,
}

// region Inline code

class EditorContentInline extends StatefulWidget {
  /// Custom data to put into the text field (if null, use selection)
  final String? data;

  const EditorContentInline({Key? key, this.data}) : super(key: key);

  @override
  State<EditorContentInline> createState() => _EditorContentInlineState();
}

class _EditorContentInlineState extends State<EditorContentInline> {
  Widget _input = const Nothing();
  Widget _insert = const Nothing();

  EditorStore? _store;
  final _ctrl = TextEditingController();
  String? _initialText;

  QuillController get _quillCtrl => _store!.quillCtrl;

  TextSelection get _sel => _quillCtrl.selection;

  void _initInput() {
    if (_initialText == null) {
      _initialText =
          widget.data ?? (_sel.isCollapsed ? '' : _quillCtrl.getPlainText());
      _ctrl.value = TextEditingValue(
        text: _initialText!,
        selection: TextSelection.collapsed(offset: _initialText!.length),
      );
    }
    _input = TextField(
      controller: _ctrl,
      keyboardType: TextInputType.text,
      autocorrect: false,
      style: Styles.mono,
      decoration: Styles.inputOutlined.copyWith(
        hintText: AppLocalizations.of(context)!.paste_code_here,
      ),
    );
  }

  void _initInsert() {
    _insert = TextBtn(
      elevated: true,
      onPressed: () {
        _store!.addContent(
          _ctrl.text,
          Attribute.inlineCode,
          selectionCollapsed: (_initialText ?? '') == '',
          separator: ' ',
        );
        Navigator.of(context).pop(EditorDialogResult.success);
      },
      child: Txt(text: AppLocalizations.of(context)!.insert),
    );
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    _initInput();
    _initInsert();

    return SafeArea(
      child: Sheet(
        title: AppLocalizations.of(context)!.code_inline,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _input,
              Padding(
                padding: Pads.sym(
                  h: Dimens.editorToolContentPaddingHorz,
                  v: Dimens.editorToolContentPaddingVert,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _insert,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// endregion

// region Codeblock

class EditorContentCodeblock extends StatefulWidget {
  /// Custom data to put into the text field (if null, use selection)
  final String? code;

  const EditorContentCodeblock({Key? key, this.code}) : super(key: key);

  @override
  State<EditorContentCodeblock> createState() => _EditorContentCodeblockState();
}

class _EditorContentCodeblockState extends State<EditorContentCodeblock> {
  Widget _input = const Nothing();
  Widget _lang = const Nothing();
  Widget _paste = const Nothing();
  Widget _insert = const Nothing();

  EditorStore? _store;
  final _ctrl = TextEditingController();
  String? _initialText;

  QuillController get _quillCtrl => _store!.quillCtrl;

  TextSelection get _sel => _quillCtrl.selection;

  void _initInput() {
    if (_initialText == null) {
      _initialText =
          widget.code ?? (_sel.isCollapsed ? '' : _quillCtrl.getPlainText());
      _ctrl.value = TextEditingValue(
        text: _initialText!,
        selection: TextSelection.collapsed(offset: _initialText!.length),
      );
    }
    _input = TextField(
      controller: _ctrl,
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
    );
  }

  void _initLang() {
    _lang = DropdownButton(
      isExpanded: true,
      items: [
        DropdownMenuItem(
          value: null,
          child: Txt(text: AppLocalizations.of(context)!.language),
        ),
        const DropdownMenuItem(
          value: 'java',
          child: Txt(text: 'Java'),
        ),
      ],
      onChanged: (item) {},
    );
  }

  void _initPaste() {
    _paste = IconBtn(
      tooltipText: AppLocalizations.of(context)!.paste_clipboard,
      elevated: true,
      onPressed: () async {
        final clip = await Clipboard.getData(Clipboard.kTextPlain);
        final clipTxt = clip?.text ?? '';
        if (clipTxt.isNotEmpty) {
          final start = _ctrl.selection.baseOffset;
          final end = _ctrl.selection.extentOffset;
          _ctrl.value = _ctrl.value.copyWith(
            text: _ctrl.text.replaceRange(start, end, clipTxt),
            selection: TextSelection.collapsed(offset: start + clipTxt.length),
          );
        }
      },
      child: const Icon(Icons.paste_rounded),
    );
  }

  void _initInsert() {
    _insert = TextBtn(
      elevated: true,
      onPressed: () {
        _store!.addContent(
          _ctrl.text,
          Attribute.codeBlock,
          selectionCollapsed: (_initialText ?? '') == '',
        );
        Navigator.of(context).pop(EditorDialogResult.success);
      },
      child: Txt(text: AppLocalizations.of(context)!.insert),
    );
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    _initInput();
    _initLang();
    _initPaste();
    _initInsert();

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
                Expanded(child: _input),
                Padding(
                  padding: Pads.sym(
                    h: Dimens.editorToolContentPaddingHorz,
                    v: Dimens.editorToolContentPaddingVert,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _lang),
                      const SizedBox(
                          width: Dimens.editorToolContentPaddingHorz),
                      _paste,
                      _insert,
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

// region Quote

class EditorContentQuote extends StatefulWidget {
  /// Custom data to put into the text field (if null, use selection)
  final String? data;

  const EditorContentQuote({Key? key, this.data}) : super(key: key);

  @override
  State<EditorContentQuote> createState() => _EditorContentQuoteState();
}

class _EditorContentQuoteState extends State<EditorContentQuote> {
  Widget _input = const Nothing();
  Widget _paste = const Nothing();
  Widget _insert = const Nothing();

  EditorStore? _store;
  final _ctrl = TextEditingController();
  String? _initialText;

  QuillController get _quillCtrl => _store!.quillCtrl;

  TextSelection get _sel => _quillCtrl.selection;

  void _initInput() {
    if (_initialText == null) {
      _initialText =
          widget.data ?? (_sel.isCollapsed ? '' : _quillCtrl.getPlainText());
      _ctrl.value = TextEditingValue(
        text: _initialText!,
        selection: TextSelection.collapsed(offset: _initialText!.length),
      );
    }
    _input = TextField(
      controller: _ctrl,
      keyboardType: TextInputType.text,
      decoration: Styles.inputOutlined.copyWith(
        hintText: AppLocalizations.of(context)!.paste_code_here,
      ),
    );
  }

  void _initPaste() {
    _paste = IconBtn(
      tooltipText: AppLocalizations.of(context)!.paste_clipboard,
      elevated: true,
      onPressed: () async {
        final clip = await Clipboard.getData(Clipboard.kTextPlain);
        final clipTxt = clip?.text ?? '';
        if (clipTxt.isNotEmpty) {
          final start = _ctrl.selection.baseOffset;
          final end = _ctrl.selection.extentOffset;
          _ctrl.value = _ctrl.value.copyWith(
            text: _ctrl.text.replaceRange(start, end, clipTxt),
            selection: TextSelection.collapsed(offset: start + clipTxt.length),
          );
        }
      },
      child: const Icon(Icons.paste_rounded),
    );
  }

  void _initInsert() {
    _insert = TextBtn(
      elevated: true,
      onPressed: () {
        _store!.addContent(
          _ctrl.text,
          Attribute.blockQuote,
          selectionCollapsed: (_initialText ?? '') == '',
        );
        Navigator.of(context).pop(EditorDialogResult.success);
      },
      child: Txt(text: AppLocalizations.of(context)!.insert),
    );
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    _initInput();
    _initPaste();
    _initInsert();

    return SafeArea(
      child: Sheet(
        title: AppLocalizations.of(context)!.quote,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .9,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _input,
              Padding(
                padding: Pads.sym(
                  h: Dimens.editorToolContentPaddingHorz,
                  v: Dimens.editorToolContentPaddingVert,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: Dimens.editorToolContentPaddingHorz),
                    _paste,
                    _insert,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// endregion