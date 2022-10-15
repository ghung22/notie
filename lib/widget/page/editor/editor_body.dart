import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/store/page/editor_store.dart';
import 'package:notie/widget/common/text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EditorBody extends StatefulWidget {
  const EditorBody({Key? key}) : super(key: key);

  @override
  State<EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends State<EditorBody> {
  EditorStore? _store;

  Note get _note => _store?.note ?? const Note();

  Future<LinkMenuAction> linkMenuAction(String link) async {
    link = '${link.split('/').first}/...';
    final overlay = Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu<LinkMenuAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_store!.tapPosition.dx, _store!.tapPosition.dy, 0, 0),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      shape: Borders.card,
      items: [
        PopupMenuItem(
          value: LinkMenuAction.launch,
          child: Txt(text: AppLocalizations.of(context)!.open_link(link)),
        ),
        PopupMenuItem(
          value: LinkMenuAction.copy,
          child: Txt(text: AppLocalizations.of(context)!.copy_link),
        ),
        PopupMenuItem(
          value: LinkMenuAction.remove,
          child: Txt(text: AppLocalizations.of(context)!.remove_link),
        ),
      ],
    );
    return result ?? LinkMenuAction.none;
  }

  @override
  Widget build(BuildContext context) {
    _store ??= context.read<EditorStore>();
    return Observer(builder: (_) {
      return GestureDetector(
        onTapDown: (details) => _store!.setTapPosition(details.globalPosition),
        child: QuillEditor(
          // Basic params
          controller: _store!.quillCtrl,
          focusNode: _store!.contentFocus,
          scrollController: _store!.scrollCtrl,
          scrollable: true,
          padding: Pads.all(Dimens.editorPadding),
          autoFocus: _note.isNotEmpty,
          readOnly: _store!.readOnly,
          expands: true,

          // Events
          linkActionPickerDelegate: (_, link, __) => linkMenuAction(link),
          onLaunchUrl: (link) => launchUrl(Uri.https('', link),
              mode: LaunchMode.externalApplication),
        ),
      );
    });
  }
}