import 'package:compressor/screens/main_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:super_clipboard/super_clipboard.dart';

import '../widgets/drag_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:process_run/stdio.dart';



class OutputScreen extends StatelessWidget {
  final File file;

  OutputScreen({Key? key, required this.file}) : super(key: key);

  Future<void> _saveFile(BuildContext context) async {
    String? filePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Export compressed file',
      fileName: file.path.split("\\").last.split("/").last,
    );

    if (filePath != null) {
      final savedFile = File(filePath);
      await savedFile.writeAsBytes(await file.readAsBytes());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File saved to $filePath')));
    }
  }

  Future<void> _writeToClipboard() async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      print("Clipboard not available");
      return;
    }
    final item = DataWriterItem();
    item.add(Formats.fileUri(file.uri));
    await clipboard.write([item]);
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    final titleTextStyle = theme.textTheme.titleMedium!.copyWith(
      color: colorScheme.onSurface,
    );

    

    return Scaffold(
      appBar: AppBar(
        title: Text('Output', style: titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            file.delete();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()), 
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                color: Theme.of(context).colorScheme.surfaceContainer,
                height: 200,
                width: 200,
                child: DragOutWidget(file: file),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _writeToClipboard(),
              icon: Icon(Icons.copy_rounded),
              label: Text("Copy to clipboard"),
            ),
            // SizedBox(height: 4),
            TextButton(
              onPressed: () => _saveFile(context),
              child: Text("Export as..."),
            )   
          ],
        ),
      ),
    );
  }
}