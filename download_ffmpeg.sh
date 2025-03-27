#!/bin/bash

# Set target directory
TARGET_DIR="./assets/ffmpeg"
mkdir -p "$TARGET_DIR"

# Download FFmpeg for macOS
echo "Downloading FFmpeg for macOS..."
curl -L -o ffmpeg-macos.zip https://evermeet.cx/ffmpeg/ffmpeg-7.1.1.zip
unzip -o ffmpeg-macos.zip -d "$TARGET_DIR"
chmod +x "$TARGET_DIR/ffmpeg"
rm ffmpeg-macos.zip

# Download FFmpeg for Linux
echo "Downloading FFmpeg for Linux..."
curl -L -o ffmpeg-linux.tar.xz https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf ffmpeg-linux.tar.xz --strip-components=1 -C "$TARGET_DIR" --wildcards '*/ffmpeg'
chmod +x "$TARGET_DIR/ffmpeg_linux"
rm ffmpeg-linux.tar.xz

# Download FFmpeg for Windows
echo "Downloading FFmpeg for Windows..."
curl -L -o ffmpeg-win.zip https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
unzip -o ffmpeg-win.zip -d "$TARGET_DIR"
mv "$TARGET_DIR"/*/bin/ffmpeg.exe "$TARGET_DIR/"
chmod +x "$TARGET_DIR/ffmpeg.exe"
rm -rf "$TARGET_DIR"/*
rm ffmpeg-win.zip

echo "FFmpeg download completed. Binaries are in $TARGET_DIR."