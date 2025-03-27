import 'package:flutter/material.dart';
import '../widgets/file_chooser_widget.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      // Column(
      //   children: [
      //     Text("Compressing app"),
      //     Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              child: FileChooserWidget(),
            ),
          )
    );
    //     ],
    //   ),
    // );
  }
}