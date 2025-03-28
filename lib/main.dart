import 'dart:io';

import 'package:animations/animations.dart';
import 'screens/output_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_size/window_size.dart';
import 'package:flutter/material.dart';
import 'compress/compressor.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'screens/compression_screen.dart';

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 500;
const double windowHeight = 500;


void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Media Squeeze by 9783e6');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(
        Rect.fromCenter(
          center: screen!.frame.center,
          width: windowWidth,
          height: windowHeight,
        ),
      );
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Media Squeeze',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        ),
        home: MainScreen(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  
  Future<void> openCompressionMenu(BuildContext context, File? file) async {
    if (file != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => CompressionScreen(file: file),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              child: child,
            );
          },
        ),
      );
    }
  }

  void compressFile(BuildContext context, File? file, int targetFileSizeMB) async {
    if (file != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(), 
        ),
      );

      File? compressedFile = await compress(file, targetFileSizeMB);

      Navigator.pop(context);

      if (compressedFile != null) {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) => OutputScreen(file: compressedFile),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                child: child,
              );
            },
          ),
        );
      }
    }
  }

}
