import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:notie/global/colors.dart';

part 'folder.g.dart';

class FolderPaths {
  static const root = '/';
  static const trash = '/trash';
}

@JsonSerializable()
class Folder {
  final String path;
  final int colorHex;
  final int createdTimestamp;
  final int updatedTimestamp;
  final int deletedTimestamp;

  // region core methods
  const Folder({
    this.path = FolderPaths.root,
    this.colorHex = BwColors.lightHex,
    this.createdTimestamp = 0,
    this.updatedTimestamp = 0,
    this.deletedTimestamp = 0,
  });

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  Map<String, dynamic> toJson() => _$FolderToJson(this);

  Folder copyWith({
    String? path,
    int? colorHex,
    int? createdTimestamp,
    int? updatedTimestamp,
    int? deletedTimestamp,
  }) {
    return Folder(
      path: path ?? this.path,
      colorHex: colorHex ?? this.colorHex,
      createdTimestamp: createdTimestamp ?? this.createdTimestamp,
      updatedTimestamp: updatedTimestamp ?? this.updatedTimestamp,
      deletedTimestamp: deletedTimestamp ?? this.deletedTimestamp,
    );
  }

  @override
  String toString() => '${toJson()}';

  // endregion

  // region getters

  String get name => path.split('/').last;

  Color get color => Color(colorHex);

  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdTimestamp);

  DateTime get updatedAt =>
      DateTime.fromMillisecondsSinceEpoch(updatedTimestamp);

  DateTime get deletedAt =>
      DateTime.fromMillisecondsSinceEpoch(deletedTimestamp);

// endregion
}

@JsonSerializable()
class Folders {
  final List<Folder> _v;

  // region core methods
  const Folders([this._v = const []]);

  factory Folders.fromJson(Map<String, dynamic> json) =>
      _$FoldersFromJson(json);

  Map<String, dynamic> toJson() => _$FoldersToJson(this);

  Folders copyWith({List<Folder>? f, Folders? folders}) {
    if (folders != null) return Folders(folders._v);
    return Folders(f ?? _v);
  }

  @override
  String toString() => '${toJson()}';

  int get length => _v.length;

  Folder operator [](int index) => value[index];

  // endregion

  // region getters

  List<Folder> get value {
    final val = List<Folder>.from(_v);
    val.sort((a, b) => b.path.compareTo(a.path));
    return val;
  }

  List<Folder> get byColor =>
      value..sort((a, b) => a.colorHex.compareTo(b.colorHex));

  List<Folder> get byCreateTime =>
      value..sort((a, b) => b.createdTimestamp.compareTo(a.createdTimestamp));

  List<Folder> get byUpdateTime =>
      value..sort((a, b) => b.updatedTimestamp.compareTo(a.updatedTimestamp));

  List<Folder> get byDeleteTime =>
      value..sort((a, b) => b.deletedTimestamp.compareTo(a.deletedTimestamp));

  // endregion

  Folder get(String path) {
    return _v.firstWhere((f) => f.path == path, orElse: () => const Folder());
  }

  void add(Folder folder) => _v.add(folder);

  void remove(Folder folder) => _v.remove(folder);

  void update(Folder folder, [bool updateTimestamp = true]) {
    if (updateTimestamp) {
      folder.copyWith(updatedTimestamp: DateTime.now().millisecondsSinceEpoch);
    }
    final index = _v.indexWhere((f) => f.path == folder.path);
    if (index != -1) _v[index] = folder;
  }
}