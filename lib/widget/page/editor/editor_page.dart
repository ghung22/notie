import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/routes.dart';
import 'package:notie/widget/common/card.dart';
import 'package:notie/widget/common/container.dart';

import 'editor_appbar.dart';
import 'editor_body.dart';
import 'editor_toolbar.dart';

class EditorPage extends StatefulWidget {
  final Note note;

  const EditorPage(this.note, {super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Note get _note => widget.note;
  QuillController _quillCtrl = QuillController.basic();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _quillCtrl = QuillController(
      document: Document.fromJson(jsonDecode(_note.content)),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: '${Routes.editor}?id=${_note.createdTimestamp}',
          child: const Opacity(opacity: 0, child: CardItem(child: Nothing())),
        ),
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: EditorAppbar(note: _note),
          ),
          body: SafeArea(
            child: EditorBody(
              note: _note,
              quillController: _quillCtrl,
              scrollController: _scrollCtrl,
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: EditorToolbar(
              note: _note,
              quillController: _quillCtrl,
              scrollController: _scrollCtrl,
            ),
          ),
        ),
      ],
    );
  }
}