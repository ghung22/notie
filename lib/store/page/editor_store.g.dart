// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditorStore on _EditorStore, Store {
  late final _$noteAtom = Atom(name: '_EditorStore.note', context: context);

  @override
  Note get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(Note value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  late final _$titleCtrlAtom =
      Atom(name: '_EditorStore.titleCtrl', context: context);

  @override
  TextEditingController get titleCtrl {
    _$titleCtrlAtom.reportRead();
    return super.titleCtrl;
  }

  @override
  set titleCtrl(TextEditingController value) {
    _$titleCtrlAtom.reportWrite(value, super.titleCtrl, () {
      super.titleCtrl = value;
    });
  }

  late final _$quillCtrlAtom =
      Atom(name: '_EditorStore.quillCtrl', context: context);

  @override
  QuillController get quillCtrl {
    _$quillCtrlAtom.reportRead();
    return super.quillCtrl;
  }

  @override
  set quillCtrl(QuillController value) {
    _$quillCtrlAtom.reportWrite(value, super.quillCtrl, () {
      super.quillCtrl = value;
    });
  }

  late final _$scrollCtrlAtom =
      Atom(name: '_EditorStore.scrollCtrl', context: context);

  @override
  ScrollController get scrollCtrl {
    _$scrollCtrlAtom.reportRead();
    return super.scrollCtrl;
  }

  @override
  set scrollCtrl(ScrollController value) {
    _$scrollCtrlAtom.reportWrite(value, super.scrollCtrl, () {
      super.scrollCtrl = value;
    });
  }

  late final _$titleFocusAtom =
      Atom(name: '_EditorStore.titleFocus', context: context);

  @override
  FocusNode get titleFocus {
    _$titleFocusAtom.reportRead();
    return super.titleFocus;
  }

  @override
  set titleFocus(FocusNode value) {
    _$titleFocusAtom.reportWrite(value, super.titleFocus, () {
      super.titleFocus = value;
    });
  }

  late final _$contentFocusAtom =
      Atom(name: '_EditorStore.contentFocus', context: context);

  @override
  FocusNode get contentFocus {
    _$contentFocusAtom.reportRead();
    return super.contentFocus;
  }

  @override
  set contentFocus(FocusNode value) {
    _$contentFocusAtom.reportWrite(value, super.contentFocus, () {
      super.contentFocus = value;
    });
  }

  late final _$_EditorStoreActionController =
      ActionController(name: '_EditorStore', context: context);

  @override
  void setNote(Note note) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.setNote');
    try {
      return super.setNote(note);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void expandSelection() {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.expandSelection');
    try {
      return super.expandSelection();
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
note: ${note},
titleCtrl: ${titleCtrl},
quillCtrl: ${quillCtrl},
scrollCtrl: ${scrollCtrl},
titleFocus: ${titleFocus},
contentFocus: ${contentFocus}
    ''';
  }
}
