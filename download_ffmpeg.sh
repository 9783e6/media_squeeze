#!/bin/bash

set -e
set -u

TARGET_DIR="./assets/ffmpeg"
TEMP_DIR="ffmpeg_temp"
mkdir -p "$TARGET_DIR"
mkdir -p "$TEMP_DIR"

echo "Downloading FFmpeg for macOS..."
curl -L -o "$TEMP_DIR/ffmpeg-macos.zip" https://evermeet.cx/ffmpeg/ffmpeg-7.1.1.zip
unzip -o "$TEMP_DIR/ffmpeg-macos.zip" -d "$TEMP_DIR"
mv "$TEMP_DIR/ffmpeg" "$TARGET_DIR/ffmpeg_mac"
chmod +x "$TARGET_DIR/ffmpeg_mac"
rm -rf "$TEMP_DIR/*"

echo "Downloading FFmpeg for Linux..."
curl -L -o "$TEMP_DIR/ffmpeg-linux.tar.xz" https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xf "$TEMP_DIR/ffmpeg-linux.tar.xz" --strip-components=1 -C "$TEMP_DIR" --wildcards '*/ffmpeg'
mv "$TEMP_DIR/ffmpeg" "$TARGET_DIR/ffmpeg_lin"
chmod +x "$TARGET_DIR/ffmpeg_lin"
rm -rf "$TEMP_DIR/*"

echo "Downloading FFmpeg for Windows..."
curl -L -o "$TEMP_DIR/ffmpeg-win.zip" https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip
unzip -o "$TEMP_DIR/ffmpeg-win.zip" -d "$TEMP_DIR"
mv "$TEMP_DIR"/*/bin/ffmpeg.exe "$TARGET_DIR/ffmpeg_win.exe"
chmod +x "$TARGET_DIR/ffmpeg_win.exe"
rm -rf "$TEMP_DIR"/*

echo "FFmpeg download completed. Binaries are in $TARGET_DIR."