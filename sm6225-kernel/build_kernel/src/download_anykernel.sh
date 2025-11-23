#!/bin/bash

CONFIG="./src/config.json"
ANYKERNEL_DIR=$(jq -r '.anykernel.dir' "$CONFIG")
ANYKERNEL_URL=$(jq -r '.anykernel.url' "$CONFIG")
ANYKERNEL_ARCHIVE=$(jq -r '.anykernel.anykernel_file_name' "$CONFIG")
KERNEL_DIR=$(jq -r '.kernel.dir' "$CONFIG")

download_ak3() {
    if [ -d "$ANYKERNEL_DIR" ]; then
        echo "✅ Folder '$ANYKERNEL_DIR' already exists"
    else
        echo "📁 Creating folder '$ANYKERNEL_DIR' and downloading..."
        wget -O "$ANYKERNEL_ARCHIVE" "$ANYKERNEL_URL"
        if [ $? -eq 0 ]; then
            unzip -q "$ANYKERNEL_ARCHIVE" -d "./$KERNEL_DIR/"
            mv "./$KERNEL_DIR/AnyKernel3-master" "./$KERNEL_DIR/AnyKernel3"
            echo "✅ $ANYKERNEL_ARCHIVE extracted in ./"
            rm "$ANYKERNEL_ARCHIVE"
        else
            echo "❌ Error at downloading $ANYKERNEL_ARCHIVE."
        fi
    fi
}

download_ak3