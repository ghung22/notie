import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/routes.dart';
import 'package:notie/store/data/note_store.dart';
import 'package:notie/store/page/home_store.dart';
import 'package:notie/widget/common/container.dart';
import 'package:notie/widget/common/context/card_item.dart';
import 'package:notie/widget/common/text.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<HomeBody> {
  HomeStore? _store;
  NoteStore? _noteStore;

  Future<void> getNotes() async {
    await _noteStore!.getNotes();
    _store!.updateNotes(_noteStore!.notes);
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<HomeStore>();
    _noteStore ??= context.read<NoteStore>();
    return FutureBuilder(
      future: getNotes(),
      builder: (_, snapshot) {
        return CaseContainer(
          cases: [
            Case(
              condition: snapshot.connectionState != ConnectionState.done,
              child: const Center(child: CircularProgressIndicator()),
            ),
            Case(
              condition: snapshot.hasError,
              child: Builder(builder: (_) {
                Debug.print(context, 'Error: ${snapshot.error}');
                if (Debug.isDebug) {
                  return Txt.error(text: snapshot.error.toString());
                }
                return const Nothing();
              }),
            ),
          ],
          child: Observer(builder: (context) {
            final notes = _noteStore!.notes;
            return GridView.builder(
              padding: Pads.all(Dimens.gridSpacing),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: Dimens.noteGridTileHeight,
                mainAxisSpacing: Dimens.gridSpacing,
                crossAxisSpacing: Dimens.gridSpacing,
              ),
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                return Hero(
                  tag: '${Routes.editor}?id=${note.createdTimestamp}',
                  child: NoteCard(
                    note: note,
                    onTap: () {
                      if (_store!.someSelected) {
                        return _store!.select(note);
                      }
                      HomePage.openEditor(context, _noteStore!, note);
                      return null;
                    },
                    onLongPress: () => _store!.select(note),
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}