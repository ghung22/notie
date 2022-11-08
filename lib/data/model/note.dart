import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:json_annotation/json_annotation.dart';

import 'folder.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  String title;
  String content;
  String path;
  int? colorHex;
  int createdTimestamp;
  int updatedTimestamp;
  int deletedTimestamp;

  // region core methods

  Note({
    this.title = '',
    this.content = '',
    this.path = FolderPaths.root,
    this.colorHex,
    this.createdTimestamp = 0,
    this.updatedTimestamp = 0,
    this.deletedTimestamp = 0,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Note copyWith({
    String? title,
    String? content,
    int? colorHex,
    int? createdTimestamp,
    int? updatedTimestamp,
    int? deletedTimestamp,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      colorHex: colorHex ?? this.colorHex,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
      updatedTimestamp: updatedTimestamp ?? this.updatedTimestamp,
      deletedTimestamp: deletedTimestamp ?? this.deletedTimestamp,
    );
  }

  @override
  String toString() => '${toJson()}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.title == title &&
        other.content == content &&
        other.colorHex == colorHex &&
        other.createdTimestamp == createdTimestamp;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        content.hashCode ^
        colorHex.hashCode ^
        createdTimestamp.hashCode;
  }

  // endregion

  // region getters

  Color? get color => colorHex == null ? null : Color(colorHex!);

  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdTimestamp);

  DateTime get updatedAt =>
      DateTime.fromMillisecondsSinceEpoch(updatedTimestamp);

  DateTime get deletedAt =>
      DateTime.fromMillisecondsSinceEpoch(deletedTimestamp);

// endregion

  bool get isEmpty => title.isEmpty && content.isEmpty;

  bool get isNotEmpty => !isEmpty;

  static Note get empty => _empty.copyWith();

  static final _empty = Note();

  bool get isBlank => this == _empty;
}

@JsonSerializable()
class Notes {
  final ObservableList<Note> _v;

  // region core methods

  Notes([List<Note>? notes])
      : _v = notes != null
            ? ObservableList<Note>.of(notes)
            : ObservableList<Note>();

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

  Map<String, dynamic> toJson() => _$NotesToJson(this);

  @override
  String toString() => '${toJson()}';

  int get length => _v.length;

  Note operator [](int index) => value[index];

  // endregion

  // region getters

  List<Note> get value {
    final val = List<Note>.from(_v);
    val.sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));
    return val;
  }

  List<Note> get byName => value..sort((a, b) => a.title.compareTo(b.title));

  List<Note> get byColor => value
    ..sort((a, b) {
      if (a.color == null || b.color == null) return 1;
      return a.colorHex!.compareTo(b.colorHex!);
    });

  List<Note> get byCreateTime => value;

  List<Note> get byUpdateTime =>
      value..sort((a, b) => b.updatedTimestamp.compareTo(a.updatedTimestamp));

  List<Note> get byDeleteTime =>
      value..sort((a, b) => b.deletedTimestamp.compareTo(a.deletedTimestamp));

  // endregion

  Note add(Note note) {
    // Ensure createdTimestamp is unique
    var created = DateTime.now().millisecondsSinceEpoch;
    if (_v.indexWhere((n) => n.createdTimestamp == created) != -1) created++;
    note = note.copyWith(createdTimestamp: created, updatedTimestamp: created);
    _v.add(note);
    return note;
  }

  void remove(Note note) => _v.remove(note);

  Note update(Note note) {
    final index =
        _v.indexWhere((n) => n.createdTimestamp == note.createdTimestamp);
    if (index != -1) {
      note = note.copyWith(
          updatedTimestamp: DateTime.now().millisecondsSinceEpoch);
      _v[index] = note;
    } else {
      note = add(note);
    }
    return note;
  }
}