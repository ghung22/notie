import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/dimens.dart';

class EditorBody extends StatefulWidget {
  final Note note;
  final QuillController quillController;
  final ScrollController scrollController;

  const EditorBody({
    Key? key,
    required this.note,
    required this.quillController,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<EditorBody> {
  Note _note = const Note();
  late final QuillController _quillCtrl;
  late final ScrollController _scrollCtrl;
  final FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
    _quillCtrl = widget.quillController;
    _scrollCtrl = widget.scrollController;
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: _quillCtrl,
      focusNode: _contentFocus,
      scrollController: _scrollCtrl,
      scrollable: true,
      padding: Pads.all(Dimens.editorPadding),
      autoFocus: _note.isNotEmpty,
      readOnly: false,
      expands: true,
    );
  }
}