import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/store/data/note_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:provider/provider.dart';

class EditorAppbar extends StatefulWidget {
  final Note note;

  const EditorAppbar({Key? key, required this.note}) : super(key: key);

  @override
  State<EditorAppbar> createState() => _EditorAppbarState();
}

class _EditorAppbarState extends State<EditorAppbar> {
  Note _note = const Note();
  NoteStore? _noteStore;
  final TextEditingController _txtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _txtCtrl.text = _note.title;
  }

  @override
  Widget build(BuildContext context) {
    _noteStore ??= context.read<NoteStore>();
    return AppBar(
      title: TextField(
        controller: _txtCtrl,
        autofocus: _note.isEmpty,
        maxLines: 1,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.title,
          border: InputBorder.none,
        ),
      ),
      actions: [
        IconBtn(
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ],
    );
  }
}