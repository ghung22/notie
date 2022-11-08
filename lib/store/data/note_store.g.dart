// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NoteStore on _NoteStore, Store {
  late final _$notesAtom = Atom(name: '_NoteStore.notes', context: context);

  @override
  Notes get notes {
    _$notesAtom.reportRead();
    return super.notes;
  }

  @override
  set notes(Notes value) {
    _$notesAtom.reportWrite(value, super.notes, () {
      super.notes = value;
    });
  }

  late final _$getNotesAsyncAction =
      AsyncAction('_NoteStore.getNotes', context: context);

  @override
  Future<void> getNotes() {
    return _$getNotesAsyncAction.run(() => super.getNotes());
  }

  late final _$debugInitNotesAsyncAction =
      AsyncAction('_NoteStore.debugInitNotes', context: context);

  @override
  Future<void> debugInitNotes() {
    return _$debugInitNotesAsyncAction.run(() => super.debugInitNotes());
  }

  late final _$saveNotesAsyncAction =
      AsyncAction('_NoteStore.saveNotes', context: context);

  @override
  Future<void> saveNotes() {
    return _$saveNotesAsyncAction.run(() => super.saveNotes());
  }

  @override
  String toString() {
    return '''
notes: ${notes}
    ''';
  }
}
