import 'package:notie/data/model/note.dart';

import 'db.dart';

class NotesDb {
  static const String _table = Db.notesTable;

  static Notes? _notes;

  static Future<Notes> query() async {
    if (_notes != null) return _notes!;
    final db = await Db.db();
    final maps = await db.query(_table);
    _notes = Notes();
    for (final map in maps) {
      _notes!.add(Note.fromJson(map));
    }
    Db.close();
    return _notes!;
  }

  static Future<void> update(Notes notes) async {
    final db = await Db.db();
    _notes ??= Notes();
    final ns = notes.value;
    final os = _notes!.value;
    for (final n in ns) {
      final o = os.firstWhere(
        (o) => o.createdTimestamp == n.createdTimestamp,
        orElse: () => Note.empty,
      );

      // Note not exist -> new note
      if (o.isBlank) {
        await db.insert(_table, n.toJson());
        break;
      }

      // Note exist -> update note
      if (o != n) {
        await db.update(
          _table,
          n.toJson(),
          where: 'createdTimestamp = ?',
          whereArgs: [n.createdTimestamp],
        );
        break;
      }
    }
    Db.close();
    _notes = notes;
  }
}