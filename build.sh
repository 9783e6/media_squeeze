#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 [windows|macos|linux]"
  exit 1
fi

PLATFORM=$1
PUBSPEC="pubspec.yaml"
BACKUP_PUBSPEC="${PUBSPEC}.backup"

cp "$PUBSPEC" "$BACKUP_PUBSPEC"

get_os_type() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys"* ]]; then
      echo "windows"
    else
        echo "unsupported"
    fi
}

comment_line() {
    local file="$PUBSPEC"
    local line_number="$1"
    local os_type=$(get_os_type)

    if [[ "$os_type" == "macos" ]]; then
        sed -i '' "${line_number}s/^/#/" "$file"
    elif [[ "$os_type" == "linux" || "$os_type" == "windows" ]]; then
        sed -i "${line_number}s/^/#/" "$file"
    else
        echo "Unsupported platform for sed operation"
        exit 1
    fi
}

modify_pubspec() {
  echo "Modifying $PUBSPEC for platform: $PLATFORM"

  case "$PLATFORM" in
    windows)
      comment_line 39
      comment_line 40
      ;;
    macos)
      comment_line 38
      comment_line 40
      ;;
    linux)
      comment_line 38
      comment_line 39
      ;;
    *)
      echo "Unsupported platform: $PLATFORM"
      mv "$BACKUP_PUBSPEC" "$PUBSPEC"
      exit 1
      ;;
  esac

  echo "Updated $PUBSPEC successfully!"
}

modify_pubspec

echo "Running Flutter build for $PLATFORM..."
flutter build "$PLATFORM" --release

echo "Restoring original $PUBSPEC..."
mv "$BACKUP_PUBSPEC" "$PUBSPEC"

echo "Build for $PLATFORM completed successfully!"
