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

  late final _$readOnlyAtom =
      Atom(name: '_EditorStore.readOnly', context: context);

  @override
  bool get readOnly {
    _$readOnlyAtom.reportRead();
    return super.readOnly;
  }

  @override
  set readOnly(bool value) {
    _$readOnlyAtom.reportWrite(value, super.readOnly, () {
      super.readOnly = value;
    });
  }

  late final _$tapPositionAtom =
      Atom(name: '_EditorStore.tapPosition', context: context);

  @override
  Offset get tapPosition {
    _$tapPositionAtom.reportRead();
    return super.tapPosition;
  }

  @override
  set tapPosition(Offset value) {
    _$tapPositionAtom.reportWrite(value, super.tapPosition, () {
      super.tapPosition = value;
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
  void setReadOnly(bool readOnly) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.setReadOnly');
    try {
      return super.setReadOnly(readOnly);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleReadOnly() {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.toggleReadOnly');
    try {
      return super.toggleReadOnly();
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTapPosition(Offset tapPosition) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.setTapPosition');
    try {
      return super.setTapPosition(tapPosition);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool hasStyle(Attribute<dynamic> attribute, [dynamic value]) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.hasStyle');
    try {
      return super.hasStyle(attribute, value);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic getValue(Attribute<dynamic> attribute) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.getValue');
    try {
      return super.getValue(attribute);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool expandStyle(Attribute<dynamic> attribute) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.expandStyle');
    try {
      return super.expandStyle(attribute);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void expandSelection({Pattern separator = '\n'}) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.expandSelection');
    try {
      return super.expandSelection(separator: separator);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addContent(String data, Attribute<dynamic> attribute,
      {bool selectionCollapsed = false, String separator = '\n'}) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.addContent');
    try {
      return super.addContent(data, attribute,
          selectionCollapsed: selectionCollapsed, separator: separator);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void formatSelection(Attribute<dynamic> attribute) {
    final _$actionInfo = _$_EditorStoreActionController.startAction(
        name: '_EditorStore.formatSelection');
    try {
      return super.formatSelection(attribute);
    } finally {
      _$_EditorStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
note: ${note},
readOnly: ${readOnly},
tapPosition: ${tapPosition},
titleCtrl: ${titleCtrl},
quillCtrl: ${quillCtrl},
scrollCtrl: ${scrollCtrl},
titleFocus: ${titleFocus},
contentFocus: ${contentFocus}
    ''';
  }
}
