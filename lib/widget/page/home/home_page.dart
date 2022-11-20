import 'package:flutter/material.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/routes.dart';
import 'package:notie/store/data/note_store.dart';
import 'package:notie/store/page/home_store.dart';
import 'package:notie/widget/page/home/home_appbar.dart';
import 'package:provider/provider.dart';

import 'home_body.dart';
import 'home_drawer.dart';
import 'home_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Future<void> openEditor(
    BuildContext context,
    NoteStore noteStore, [
    Note? note,
  ]) async {
    Note? result =
        await Navigator.pushNamed(context, Routes.editor, arguments: note);
    if (result == null) return;
    if (result == Note.empty) return;
    if (result == note) return;
    noteStore.insertNote(result);
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final HomeStore _store = HomeStore();

  @override
  void initState() {
    _store.init();
    super.initState();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeStore>(create: (_) => _store),
        Provider<NoteStore>(create: (_) => NoteStore()),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        body: const SafeArea(child: HomeBody()),
        bottomNavigationBar: HomeAppbar(scaffoldKey: _scaffoldKey),
        drawer: const HomeDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const HomeFab(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}