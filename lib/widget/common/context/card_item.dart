import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:intl/intl.dart';
import 'package:notie/data/model/note.dart';
import 'package:notie/global/colors.dart';
import 'package:notie/global/dimens.dart';
import 'package:notie/global/styles.dart';
import 'package:notie/global/vars.dart';

import '../card.dart';
import '../text.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final bool? Function()? onTap;
  final bool? Function()? onLongPress;

  const NoteCard({
    Key? key,
    required this.note,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Note _note;

  final _aniSpeed = Vars.animationFast;
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: _selected ? 1 / 64 : 0,
      duration: _aniSpeed,
      child: AnimatedScale(
        scale: _selected ? .95 : 1,
        duration: _aniSpeed,
        child: Stack(
          children: [
            Builder(builder: (context) {
              final bg = _note.color ?? Theme.of(context).colorScheme.surface;
              final fg = ColorBuilder.onColor(bg);
              return CardItem(
                color: bg,
                onPressed: () {
                  final result = widget.onTap?.call();
                  if (result == null) return;
                  setState(() => _selected = result);
                },
                onLongPress: () {
                  final result = widget.onLongPress?.call();
                  if (result == null) return;
                  setState(() => _selected = result);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        _note.title,
                        style: Styles.header,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        minFontSize: Styles.header.fontSize! - 4,
                        maxFontSize: Styles.header.fontSize!,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: IgnorePointer(
                        ignoring: true,
                        child: QuillEditor(
                          // Basic params
                          controller: QuillController(
                            document: _note.content.isNotEmpty
                                ? Document.fromJson(jsonDecode(_note.content))
                                : Document(),
                            selection: const TextSelection.collapsed(offset: 0),
                          ),
                          readOnly: true,
                          scrollController: ScrollController(),
                          scrollable: true,
                          focusNode: FocusNode(canRequestFocus: false),
                          autoFocus: false,
                          expands: true,
                          padding: EdgeInsets.zero,

                          // Styles
                          customStyles: Styles.quillStylesFrom(background: bg),
                          embedBuilders: FlutterQuillEmbeds.builders(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        DateFormat.MMMMd().add_y().format(_note.updatedAt),
                        style:
                            Styles.footer.copyWith(color: fg.withOpacity(.5)),
                        textAlign: TextAlign.center,
                        minFontSize: Styles.footer.fontSize!,
                        maxFontSize: Styles.footer.fontSize!,
                        overflowReplacement: Txt.footer(
                            text: DateFormat.yMd().format(_note.updatedAt)),
                      ),
                    ),
                  ],
                ),
              );
            }),
            IgnorePointer(
              ignoring: true,
              child: SizedBox.expand(
                child: AnimatedOpacity(
                  opacity: _selected ? 1 : 0,
                  duration: _aniSpeed,
                  child: Card(
                    color: Colors.black.withOpacity(.1),
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: Dimens.btnIconMinSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}