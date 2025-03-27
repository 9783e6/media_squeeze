import 'package:flutter/material.dart';
import 'dart:io';
import '../main.dart';
import 'package:provider/provider.dart';

class CompressionScreen extends StatefulWidget {
  final File? file;

  const CompressionScreen({super.key, required this.file});

  @override
  State<CompressionScreen> createState() => _CompressionScreenState();
}

class _CompressionScreenState extends State<CompressionScreen> {
  // String? selectedSize = '<=10MB';
  final TextEditingController sizeController = TextEditingController(text: "10");

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var colorScheme = Theme.of(context).colorScheme;
    var theme = Theme.of(context);
    final titleTextStyle = theme.textTheme.titleMedium!.copyWith(
      color: colorScheme.onSurface,
    );

    // List<String> sizeOptions = [
    //   '<=10MB',
    //   '<=25MB',
    //   '<=50MB',
    //   '<=100MB',
    //   '<=250MB',
    //   '<=500MB',
    // ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Compression settings', style: titleTextStyle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.file != null) ...[
              Text('Selected file: ${widget.file!.path}', style: titleTextStyle, textAlign: TextAlign.center,),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text("<=", style: TextStyle(fontSize: 16)), 
                  SizedBox(width: 8), 
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: sizeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Size (MB)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 8), 
                  Text("MB", style: TextStyle(fontSize: 16)), 
                ],
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: () {
                  final int? desiredSize = int.tryParse(sizeController.text);
                  if (desiredSize != null) {
                    appState.compressFile(context, widget.file, desiredSize-1); // Pass the user-selected size
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a valid size in MB")),
                    );
                  }
                }, 
                icon: Icon(Icons.rocket_launch),
                label: Text("Compress with recommended settings")
              ),
              TextButton(onPressed: () => print("test1"), child: Text("Adjust...")) // TODO
            ] else ...[
              Text('No file selected???'),
            ]
          ],
        ),
      )
    );
  }   
}
