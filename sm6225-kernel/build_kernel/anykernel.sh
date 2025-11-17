#!/bin/bash

KERNEL_IMAGE="out/arch/arm64/boot/Image"
ANYKERNEL_DIR="AnyKernel3"
ZIP_NAME="DanceKernel-rhode.zip"

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