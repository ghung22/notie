import 'package:flutter/material.dart';
import 'package:notie/data/model/note.dart';

import '../card.dart';
import '../text.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    Key? key,
    required this.note,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardItem(
      onPressed: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt.header(text: note.title),
          const SizedBox(height: 8),
          Text(note.content),
        ],
      ),
    );
  }
}