#!/bin/bash

# === VARIABLES ===
KERNEL_IMAGE="out/arch/arm64/boot/kernel"
ZIP_NAME="DanceKernel-rhode.zip"
ANYKERNEL_DIR=AnyKernel3

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

# Instalar módulos
make ${ARGS} O=out -j$(nproc --all) \
    INSTALL_MOD_PATH=modules INSTALL_MOD_STRIP=1 modules_install

# Verificar si se generó el Image
if [ ! -e "out/arch/arm64/boot/Image" ]; then
    echo "❌ ERROR: Image no encontrada, falla de compilación"
    exit 1
else
    echo "✅ Compilación exitosa: Archivo Image generado"
    echo "🖋️ Renombrando Image -> kernel"
    mv out/arch/arm64/boot/Image out/arch/arm64/boot/kernel
fi

# Verificar si el archivo compilado existe
if [ ! -f "$KERNEL_IMAGE" ]; then
    echo "❌ El archivo '$KERNEL_IMAGE' no existe. Asegúrate de que la compilación se haya completado correctamente."
    exit 1
fi

# Copiar el archivo compilado al directorio AnyKernel3
echo "📂 Copiando '$KERNEL_IMAGE' a '$ANYKERNEL_DIR'..."
cp "$KERNEL_IMAGE" "$ANYKERNEL_DIR/" || {
    echo "❌ Error al copiar el archivo '$KERNEL_IMAGE'."
    exit 1
}

# Cambiar al directorio AnyKernel3
cd "$ANYKERNEL_DIR" || {
    echo "❌ No se pudo cambiar al directorio '$ANYKERNEL_DIR'."
    exit 1
}

# Crear el archivo zip
echo "📦 Creando archivo zip '$ZIP_NAME'..."
zip -r9 "$ZIP_NAME" * -x .git \*placeholder || {
    echo "❌ Error al crear el archivo zip."
    exit 1
}

echo "✅ Archivo zip creado exitosamente: '$ZIP_NAME'"