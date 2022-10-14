import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/model/note.dart';

part 'editor_store.g.dart';

class EditorStore = _EditorStore with _$EditorStore;

abstract class _EditorStore with Store {
  // region observable
  @observable
  Note note = const Note();

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

  // Editor actions

  @action
  void setNote(Note note) {
    this.note = note;
    titleCtrl.text = note.title;
    quillCtrl = QuillController(
      document: Document.fromJson(jsonDecode(note.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    quillCtrl.moveCursorToEnd();
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
  bool hasStyle(Attribute attribute) => quillCtrl
      .getAllSelectionStyles()
      .map((e) => e.containsKey(attribute.key))
      .contains(true);

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
    final sel = quillCtrl.selection;
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

  //endregion
}