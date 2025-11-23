#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$BASE_DIR/src/config.json"

require_jq() {
	if ! command -v jq >/dev/null 2>&1; then
		echo "Se necesita 'jq' para leer $CONFIG. Instálalo y vuelve a ejecutar." >&2
		exit 1
	fi
}

compile_kernel() {
    cp "./src/build_sm6225.sh" "$(jq -r '.kernel.dir' "$CONFIG")/"
    cd "$(jq -r '.kernel.dir' "$CONFIG")/" || exit 1
    echo "🚀 Ejecutando compilación..."
    bash "./build_sm6225.sh"
}

menu() {
	while true; do
		echo ""
		echo "===== Menú de opciones ====="
		echo "1) Compilar"
		echo "2) Descargar Kernel"
		echo "3) Descargar Toolchains"
		echo "4) Descargar/Aplicar AnyKernel3"
		echo "5) Salir"
		echo "============================"
		read -rp "Elige una opción [1-5]: " opt
		case "$opt" in
			1)
				compile_kernel
				;;
			2)
				./src/download-kernel.sh
				;;
			3)
				./src/download-toolchains.sh
				;;
			4)
				./src/download_anykernel.sh
				;;
			5)
				echo "Saliendo..." && exit 0
				;;
			*) echo "Opción inválida." ;;
		esac
	done
}

require_jq
menu