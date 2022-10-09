import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:provider/provider.dart';

class EditorBody extends StatefulWidget {
  const EditorBody({Key? key}) : super(key: key);

  @override
  State<EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<EditorBody> {
  EditorStore? _store;

  Note get _note => _store?.note ?? const Note();

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (_) {
      return QuillEditor(
        controller: _store!.quillCtrl,
        focusNode: _store!.contentFocus,
        scrollController: _store!.scrollCtrl,
        scrollable: true,
        padding: Pads.all(Dimens.editorPadding),
        autoFocus: _note.isNotEmpty,
        readOnly: false,
        expands: true,
      );
    });
  }
}