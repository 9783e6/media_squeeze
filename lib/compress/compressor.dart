import 'dart:io';
import 'ffmpeg.dart';


const videoFileTypes = [
  "mp4", "mkv", "avi", "mov", "flv", "mts", "ts", "webm", "ogv", "3gp", "mpg", "mpeg",
  "dv", "wmv", "mxf", "rm", "rmvb", "divx", "gxf", "asf", "vob", "amv", "f4v", "swf",
  "m2ts", "nsv"
];

const imageFileTypes = [];



Future<File?> compress(File file, int targetSizeMB) async {
  String fileType = file.path.split(".").last;
  if (videoFileTypes.contains(fileType)) {
    print("video file type");
    File? outputFile = await compressVideoToTargetSize(file, targetSizeMB);
    return outputFile;
  } else if (imageFileTypes.contains(fileType)) {
    print("image file type");
    return null;
  } else {
    print("Format is not supported");
    return null;
  }
}

