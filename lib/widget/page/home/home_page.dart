import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/debug.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/routes.dart';
import 'package:notie/global/vars.dart';
import 'package:notie/store/data/note_store.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/container.dart';
import 'package:notie/widget/common/context/card_item.dart';
import 'package:notie/widget/common/text.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _app = const Nothing();
  Widget _body = const Nothing();
  Widget _drawer = const Nothing();
  Widget _fab = const Nothing();
  PreferredSizeWidget _tool = AppBar();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  NoteStore? _noteStore;

  void _initApp() {
    _app = BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: Dimens.bottomAppBarNotchMargin,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.navigation,
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            child: const Icon(Icons.menu),
          ),
          IconBtn(
            onPressed: () {},
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  void _initBody() {
    _noteStore ??= context.read<NoteStore>();
    _body = FutureBuilder(
      future: _noteStore!.getNotes(),
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
                    onTap: () => openEditor(note),
                    onLongPress: () {},
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }

  void _initDrawer() {
    _drawer = Drawer(
      child: Padding(
        padding: Pads.all(Dimens.drawerPadding),
        child: CardItem(
          child: Observer(builder: (_) {
            return ListView(
              children: [
                Stack(
                  children: [
                    const DrawerHeader(
                      child: Nothing(),
                    ),
                    Padding(
                      padding: Pads.vert(Dimens.drawerItemPadding),
                      child: const Nothing(),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _initFab() {
    _fab = FloatingActionButton(
      onPressed: () => openEditor(),
      tooltip: AppLocalizations.of(context)!.add_note,
      child: const Icon(Icons.add),
    );
  }

  void _initToolbar() {
    _tool = AppBar(
      title: Txt.header(text: Vars.appName),
      actions: [
        IconBtn(
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ],
    );
  }

  Future<void> openEditor([Note? note]) async {
    Note? result =
        await Navigator.pushNamed(context, Routes.editor, arguments: note);
    if (result == null) return;
    if (result == Note.empty) return;
    if (result == note) return;
    _noteStore!.insertNote(result);
  }

  @override
  Widget build(BuildContext context) {
    _initApp();
    _initBody();
    _initDrawer();
    _initFab();
    _initToolbar();

    return Scaffold(
      key: _scaffoldKey,
      appBar: _tool,
      body: SafeArea(child: _body),
      bottomNavigationBar: _app,
      drawer: _drawer,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _fab,
    );
  }
}