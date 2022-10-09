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

  @action
  void expandSelection() {
    // Get whole document text * selected text
    final sel = quillCtrl.selection;
    final fullText = quillCtrl.document.toPlainText();
    final selText = quillCtrl.getPlainText();

    // Find the closest newline at both ends of the selection
    final selStart = fullText.indexOf(selText);
    final selEnd = selStart + selText.length;
    var lineStart = fullText.lastIndexOf('\n', selStart) + 1;
    var lineEnd = fullText.indexOf('\n', selEnd);
    if (lineStart == -1) lineStart = selStart;
    if (lineEnd == -1) lineEnd = selEnd;

    // Expand selection to include the whole line
    quillCtrl.updateSelection(
      sel.copyWith(baseOffset: lineStart, extentOffset: lineEnd),
      ChangeSource.LOCAL,
    );
    contentFocus.unfocus();
  }
}