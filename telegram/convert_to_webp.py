import sys
import os
from PIL import Image

sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')

def convert_to_webp(input_path, output_path):
    try:
        with Image.open(input_path) as img:
            img.save(output_path, "WEBP")
        print(f"✅ Conversión exitosa: {output_path}")
    except Exception as e:
        print(f"❌ Error al convertir la imagen: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python convert_to_webp.py <ruta_imagen_entrada> <ruta_imagen_salida>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    if not os.path.isfile(input_path):
        print(f"❌ El archivo de entrada no existe: {input_path}")
        sys.exit(1)

    convert_to_webp(input_path, output_path)