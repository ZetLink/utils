#!/bin/bash

CONFIG="./src/config.json"
CLANG_URL=$(jq -r '.toolchains.clang' "$CONFIG")
GCC64_URL=$(jq -r '.toolchains.gcc64' "$CONFIG")
GCC32_URL=$(jq -r '.toolchains.gcc32' "$CONFIG")

CLANG_ARCHIVE=$(jq -r '.toolchains.clang_file_name' "$CONFIG")
GCC64_ARCHIVE=$(jq -r '.toolchains.gcc64_file_name' "$CONFIG")
GCC32_ARCHIVE=$(jq -r '.toolchains.gcc32_file_name' "$CONFIG")

download_clang() {
    if [ -d "clang" ]; then
        echo "✅ 'Clang' folder already exists" 
    else
        echo "📁 Creating 'Clang' folder and downloading..." 
        mkdir -p clang
        wget -O "$CLANG_ARCHIVE" "$CLANG_URL"
        if [ $? -eq 0 ]; then
            tar -xzf "$CLANG_ARCHIVE" -C clang
            echo "✅ 'Clang' file extracted in ./clang"
            rm "$CLANG_ARCHIVE"
        else
            echo "❌ Error at downloading 'Clang'"
        fi
    fi
}

download_gcc() {
    FOLDER=$1
    URL=$2
    FILE=$3

    if [ -d "$FOLDER" ]; then
        echo "✅ Folder '$FOLDER' already exists"
    else
        echo "📁 Creating folder '$FOLDER' and downloading..."
        mkdir -p "$FOLDER"
        wget -O "$FILE" "$URL"
        if [ $? -eq 0 ]; then
            unzip -q "$FILE" -d "$FOLDER"
            echo "✅ $FILE extracted in ./$FOLDER"
            rm "$FILE"
        else
            echo "❌ Error at downloading $FILE."
        fi
    fi
}

# Ejecutar funciones
download_clang
download_gcc "gcc64" "$GCC64_URL" "$GCC64_ARCHIVE"
download_gcc "gcc32" "$GCC32_URL" "$GCC32_ARCHIVE"
