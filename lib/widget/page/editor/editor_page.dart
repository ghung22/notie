import 'package:flutter/material.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/routes.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/container.dart';
import 'package:provider/provider.dart';

import 'editor_appbar.dart';
import 'editor_body.dart';
import 'editor_toolbar.dart';

class EditorPage extends StatefulWidget {
  final Note note;

  static Future<bool> onBackPressed(BuildContext context) async {
    Themes.updateSystemUi();
    Navigator.of(context).pop();
    return true;
  }

  const EditorPage(this.note, {super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final EditorStore _store = EditorStore();

  Note get _note => _store.note;

  @override
  void initState() {
    super.initState();
    _store.setNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => EditorPage.onBackPressed(context),
      child: Provider(
        create: (_) => _store,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: '${Routes.editor}?id=${_note.createdTimestamp}',
              child:
                  const Opacity(opacity: 0, child: CardItem(child: Nothing())),
            ),
            Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: EditorAppbar(),
              ),
              body: const SafeArea(child: EditorBody()),
              bottomNavigationBar: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: const EditorToolbar(),
              ),
              resizeToAvoidBottomInset: true,
            ),
          ],
        ),
      ),
    );
  }
}