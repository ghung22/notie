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

  static Future<bool> onBackPressed(BuildContext context, Note result) async {
    Themes.updateSystemUi(reason: 'EditorPage.onBackPressed');
    Navigator.of(context).pop(result);
    return true;
  }

  const EditorPage(this.note, {super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with WidgetsBindingObserver {
  final EditorStore _store = EditorStore();

  Note get _note => _store.note;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _store.setNote(widget.note);
    super.initState();
    Themes.updateSystemUi(
        surface: _store.note.color, reason: 'EditorPage.initState');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _store.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    Themes.updateSystemUi(
        surface: _store.note.color, reason: 'Brightness changed in EditorPage');
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => EditorPage.onBackPressed(context, _note),
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