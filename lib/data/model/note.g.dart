// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      colorHex: json['colorHex'] as int? ?? BgColors.whiteHex,
      createdTimestamp: json['createdTimestamp'] as int? ?? 0,
      updatedTimestamp: json['updatedTimestamp'] as int? ?? 0,
      deletedTimestamp: json['deletedTimestamp'] as int? ?? 0,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'colorHex': instance.colorHex,
      'createdTimestamp': instance.createdTimestamp,
      'updatedTimestamp': instance.updatedTimestamp,
      'deletedTimestamp': instance.deletedTimestamp,
    };

Notes _$NotesFromJson(Map<String, dynamic> json) => Notes();

Map<String, dynamic> _$NotesToJson(Notes instance) => <String, dynamic>{};
