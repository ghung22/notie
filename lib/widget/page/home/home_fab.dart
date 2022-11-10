import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notie/store/data/note_store.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class HomeFab extends StatefulWidget {
  const HomeFab({Key? key}) : super(key: key);

  @override
  State<HomeFab> createState() => _HomeFabState();
}

class _HomeFabState extends State<HomeFab> {
  NoteStore? _noteStore;

  @override
  Widget build(BuildContext context) {
    _noteStore ??= context.read<NoteStore>();
    return FloatingActionButton(
      onPressed: () => HomePage.openEditor(context, _noteStore!),
      tooltip: AppLocalizations.of(context)!.add_note,
      child: const Icon(Icons.add),
    );
  }
}