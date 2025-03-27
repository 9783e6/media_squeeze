import 'dart:io';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class DragOutWidget extends StatelessWidget {
  final File file;

  DragOutWidget({required this.file});

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (request) async {
        final item = DragItem();

        item.add(Formats.fileUri(file.uri));

        return item;
      },
      allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(
        child: Icon(Icons.open_in_new_rounded, size: 150),
      ),
    );
  }
}
