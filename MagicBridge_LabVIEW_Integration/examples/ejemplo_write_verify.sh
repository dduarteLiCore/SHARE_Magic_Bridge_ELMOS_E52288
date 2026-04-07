#!/bin/bash
#
# Ejemplo: Escritura y Verificacion de multiples chips
#
# Carga el HMF una sola vez, luego para cada chip:
#   1. Escribe (W)
#   2. Verifica leyendo (R)
#
# Uso: ./ejemplo_write_verify.sh <archivo.hmf> <puerto> <cantidad>
# Ejemplo: ./ejemplo_write_verify.sh datos.hmf /dev/ttyACM0 5
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -ne 3 ]; then
    echo "ERROR: Faltan argumentos"
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
echo "║   MagicBridge - Escritura y Verificacion Multiple     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Configuracion:"
echo "   Archivo HMF: $ARCHIVO_HMF"
echo "   Puerto:      $PUERTO"
echo "   PCB:         $PCB"
echo "   Variante:    $VARIANTE"
echo "   Cantidad:    $CANTIDAD chips"
echo ""

# Paso 1: Cargar datos (UNA SOLA VEZ)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Cargando datos HMF al MagicBridge (solo una vez)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/../bin/magicbridge-load" "$ARCHIVO_HMF" "$PUERTO" $PCB $VARIANTE --quiet

if [ $? -ne 0 ]; then
    echo "ERROR: Error al cargar datos"
    exit 1
fi
echo "OK: Datos cargados en RAM del MagicBridge"
echo ""

# Contadores
EXITOSOS=0
FALLIDOS=0

# Paso 2: Ciclo de escritura y verificacion
for i in $(seq 1 $CANTIDAD); do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Chip $i de $CANTIDAD"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if [ $i -gt 1 ]; then
        echo "Presiona ENTER despues de cambiar el chip..."
        read
    fi

    # Escritura
    echo "[1/2] Escribiendo chip..."
    "$SCRIPT_DIR/../bin/magicbridge-cmd" "$PUERTO" W${PCB}${VARIANTE,} --quiet

    if [ $? -ne 0 ]; then
        echo "ERROR: Fallo la escritura del chip $i"
        FALLIDOS=$((FALLIDOS + 1))
        echo ""
        continue
    fi
    echo "OK: Escritura exitosa"

    # Verificacion (lectura)
    echo "[2/2] Verificando chip (lectura)..."
    "$SCRIPT_DIR/../bin/magicbridge-cmd" "$PUERTO" R${PCB}${VARIANTE,} --quiet

    if [ $? -ne 0 ]; then
        echo "ERROR: Fallo la verificacion del chip $i"
        FALLIDOS=$((FALLIDOS + 1))
    else
        echo "OK: Verificacion exitosa"
        EXITOSOS=$((EXITOSOS + 1))
    fi

    echo ""
done

# Resumen final
echo "╔════════════════════════════════════════════════════════╗"
echo "║                    RESUMEN FINAL                       ║"
echo "╠════════════════════════════════════════════════════════╣"
echo "║  OK:    Chips exitosos: $EXITOSOS                                ║"
echo "║  ERROR: Chips fallidos: $FALLIDOS                                ║"
echo "╚════════════════════════════════════════════════════════╝"

if [ $FALLIDOS -eq 0 ]; then
    exit 0
else
    exit 1
fi
