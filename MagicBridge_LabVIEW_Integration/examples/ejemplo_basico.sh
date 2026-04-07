#!/bin/bash
#
# Ejemplo Básico: Programar un chip ELMOS PCB 5 Variante D
#
# Uso: ./ejemplo_basico.sh <archivo.hmf> <puerto>
# Ejemplo: ./ejemplo_basico.sh datos.hmf /dev/ttyACM0
#

set -e  # Salir si hay error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verificar argumentos
if [ $# -ne 2 ]; then
    echo "❌ Error: Faltan argumentos"
    echo ""
    echo "Uso: $0 <archivo.hmf> <puerto>"
    echo ""
    echo "Ejemplos:"
    echo "  Linux:   $0 datos.hmf /dev/ttyACM0"
    echo "  Windows: $0 datos.hmf COM3"
    exit 1
fi

ARCHIVO_HMF=$1
PUERTO=$2
PCB=5
VARIANTE=D

echo "╔════════════════════════════════════════════════════════╗"
echo "║   MagicBridge - Programación de Chip ELMOS            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configuración:"
echo "   Archivo HMF: $ARCHIVO_HMF"
echo "   Puerto:      $PUERTO"
echo "   PCB:         $PCB"
echo "   Variante:    $VARIANTE"
echo ""

# Paso 1: Cargar datos
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 PASO 1: Cargando datos HMF al MagicBridge..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/../bin/magicbridge-load" "$ARCHIVO_HMF" "$PUERTO" $PCB $VARIANTE

if [ $? -eq 0 ]; then
    echo "✅ Datos cargados exitosamente"
else
    echo "❌ Error al cargar datos"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✍️  PASO 2: Programando chip..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/../bin/magicbridge-cmd" "$PUERTO" W${PCB}${VARIANTE,}

if [ $? -eq 0 ]; then
    echo "✅ Chip programado exitosamente"
else
    echo "❌ Error al programar chip"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║          ✅ PROGRAMACIÓN COMPLETADA CON ÉXITO          ║"
echo "╚════════════════════════════════════════════════════════╝"
