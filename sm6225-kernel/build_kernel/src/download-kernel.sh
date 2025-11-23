#!/bin/bash

CONFIG="./src/config.json"
KERNEL_DIR=$(jq -r '.kernel.dir' "$CONFIG")
KERNEL_URL=$(jq -r '.kernel.url' "$CONFIG")
KERNEL_BRANCH=$(jq -r '.kernel.branch' "$CONFIG")

if [ -d "$KERNEL_DIR" ]; then
    echo "✅ The repository directory '$KERNEL_DIR' already exists. Skipping clone"
else
    echo "📁 Cloning repository from: $KERNEL_URL"
    git clone -b "$KERNEL_BRANCH" "$KERNEL_URL" "$KERNEL_DIR" || {
        echo "❌ Error at cloning the repository"
        exit 1
    }
fi