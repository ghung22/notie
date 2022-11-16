import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/strings.dart';
import 'package:notie/global/vars.dart';

part 'editor_store.g.dart';

class EditorStore = _EditorStore with _$EditorStore;

abstract class _EditorStore with Store {
  // region observable
  @observable
  Note note = Note.empty;

  @observable
  bool readOnly = false;

  @observable
  Offset tapPosition = Offset.zero;

  @observable
  TextEditingController titleCtrl = TextEditingController();

  @observable
  QuillController quillCtrl = QuillController.basic();

  @observable
  ScrollController scrollCtrl = ScrollController();

  @observable
  FocusNode titleFocus = FocusNode();

  @observable
  FocusNode contentFocus = FocusNode();

  // endregion

  // region computed

  @computed
  String get currentWord => _getTextFrom(separator: ' ');

  @computed
  String get currentLine => _getTextFrom(separator: '\n');

  // endregion

  @action
  void dispose() {
    titleCtrl.dispose();
    quillCtrl.dispose();
    scrollCtrl.dispose();
    titleFocus.dispose();
    contentFocus.dispose();
  }

  // region Editor actions

  @action
  void setNote(Note note) {
    this.note = note;
    titleCtrl.text = note.title;
    quillCtrl = QuillController(
      document: note.content.isNotEmpty
          ? Document.fromJson(jsonDecode(note.content))
          : Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillCtrl.moveCursorToEnd();
    Debug.log(null, 'Editor opened for data: $note');

    if (_onTitleChanged == null) {
      _onTitleChanged = () => note.title = titleCtrl.text;
      titleCtrl.addListener(_onTitleChanged!);
    }
    if (_onContentChanged == null) {
      _onContentChanged = () =>
          note.content = jsonEncode(quillCtrl.document.toDelta().toJson());
      quillCtrl.addListener(_onContentChanged!);
    }
  }

  @action
  void setReadOnly(bool readOnly) => this.readOnly = readOnly;

  @action
  void toggleReadOnly() => readOnly = !readOnly;

  @action
  void setTapPosition(Offset tapPosition) => this.tapPosition = tapPosition;

  // endregion

  // region Quill actions

  TextSelection get _selection => quillCtrl.selection;

  String get _plainContent => quillCtrl.document.toPlainText();

  /// Check if selection has the given style
  @action
  bool hasStyle(Attribute attribute, [dynamic value]) {
    final attrs = quillCtrl
        .getAllSelectionStyles()
        .where((e) => e.containsKey(attribute.key))
        .toList();
    if (value == null) return attrs.isNotEmpty;
    return attrs
        .any((e) => e.attributes.values.any((attr) => attr.value == value));
  }

  /// Get value of the given style for the current selection
  @action
  dynamic getValue(Attribute attribute) {
    final attrs = quillCtrl
        .getAllSelectionStyles()
        .where((e) => e.containsKey(attribute.key))
        .toList();
    if (attrs.isEmpty) return null;
    return attrs.first.single.value;
  }

  /// Auto expand to all text formatted with a given style
  @action
  bool expandStyle(Attribute attribute) {
    if (!hasStyle(attribute)) return false;

    // Get insert operations done on this document
    final ops = quillCtrl.document
        .toDelta()
        .toList()
        .where((op) => op.hasAttribute(attribute.key))
        .toList();
    if (ops.isEmpty) return false;

    // Find the operation which range surrounds the cursor and extend selection
    final base = _selection.baseOffset;
    final extent = _selection.extentOffset;
    for (Operation op in ops) {
      final val = '${op.value}';

      // If attribute is full line
      if (val.trim().isEmpty) {
        if (_selection.isCollapsed) {
          quillCtrl.updateSelection(
            _selection.copyWith(baseOffset: base - 1, extentOffset: base),
            ChangeSource.LOCAL,
          );
          if (quillCtrl.getPlainText().startsWith('\n')) {
            quillCtrl.updateSelection(
              _selection.copyWith(baseOffset: base, extentOffset: base + 1),
              ChangeSource.LOCAL,
            );
          }
        }
        expandSelection();
        return true;
      }

      // If attribute is inline
      final opStart = _plainContent.indexOf(val);
      final opEnd = opStart + val.length;
      if (opStart <= base && extent <= opEnd) {
        quillCtrl.updateSelection(
          _selection.copyWith(baseOffset: opStart, extentOffset: opEnd),
          ChangeSource.LOCAL,
        );
        return true;
      }
    }
    return false;
  }

  /// Expand selection to be surrounded by a separator
  @action
  void expandSelection({Pattern separator = '\n'}) {
    // Find the closest newline at both ends of the selection
    final base = _selection.baseOffset;
    final extent = _selection.extentOffset;
    var lineStart = _plainContent.lastIndexOf(separator, base) + 1;
    var lineEnd = _plainContent.indexOf(separator, extent);
    if (lineStart == -1) lineStart = base;
    if (lineEnd == -1) lineEnd = extent;

    // Expand selection to include the whole line
    quillCtrl.updateSelection(
      _selection.copyWith(baseOffset: lineStart, extentOffset: lineEnd),
      ChangeSource.LOCAL,
    );
  }

  /// Add a formatted block to the document at the current cursor position
  @action
  void addContent(
    String data,
    Attribute attribute, {
    bool selectionCollapsed = false,
    String separator = '\n',
  }) {
    // Trim text and add newline if needed
    var text = data.trim();
    if (selectionCollapsed) text = '$separator$text';

    // Replace editor text and move to the new line if needed
    final sel = _selection;
    quillCtrl.replaceText(
        sel.baseOffset, sel.extentOffset - sel.baseOffset, text, sel);
    if (selectionCollapsed) {
      quillCtrl.updateSelection(
        sel.copyWith(
          baseOffset: sel.baseOffset + separator.length,
          extentOffset: sel.baseOffset + text.length,
        ),
        ChangeSource.LOCAL,
      );
    }

    // Format the new text
    quillCtrl.formatSelection(attribute);
  }

  /// Format a selection and hide keyboard
  @action
  void formatSelection(Attribute attribute) {
    switch (attribute.key) {
      // Text casing
      case Formats.lower:
      case Formats.caps:
      case Formats.upper:
        // Get selection text (expand to current word if selection is collapsed)
        if (_selection.isCollapsed) expandSelection(separator: ' ');
        final sel = _selection;
        var text = quillCtrl.document.getPlainText(_selection.baseOffset,
            _selection.extentOffset - _selection.baseOffset);

        // Change text casing
        switch (attribute.key) {
          case Formats.lower:
            text = text.toLowerCase();
            break;
          case Formats.caps:
            text = Strings.capitalize(text, eachWord: true);
            break;
          case Formats.upper:
            text = text.toUpperCase();
            break;
        }

        // Replace selection with new text
        quillCtrl.replaceText(
            sel.baseOffset, sel.extentOffset - sel.baseOffset, text, sel);
        break;

      default:
        quillCtrl.formatSelection(attribute);
        break;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @action
  void setNoteColor(Color color) => note = note.copyWith(colorHex: color.value);

  //endregion

  // region Private vars

  String Function()? _onTitleChanged;
  String Function()? _onContentChanged;

  // endregion

  // region Private methods

  String _getTextFrom({required String separator}) {
    // Find the closest newline at both ends of the cursor
    final base = _selection.baseOffset;
    final extent = _selection.extentOffset;
    var lineStart = _plainContent.lastIndexOf(separator, base) + 1;
    var lineEnd = _plainContent.indexOf(separator, extent);
    if (lineStart == -1) lineStart = base;
    if (lineEnd == -1) lineEnd = extent;

    // Expand selection to include the whole line
    return _plainContent.substring(lineStart, lineEnd);
  }

// endregion
}