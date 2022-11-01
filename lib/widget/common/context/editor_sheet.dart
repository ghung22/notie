import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/text.dart';
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

  Color get _activeColor => ColorBuilder.onColor(_store!.note.color);

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

  // region Button active checks

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
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _btnClicked(EditorContentType type) async {
    // Run specific actions (may return without showing any dialog)
    String? value;
    switch (type) {
      case EditorContentType.inline:
        _prepareSelection(
          forWords: true,
          forAttribute: Attribute.inlineCode,
        );
        break;
      case EditorContentType.code:
        _prepareSelection(
          forParagraphs: true,
          forAttribute: Attribute.codeBlock,
        );
        break;
      case EditorContentType.quote:
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
      isScrollControlled: true,
      useRootNavigator: true,
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
      FocusManager.instance.primaryFocus?.unfocus();
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
        titleColor: _activeColor,
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
              color: _inlineActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.inline),
              child: const Icon(Icons.code_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.codeblock,
              elevated: true,
              showText: true,
              enabled: _codeEnabled,
              color: _codeActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.code),
              child: const Icon(Icons.data_array_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.quote,
              elevated: true,
              showText: true,
              enabled: _quoteEnabled,
              color: _quoteActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.quote),
              child: const Icon(Icons.format_quote_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.link,
              elevated: true,
              showText: true,
              enabled: _linkEnabled,
              color: _linkActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.link),
              child: const Icon(Icons.link_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.image,
              elevated: true,
              showText: true,
              enabled: _imageEnabled,
              color: _imageActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.image),
              child: const Icon(Icons.image_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.video,
              elevated: true,
              showText: true,
              enabled: _videoEnabled,
              color: _videoActive ? _activeColor : null,
              onPressed: () => _btnClicked(EditorContentType.video),
              child: const Icon(Icons.videocam_rounded),
            ),
            IconBtn(
              tooltipText: AppLocalizations.of(context)!.formula,
              elevated: true,
              showText: true,
              enabled: _formulaEnabled,
              color: _formulaActive ? _activeColor : null,
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

// FIXME: Bottom sheet open lag
class EditorFormatSheet extends StatefulWidget {
  const EditorFormatSheet({Key? key}) : super(key: key);

  @override
  State<EditorFormatSheet> createState() => _EditorFormatSheetState();
}

class _EditorFormatSheetState extends State<EditorFormatSheet> {
  Widget _font = const Nothing();
  Widget _size = const Nothing();
  Widget _style = const Nothing();
  Widget _align = const Nothing();
  Widget _script = const Nothing();
  Widget _indent = const Nothing();

  EditorStore? _store;

  Color get _activeColor => ColorBuilder.onColor(_store!.note.color);

  // region Button active checks

  bool get _h1Active => _store!.hasStyle(Attribute.h1);

  bool get _h2Active => _store!.hasStyle(Attribute.h2);

  bool get _h3Active => _store!.hasStyle(Attribute.h3);

  bool get _monoActive => _store!.hasStyle(Attribute.font, Themes.fontMono);

  bool get _cursiveActive =>
      _store!.hasStyle(Attribute.font, Themes.fontCursive);

  String get _fontValue {
    var value = 'body';
    if (_h1Active) {
      value = 'h1';
    } else if (_h2Active) {
      value = 'h2';
    } else if (_h3Active) {
      value = 'h3';
    } else if (_monoActive) {
      value = 'mono';
    } else if (_cursiveActive) {
      value = 'cursive';
    }
    return value;
  }

  bool get _boldActive => _store!.hasStyle(Attribute.bold);

  bool get _italicActive => _store!.hasStyle(Attribute.italic);

  bool get _underlineActive => _store!.hasStyle(Attribute.underline);

  bool get _strikeActive => _store!.hasStyle(Attribute.strikeThrough);

  bool get _superscriptActive => _store!.hasStyle(Attribute.script);

  bool get _subscriptActive => _store!.hasStyle(Attribute.script);

  bool get _leftActive =>
      _store!.hasStyle(Attribute.align, Attribute.leftAlignment.value) ||
      !_store!.hasStyle(Attribute.align);

  bool get _centerActive =>
      _store!.hasStyle(Attribute.align, Attribute.centerAlignment.value);

  bool get _rightActive =>
      _store!.hasStyle(Attribute.align, Attribute.rightAlignment.value);

  bool get _justifyActive =>
      _store!.hasStyle(Attribute.align, Attribute.justifyAlignment.value);

  bool get _indentL0Active => !_store!.hasStyle(Attribute.indent);

  bool get _indentL1Active =>
      _store!.hasStyle(Attribute.indent, Attribute.indentL1.value);

  bool get _indentL2Active =>
      _store!.hasStyle(Attribute.indent, Attribute.indentL2.value);

  bool get _indentL3Active =>
      _store!.hasStyle(Attribute.indent, Attribute.indentL3.value);

  // endregion

  void _initFont() {
    _font = Dropdown(
      value: _fontValue,
      items: [
        DropdownMenuItem(
          value: 'body',
          child: Txt(text: AppLocalizations.of(context)!.body),
        ),
        DropdownMenuItem(
          value: 'h1',
          child: Txt(
            text: AppLocalizations.of(context)!.heading('1'),
            style: Styles.h1,
          ),
        ),
        DropdownMenuItem(
          value: 'h2',
          child: Txt(
            text: AppLocalizations.of(context)!.heading('2'),
            style: Styles.h2,
          ),
        ),
        DropdownMenuItem(
          value: 'h3',
          child: Txt(
            text: AppLocalizations.of(context)!.heading('3'),
            style: Styles.h3,
          ),
        ),
        DropdownMenuItem(
          value: Themes.fontMono,
          child: Txt(
            text: Strings.capitalize(Themes.fontMono),
            style: Styles.mono,
          ),
        ),
        DropdownMenuItem(
          value: Themes.fontCursive,
          child: Txt(
            text: Strings.capitalize(Themes.fontCursive),
            style: Styles.cursive,
          ),
        ),
      ],
      onChanged: (item) {},
    );
  }

  void _initSize() {
    _size = Dropdown(
      value: '6',
      items: [
        ...Vars.textSizes.map((size) {
          return DropdownMenuItem(
            value: '$size',
            child: Txt(text: '${size}pt'),
          );
        }).toList(),
      ],
      onChanged: (item) {},
    );
  }

  void _initStyle() {
    _style = Observer(builder: (context) {
      return ToggleBtn(
        isSelected: [
          _boldActive,
          _italicActive,
          _underlineActive,
          _strikeActive
        ],
        activeColor: _activeColor,
        elevated: false,
        multiple: true,
        onChanged: (index) {
          switch (index) {
            case 0:
              _store!.formatSelection(_boldActive
                  ? Attribute.clone(Attribute.bold, null)
                  : Attribute.bold);
              break;
            case 1:
              _store!.formatSelection(_italicActive
                  ? Attribute.clone(Attribute.italic, null)
                  : Attribute.italic);
              break;
            case 2:
              _store!.formatSelection(_underlineActive
                  ? Attribute.clone(Attribute.underline, null)
                  : Attribute.underline);
              break;
            case 3:
              _store!.formatSelection(_strikeActive
                  ? Attribute.clone(Attribute.strikeThrough, null)
                  : Attribute.strikeThrough);
              break;
          }
        },
        tooltipTexts: [
          AppLocalizations.of(context)!.bold,
          AppLocalizations.of(context)!.italic,
          AppLocalizations.of(context)!.underline,
          AppLocalizations.of(context)!.strikethrough,
        ],
        children: const [
          Icon(Icons.format_bold_rounded),
          Icon(Icons.format_italic_rounded),
          Icon(Icons.format_underlined_rounded),
          Icon(Icons.format_strikethrough_rounded),
        ],
      );
    });
  }

  void _initAlign() {
    _align = ToggleBtn(
      isSelected: [_leftActive, _centerActive, _rightActive],
      elevated: true,
      activeColor: _activeColor,
      onChanged: (index) {
        switch (index) {
          case 0:
            _store!.formatSelection(Attribute.leftAlignment);
            break;
          case 1:
            _store!.formatSelection(Attribute.centerAlignment);
            break;
          case 2:
            _store!.formatSelection(Attribute.rightAlignment);
            break;
        }
      },
      tooltipTexts: [
        AppLocalizations.of(context)!.align_left,
        AppLocalizations.of(context)!.align_center,
        AppLocalizations.of(context)!.align_right,
      ],
      children: const [
        Icon(Icons.format_align_left_rounded),
        Icon(Icons.format_align_center_rounded),
        Icon(Icons.format_align_right_rounded),
      ],
    );
  }

  void _initScript() {
    _script = ToggleBtn(
      isSelected: [_superscriptActive, _subscriptActive],
      activeColor: _activeColor,
      elevated: false,
      onChanged: (index) {},
      tooltipTexts: [
        AppLocalizations.of(context)!.superscript,
        AppLocalizations.of(context)!.subscript,
      ],
      children: const [
        Icon(Icons.superscript_rounded),
        Icon(Icons.subscript_rounded),
      ],
    );
  }

  void _initIndent() {
    _indent = StatefulBuilder(builder: (context, setLocalState) {
      return ToggleBtn(
        isSelected: [!_indentL3Active, !_indentL0Active],
        activeColor: _activeColor,
        elevated: false,
        multiple: true,
        onChanged: (index) {
          switch (index) {
            case 0:
              if (_indentL0Active) {
                _store!.formatSelection(Attribute.indentL1);
              } else if (_indentL1Active) {
                _store!.formatSelection(Attribute.indentL2);
              } else if (_indentL2Active) {
                _store!.formatSelection(Attribute.indentL3);
              }
              break;
            case 1:
              if (_indentL3Active) {
                _store!.formatSelection(Attribute.indentL2);
              } else if (_indentL2Active) {
                _store!.formatSelection(Attribute.indentL1);
              } else if (_indentL1Active) {
                _store!
                    .formatSelection(Attribute.clone(Attribute.indent, null));
              }
              break;
          }
          setLocalState(() {});
        },
        tooltipTexts: [
          AppLocalizations.of(context)!.indent_increase,
          AppLocalizations.of(context)!.indent_decrease,
        ],
        children: const [
          Icon(Icons.format_indent_increase_rounded),
          Icon(Icons.format_indent_decrease_rounded),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    _initFont();
    _initSize();
    _initStyle();
    _initAlign();
    _initScript();
    _initIndent();

    return Observer(builder: (context) {
      return Sheet(
        title: AppLocalizations.of(context)!.text_format,
        titleColor: _activeColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _font,
                const SizedBox(width: Dimens.editorToolContentPaddingHorz),
                _size,
              ],
            ),
            const SizedBox(height: Dimens.editorToolContentPaddingVert * 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _style,
                const SizedBox(width: Dimens.editorToolContentPaddingHorz),
                _align,
              ],
            ),
            const SizedBox(height: Dimens.editorToolContentPaddingVert * 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _script,
                const SizedBox(width: Dimens.editorToolContentPaddingHorz),
                _indent,
              ],
            ),
          ],
        ),
      );
    });
  }
}

