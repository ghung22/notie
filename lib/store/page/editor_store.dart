import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/model/note.dart';

part 'editor_store.g.dart';

class EditorStore = _EditorStore with _$EditorStore;

abstract class _EditorStore with Store {
  @observable
  Note note = const Note();

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

  /// Expand selection to be surrounded by a separator
  @action
  void expandSelection({Pattern separator = '\n'}) {
    // Get whole document text
    final sel = quillCtrl.selection;
    final fullText = quillCtrl.document.toPlainText();

    // Find the closest newline at both ends of the selection
    final base = sel.baseOffset;
    final extent = sel.extentOffset;
    var lineStart = fullText.lastIndexOf(separator, base) + 1;
    var lineEnd = fullText.indexOf(separator, extent);
    if (lineStart == -1) lineStart = base;
    if (lineEnd == -1) lineEnd = extent;

    // Expand selection to include the whole line
    quillCtrl.updateSelection(
      sel.copyWith(baseOffset: lineStart, extentOffset: lineEnd),
      ChangeSource.LOCAL,
    );
    contentFocus.unfocus();
  }

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
}