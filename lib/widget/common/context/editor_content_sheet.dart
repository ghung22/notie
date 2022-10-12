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

class EditorContent extends StatefulWidget {
  /// Custom data to put into the text field (if null, use selection)
  final EditorContentType contentType;
  final String? data;

  const EditorContent({
    Key? key,
    required this.contentType,
    this.data,
  }) : super(key: key);

  @override
  State<EditorContent> createState() => _EditorContentState();
}

class _EditorContentState extends State<EditorContent> {
  Widget _input = const Nothing();
  Widget _lang = const Nothing();
  Widget _paste = const Nothing();
  Widget _insert = const Nothing();

  // region getters

  EditorContentType get _contentType => widget.contentType;

  Attribute get _format {
    switch (_contentType) {
      case EditorContentType.inline:
        return Attribute.inlineCode;
      case EditorContentType.code:
        return Attribute.codeBlock;
      case EditorContentType.quote:
        return Attribute.blockQuote;
      case EditorContentType.link:
        return Attribute.link;
      default:
    }
    return Attribute.placeholder;
  }

  String get _title {
    switch (_contentType) {
      case EditorContentType.inline:
        return AppLocalizations.of(context)!.code_inline;
      case EditorContentType.code:
        return AppLocalizations.of(context)!.codeblock;
      case EditorContentType.quote:
        return AppLocalizations.of(context)!.quote;
      case EditorContentType.link:
        return AppLocalizations.of(context)!.link;
      case EditorContentType.image:
        return AppLocalizations.of(context)!.image;
      case EditorContentType.video:
        return AppLocalizations.of(context)!.video;
      case EditorContentType.formula:
        return AppLocalizations.of(context)!.formula;
    }
  }

  String? get _data => widget.data;

  bool get _multiline {
    switch (_contentType) {
      case EditorContentType.code:
      case EditorContentType.quote:
        return true;
      default:
    }
    return false;
  }

  TextStyle? get _inputStyle {
    switch (_contentType) {
      case EditorContentType.inline:
      case EditorContentType.code:
        return Styles.mono;
      default:
    }
    return null;
  }

  TextInputType get _keyboardType {
    switch (_contentType) {
      case EditorContentType.code:
        return TextInputType.multiline;
      case EditorContentType.quote:
        return TextInputType.multiline;
      case EditorContentType.link:
        return TextInputType.url;
      default:
    }
    return TextInputType.text;
  }

  bool get _autocorrect {
    switch (_contentType) {
      case EditorContentType.inline:
      case EditorContentType.code:
        return false;
      default:
    }
    return true;
  }

  // endregion

  EditorStore? _store;
  final _ctrl = TextEditingController();
  String? _initialText;

  QuillController get _quillCtrl => _store!.quillCtrl;

  TextSelection get _sel => _quillCtrl.selection;

  void _initInput() {
    if (_initialText == null) {
      _initialText =
          _data ?? (_sel.isCollapsed ? '' : _quillCtrl.getPlainText());
      _ctrl.value = TextEditingValue(
        text: _initialText!,
        selection: TextSelection.collapsed(offset: _initialText!.length),
      );
    }
    _input = TextField(
      controller: _ctrl,
      keyboardType: _multiline ? TextInputType.multiline : _keyboardType,
      autocorrect: _autocorrect,
      minLines: _multiline ? null : 1,
      maxLines: _multiline ? null : 1,
      expands: _multiline,
      textAlignVertical: TextAlignVertical.top,
      style: _inputStyle,
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
          _format,
          selectionCollapsed: (_initialText ?? '') == '',
          separator: _multiline ? '\n' : ' ',
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
      heightFactor: _multiline ? .9 : null,
      child: SafeArea(
        child: Sheet(
          title: _title,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Builder(builder: (context) {
                  if (_multiline) return Expanded(child: _input);
                  return _input;
                }),
                Padding(
                  padding: Pads.sym(
                    h: Dimens.editorToolContentPaddingHorz,
                    v: Dimens.editorToolContentPaddingVert,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_format == Attribute.codeBlock)
                        Expanded(child: _lang),
                      const SizedBox(
                          width: Dimens.editorToolContentPaddingHorz),
                      if (_format == Attribute.codeBlock ||
                          _format == Attribute.blockQuote)
                        _paste,
                      _insert,
                    ],
                  ),
                ),
                if (_multiline)
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}