// endregion

// region Editor color sheet

class EditorColorSheet extends StatefulWidget {
  final bool forText;

  const EditorColorSheet({Key? key, this.forText = true}) : super(key: key);

  @override
  State<EditorColorSheet> createState() => _EditorColorSheetState();
}

class _EditorColorSheetState extends State<EditorColorSheet> {
  EditorStore? _store;

  Color get _activeColor => ColorBuilder.onColor(_store!.note.color);

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    final options =
        widget.forText ? ColorOptions.textColors : ColorOptions.noteColors;
    return Observer(builder: (context) {
      return Sheet(
        title: widget.forText
            ? AppLocalizations.of(context)!.text_color
            : AppLocalizations.of(context)!.background_color,
        titleColor: _activeColor,
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: Center(
            child: Builder(builder: (context) {
              final names = options.keys.toList();
              final colors = options.values.toList();
              return Wrap(
                spacing: Dimens.editorToolContentPaddingHorz,
                runSpacing: Dimens.editorToolContentPaddingVert,
                children: List.generate(names.length, (index) {
                  return IconBtn(
                    tooltipText: Strings.capitalize(names[index]),
                    color: colors[index],
                    elevated: true,
                    onPressed: () {
                      final c = colors[index];
                      if (widget.forText) {
                        _store!.formatSelection(
                            ColorAttribute('#${c.value.toRadixString(16)}'));
                      } else {
                        _store!
                            .setNote(_store!.note.copyWith(colorHex: c.value));
                        SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle(
                            statusBarColor: c,
                            systemNavigationBarColor: c,
                            systemNavigationBarIconBrightness:
                                ColorBuilder.colorBrightnessInvert(c),
                          ),
                        );
                      }
                    },
                    child: const Nothing(),
                  );
                }),
              );
            }),
          ),
        ),
      );
    });
  }
}

// endregion

// region Editor undo sheet

class EditorUndoSheet extends StatefulWidget {
  final bool isUndo;

  const EditorUndoSheet({Key? key, this.isUndo = true}) : super(key: key);

  @override
  State<EditorUndoSheet> createState() => _EditorUndoSheetState();
}

class _EditorUndoSheetState extends State<EditorUndoSheet> {
  EditorStore? _store;

  Color get _activeColor => ColorBuilder.onColor(_store!.note.color);

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (context) {
      return Sheet(
        title: widget.isUndo
            ? AppLocalizations.of(context)!.undo
            : AppLocalizations.of(context)!.redo,
        titleColor: _activeColor,
        child: const Nothing(),
      );
    });
  }
}

// endregion