// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Folder _$FolderFromJson(Map<String, dynamic> json) => Folder(
      path: json['path'] as String? ?? FolderPaths.root,
      colorHex: json['colorHex'] as int? ?? BwColors.lightHex,
      createdTimestamp: json['createdTimestamp'] as int? ?? 0,
      updatedTimestamp: json['updatedTimestamp'] as int? ?? 0,
      deletedTimestamp: json['deletedTimestamp'] as int? ?? 0,
    );

Map<String, dynamic> _$FolderToJson(Folder instance) => <String, dynamic>{
      'path': instance.path,
      'colorHex': instance.colorHex,
      'createdTimestamp': instance.createdTimestamp,
      'updatedTimestamp': instance.updatedTimestamp,
      'deletedTimestamp': instance.deletedTimestamp,
    };

Folders _$FoldersFromJson(Map<String, dynamic> json) => Folders();

Map<String, dynamic> _$FoldersToJson(Folders instance) => <String, dynamic>{};
