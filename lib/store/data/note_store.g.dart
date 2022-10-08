// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NoteStore on _NoteStore, Store {
  late final _$rootFolderAtom =
      Atom(name: '_NoteStore.rootFolder', context: context);

  @override
  Folder get rootFolder {
    _$rootFolderAtom.reportRead();
    return super.rootFolder;
  }

  @override
  set rootFolder(Folder value) {
    _$rootFolderAtom.reportWrite(value, super.rootFolder, () {
      super.rootFolder = value;
    });
  }

  late final _$addNoteAsyncAction =
      AsyncAction('_NoteStore.addNote', context: context);

  @override
  Future<void> addNote(Note note, Folder folder) {
    return _$addNoteAsyncAction.run(() => super.addNote(note, folder));
  }

  late final _$updateNoteAsyncAction =
      AsyncAction('_NoteStore.updateNote', context: context);

  @override
  Future<void> updateNote(Note note, Folder folder) {
    return _$updateNoteAsyncAction.run(() => super.updateNote(note, folder));
  }

  late final _$addFolderAsyncAction =
      AsyncAction('_NoteStore.addFolder', context: context);

  @override
  Future<void> addFolder(Folder folder, Folder parent) {
    return _$addFolderAsyncAction.run(() => super.addFolder(folder, parent));
  }

  late final _$updateFolderAsyncAction =
      AsyncAction('_NoteStore.updateFolder', context: context);

  @override
  Future<void> updateFolder(Folder folder) {
    return _$updateFolderAsyncAction.run(() => super.updateFolder(folder));
  }

  @override
  String toString() {
    return '''
rootFolder: ${rootFolder}
    ''';
  }
}
