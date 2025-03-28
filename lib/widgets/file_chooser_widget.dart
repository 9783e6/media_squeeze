import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'dart:io';

class FileChooserWidget extends StatefulWidget {
  @override
  _FileChooserWidgetState createState() => _FileChooserWidgetState();
}

class _FileChooserWidgetState extends State<FileChooserWidget> {
  bool isDragging = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    void _openFilePicker() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          appState.openCompressionMenu(
            context,
            File(result.files.single.path!),
          );
        });
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent, width: 2),
        ),
        child: DropRegion(
          formats: Formats.standardFormats,
          hitTestBehavior: HitTestBehavior.opaque,
          onDropOver: (event) {
            setState(() {
              isDragging = true;
            });
            return DropOperation.copy;
          },
          onDropEnter: (event) {
            setState(() {
              isDragging = true;
            });
          },
          onDropLeave: (event) {
            setState(() {
              isDragging = false;
            });
          },
          onPerformDrop: (event) async {
            setState(() {
              isDragging = false;
            });
            for (var item in event.session.items) {
              final reader = item.dataReader;
              if (await reader!.canProvide(Formats.fileUri)) {
                reader!.getValue<Uri>(
                  Formats.fileUri,
                  (Uri? fileUri) {
                    if (fileUri != null) {
                      final file = File.fromUri(fileUri);
                      setState(() {
                        appState.openCompressionMenu(context, file);
                      });
                    }
                  },
                  onError: (error) {
                    debugPrint("Error reading dropped file: $error");
                  },
                );
              }
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Drag & Drop or Pick a File',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _openFilePicker,
                      child: Text('Choose File'),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                ignoring: !isDragging, // Ignores interactions when not dragging
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: isDragging ? 1.0 : 0.0,
                  child: Container(
                    color: Colors.blue.shade900.withOpacity(0.4),
                  ),
                ),
              ),
              if (isDragging)
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.file_upload,
                    size: 50,
                    color: Colors.blue[200],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
