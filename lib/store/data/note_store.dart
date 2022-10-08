import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:notie/data/model/folder.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/debug.dart';

part 'note_store.g.dart';

class NoteStore = _NoteStore with _$NoteStore;

abstract class _NoteStore with Store {
  @observable
  RootFolder rootFolder = const RootFolder();

  // TODO: Get notes from SQLite
  @action
  Future<void> getNotes() async {
    rootFolder = RootFolder(
      colorHex: BwColors.lightHex,
      notes: const Notes([
        Note(
          title: 'Note 1',
          content: 'Content 1',
          colorHex: BgColors.whiteHex,
          createdTimestamp: 0,
          updatedTimestamp: 0,
          deletedTimestamp: 0,
        ),
        Note(
          title: 'Note 2',
          content: 'Content 2',
          colorHex: BgColors.whiteHex,
          createdTimestamp: 0,
          updatedTimestamp: 0,
          deletedTimestamp: 0,
        ),
        Note(
          title: 'Note 3',
          content: 'Content 3',
          colorHex: BgColors.whiteHex,
          createdTimestamp: 0,
          updatedTimestamp: 0,
          deletedTimestamp: 0,
        ),
      ]),
      createdTimestamp: DateTime.now().millisecondsSinceEpoch,
      updatedTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
    Debug.print(null, 'root: $rootFolder', minLevel: DiagnosticLevel.info);
  }

  @action
  Future<void> addNote(Note note, Folder folder) async {
    folder.notes.add(note);
    updateFolder(folder);
  }

  @action
  Future<void> updateNote(Note note, Folder folder) async {
    folder.notes.update(note);
    updateFolder(folder);
  }

  @action
  Future<void> addFolder(Folder folder, Folder parent) async {
    parent.folders.add(folder);
    updateFolder(parent);
  }

  @action
  Future<void> updateFolder(Folder folder) async {
    // When path is root
    final path = folder.path;
    if (path == FolderPaths.root) {
      rootFolder = RootFolder.fromFolder(folder);
      return;
    }

    // Recursively find & update folder
    // How: Continuously update from the last of folder list upto the first
    final branch = rootFolder.getFolderBranch(path);
    if (branch.isEmpty) {
      Debug.print(null, 'Failed to update folder: cannot find $path',
          minLevel: DiagnosticLevel.error);
      return;
    }
    while(branch.length > 1) {
      final f = branch.removeLast();
      branch.last.folders.update(f);
    }
    rootFolder = RootFolder.fromFolder(branch.last);
    // TODO: Write changes to SQLite
  }
}