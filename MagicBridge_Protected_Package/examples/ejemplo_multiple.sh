#!/bin/bash
#
# Ejemplo Avanzado: Programar múltiples chips del mismo modelo
#
# Uso: ./ejemplo_multiple.sh <archivo.hmf> <puerto> <cantidad>
# Ejemplo: ./ejemplo_multiple.sh datos.hmf /dev/ttyACM0 5
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -ne 3 ]; then
    echo "❌ Error: Faltan argumentos"
    echo ""
    echo "Uso: $0 <archivo.hmf> <puerto> <cantidad>"
    echo ""
    echo "Ejemplos:"
    echo "  $0 datos.hmf /dev/ttyACM0 5"
    exit 1
fi

ARCHIVO_HMF=$1
PUERTO=$2
CANTIDAD=$3
PCB=5
VARIANTE=D

echo "╔════════════════════════════════════════════════════════╗"
echo "║   MagicBridge - Programación Múltiple                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configuración:"
echo "   Archivo HMF: $ARCHIVO_HMF"
echo "   Puerto:      $PUERTO"
echo "   PCB:         $PCB"
echo "   Variante:    $VARIANTE"
echo "   Cantidad:    $CANTIDAD chips"
echo ""

# Paso 1: Cargar datos (UNA SOLA VEZ)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📥 Cargando datos HMF al MagicBridge (solo una vez)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/../bin/magicbridge-load" "$ARCHIVO_HMF" "$PUERTO" $PCB $VARIANTE --quiet

if [ $? -ne 0 ]; then
    echo "❌ Error al cargar datos"
    exit 1
fi
echo "✅ Datos cargados en RAM del MagicBridge"
echo ""

# Contador de éxitos y fallos
EXITOSOS=0
FALLIDOS=0

# Paso 2: Programar múltiples chips
for i in $(seq 1 $CANTIDAD); do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✍️  Chip $i de $CANTIDAD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ $i -gt 1 ]; then
        echo "⏸️  Presiona ENTER después de cambiar el chip..."
        read
    fi

    echo "🔧 Programando..."
    "$SCRIPT_DIR/../bin/magicbridge-cmd" "$PUERTO" W${PCB}${VARIANTE,} --quiet

    if [ $? -eq 0 ]; then
        echo "✅ Chip $i programado exitosamente"
        EXITOSOS=$((EXITOSOS + 1))
    else
        echo "❌ Error al programar chip $i"
        FALLIDOS=$((FALLIDOS + 1))
    fi
    echo ""
done

# Resumen
echo "╔════════════════════════════════════════════════════════╗"
echo "║                    RESUMEN FINAL                       ║"
echo "╠════════════════════════════════════════════════════════╣"
echo "║  ✅ Chips programados: $EXITOSOS                                 ║"
echo "║  ❌ Chips fallidos:    $FALLIDOS                                 ║"
echo "╚════════════════════════════════════════════════════════╝"

if [ $FALLIDOS -eq 0 ]; then
    exit 0
else
    exit 1
fi
