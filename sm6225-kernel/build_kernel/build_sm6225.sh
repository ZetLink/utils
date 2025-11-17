#!/bin/bash

# === CONFIGURACIÓN ===

# Usuario de compilación
export KBUILD_BUILD_USER="ZetLink"

# Rutas de las herramientas de compilación
CLANG_PATH="$PWD/../clang/bin"
GCC64_PATH="$PWD/../gcc64/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9-lineage-19.1/bin"
GCC32_PATH="$PWD/../gcc32/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9-lineage-19.1/bin"

# Añadir al PATH
export PATH="$CLANG_PATH:$GCC64_PATH:$GCC32_PATH:$PATH"

# Configurar LLVM
export LLVM_DIR="$CLANG_PATH"
export LLVM=1

# Fecha
export TIME="$(date "+%Y%m%d")"

# Arquitectura
export ARCH=arm64

# Eliminar la carpeta out en caso de existir
rm -rf out

# === FLAGS DE COMPILACIÓN ===

ARGS='
CC=clang
LD=ld.lld
ARCH=arm64
AR=llvm-ar
NM=llvm-nm
AS=llvm-as
OBJCOPY=llvm-objcopy
OBJDUMP=llvm-objdump
READELF=llvm-readelf
OBJSIZE=llvm-size
STRIP=llvm-strip
LLVM_AR=llvm-ar
LLVM_DIS=llvm-dis
LLVM_NM=llvm-nm
CROSS_COMPILE=aarch64-linux-android-
CROSS_COMPILE_ARM32=arm-linux-androideabi-
LLVM=1
'

# === COMPILACIÓN ===

# Configuración del kernel
make ${ARGS} O=out vendor/bengal-perf_defconfig \
    vendor/debugfs.config \
    vendor/ext_config/moto-bengal.config \
    vendor/ext_config/rhode-default.config \
    -j$(nproc --all)

# Compilación del kernel
make ${ARGS} O=out -j$(nproc --all)

# Verificar si se generó el Image
if [ ! -e "out/arch/arm64/boot/Image" ]; then
    echo "❌ ERROR: Image no encontrada, falla de compilación"
    exit 1
fi

# Instalar módulos
make ${ARGS} O=out -j$(nproc --all) \
    INSTALL_MOD_PATH=modules INSTALL_MOD_STRIP=1 modules_install