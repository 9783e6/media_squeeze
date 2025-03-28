import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';

Future<File> _getFFmpegExecutable() async {
  final Directory appDir = await getApplicationSupportDirectory();

  late final String assetPath;
  late final String fileName;

  if (Platform.isWindows) {
    assetPath = 'assets/ffmpeg/ffmpeg_win.exe';
    fileName = 'ffmpeg_win.exe';
  } else if (Platform.isMacOS) {
    assetPath = 'assets/ffmpeg/ffmpeg_mac';
    fileName = 'ffmpeg_mac';
  } else if (Platform.isLinux) {
    assetPath = 'assets/ffmpeg/ffmpeg_lix';
    fileName = 'ffmpeg_lin';
  } else {
    throw UnsupportedError('This platform is not supported.');
  }

  final String destPath = '${appDir.path}/$fileName';
  final File executableFile = File(destPath);

  if (!await executableFile.exists()) {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    await executableFile.writeAsBytes(bytes, flush: true);

    if (Platform.isMacOS) {
      await Process.run('chmod', ['+x', destPath]);
    }
  }

  return executableFile;
}

Future<String> _runFFmpegCommand(String commandArguments) async {
  final ffmpegFile = await _getFFmpegExecutable();
  final ffmpegPath = ffmpegFile.path;

  var shell = Shell();

  try {
    var result = await shell.run('"$ffmpegPath" $commandArguments');
    return result.map((r) => r.outText).join("\n");
  } catch (e) {
    if (e is ShellException) {
      var output = e.result?.outText ?? "";
      var errorOutput = e.result?.errText ?? "";
      return "Output:\n$output\nError:\n$errorOutput";
    }

    return "Unknown Error: $e";
  }
}

Future<File?> compressVideoToTargetSize(File file, int targetSizeMB) async {
  final String inputPath = file.path;
  final Directory tempDir = await getTemporaryDirectory();
  final Directory appTempDir = Directory(tempDir.path + "/media_squeeze");
  print(appTempDir.path);

  if (!await appTempDir.exists()) {
    appTempDir.create(recursive: true);
    print("Made dir");
  }

  final String outputPath =
      appTempDir.path +
      "/" +
      inputPath
          .split("/")
          .last
          .split("\\")
          .last
          .replaceAll('.mp4', '_compressed.mp4');
  print(outputPath);

  int targetSizeBits = targetSizeMB * 8000000;
  double videoDuration = await getVideoDuration(inputPath);

  int bitrate = targetSizeBits ~/ videoDuration;

  await compressVideo(inputPath, outputPath, bitrate);

  File outputFile = File(outputPath);
  final bool check = await outputFile.exists();

  if (check == true) {
    return outputFile;
  } else {
    return null;
  }
}

Future<double> getVideoDuration(String filePath) async {
  final commandArguments = '-i "$filePath"';

  final output = await _runFFmpegCommand(commandArguments);

  final durationRegExp = RegExp(r'Duration: (\d{2}):(\d{2}):(\d{2})\.(\d{2})');
  final match = durationRegExp.firstMatch(output);

  if (match != null) {
    final hours = int.parse(match.group(1) ?? "0");
    final minutes = int.parse(match.group(2) ?? "0");
    final seconds = int.parse(match.group(3) ?? "0");
    final milliseconds = int.parse(match.group(4) ?? "0");

    double total_seconds =
        (hours * 3600) + (minutes * 60) + seconds + (milliseconds / 100);
    return total_seconds;
  } else {
    return 0;
  }
}

Future<void> compressVideo(
  String inputPath,
  String outputPath,
  int bitrate,
) async {
  final args =
      '-i "$inputPath"  -b:v ${bitrate} -b:a 128k -maxrate ${bitrate} -bufsize ${bitrate * 2} -c:v libx264 -c:a aac -preset fast -map 0:v -map 0:a -y "$outputPath"'; // -map 0:a
  await _runFFmpegCommand(args);
}
