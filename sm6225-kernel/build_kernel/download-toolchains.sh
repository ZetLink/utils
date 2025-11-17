#!/bin/bash

CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r536225.tar.gz"              # AOSP Clang19
GCC64_URL="https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9/archive/refs/heads/lineage-19.1.zip"  # GCC aarch64 4.9
GCC32_URL="https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9/archive/refs/heads/lineage-19.1.zip"      # GCC arm 4.9

CLANG_ARCHIVE="clang-r536225.tar.gz"
GCC64_ARCHIVE="lineage-19.1.zip"
GCC32_ARCHIVE="lineage-19.1.zip"

# Función para verificar y extraer .tar.gz
procesar_clang() {
    if [ -d "clang" ]; then
        echo "✅ La carpeta 'clang' ya existe."
    else
        echo "📁 Creando carpeta 'clang' y descargando..."
        mkdir -p clang
        wget -O "$CLANG_ARCHIVE" "$CLANG_URL"
        if [ $? -eq 0 ]; then
            tar -xzf "$CLANG_ARCHIVE" -C clang
            echo "✅ clang.tar.gz extraído en ./clang"
            rm "$CLANG_ARCHIVE"
        else
            echo "❌ Error al descargar clang."
        fi
    fi
}

# Función para verificar y extraer .zip
procesar_zip() {
    CARPETA=$1
    URL=$2
    ARCHIVO=$3

    if [ -d "$CARPETA" ]; then
        echo "✅ La carpeta '$CARPETA' ya existe."
    else
        echo "📁 Creando carpeta '$CARPETA' y descargando..."
        mkdir -p "$CARPETA"
        wget -O "$ARCHIVO" "$URL"
        if [ $? -eq 0 ]; then
            unzip -q "$ARCHIVO" -d "$CARPETA"
            echo "✅ $ARCHIVO extraído en ./$CARPETA"
            rm "$ARCHIVO"
        else
            echo "❌ Error al descargar $ARCHIVO."
        fi
    fi
}

# Ejecutar funciones
procesar_clang
procesar_zip "gcc64" "$GCC64_URL" "$GCC64_ARCHIVE"
procesar_zip "gcc32" "$GCC32_URL" "$GCC32_ARCHIVE"
