import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/widget/common/button.dart';
import 'package:notie/widget/common/container.dart';

class EditorPage extends StatefulWidget {
  final Note note;

  const EditorPage(this.note, {super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  PreferredSizeWidget _app = AppBar();
  Widget _body = const Nothing();
  Widget _tool = const Nothing();

  Note _note = Note();

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  void _initApp() {
    _app = AppBar(
      title: TextField(
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

  void _initBody() {
    _body = const Nothing();
  }

  void _initToolbar() {
    _tool = BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.add_content,
            onPressed: () {},
            child: const Icon(Icons.add_box_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.text_format,
            onPressed: () {},
            child: const Icon(Icons.text_format_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.text_color,
            onPressed: () {},
            child: const Icon(Icons.format_color_text_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.background_color,
            onPressed: () {},
            child: const Icon(Icons.format_color_fill_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.undo,
            onPressed: () {},
            child: const Icon(Icons.undo_rounded),
          ),
          IconBtn(
            tooltipText: AppLocalizations.of(context)!.redo,
            onPressed: () {},
            child: const Icon(Icons.redo_rounded),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initApp();
    _initBody();
    _initToolbar();

    return Scaffold(
      appBar: _app,
      body: SafeArea(child: _body),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: _tool,
      ),
    );
  }
}