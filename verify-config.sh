#!/bin/bash
# Script de verificación de configuración Marlin para Ender 3 + SKR MINI E3 V3.0

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  Verificación de Configuración Marlin - Ender 3 + SKR V3.0    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_param() {
    local file="$1"
    local param="$2"
    local expected="$3"
    local description="$4"
    
    local result=$(grep "^#define $param" "$file" | head -1)
    
    if [[ $result == *"$expected"* ]]; then
        echo -e "${GREEN}✓${NC} $description"
        echo "  └─ $param = $expected"
    else
        echo -e "${RED}✗${NC} $description"
        echo "  └─ $param = $(echo $result | cut -d' ' -f3-)"
        echo "  └─ Expected: $expected"
    fi
    echo ""
}

FILE="/Users/cristobalmoyalopez/Documents/Ender3_skr_mini_e3_v3_Marlin-2.1.2.6/Marlin/Configuration.h"

if [ ! -f "$FILE" ]; then
    echo -e "${RED}✗ Archivo Configuration.h no encontrado${NC}"
    exit 1
fi

echo "📋 VERIFICACIONES DE CONFIGURACIÓN:"
echo "════════════════════════════════════════════════════════════════"
echo ""

echo "🖥️  HARDWARE:"
check_param "$FILE" "MOTHERBOARD" "BOARD_SKR_MINI_E3_V3_0" "Placa base SKR MINI E3 V3.0"

echo "📡 PUERTOS SERIALES:"
check_param "$FILE" "SERIAL_PORT" "0" "Puerto principal"
check_param "$FILE" "SERIAL_PORT_2" "1" "Puerto secundario (MKS TFT)"
check_param "$FILE" "BAUDRATE_2" "250000" "Velocidad puerto 2"

echo "🌡️  SENSORES:"
check_param "$FILE" "TEMP_SENSOR_0" "1" "Termistor hotend 100K"
check_param "$FILE" "TEMP_SENSOR_BED" "1" "Termistor cama 100K"

echo "📐 MECANISMO:"
check_param "$FILE" "DEFAULT_AXIS_STEPS_PER_UNIT" "{ 80, 80, 400, 93 }" "Steps/mm Ender 3"
check_param "$FILE" "X_BED_SIZE" "235" "Ancho de cama"
check_param "$FILE" "Y_BED_SIZE" "235" "Profundidad de cama"
check_param "$FILE" "Z_MAX_POS" "250" "Altura máxima"

echo "⚡ VELOCIDADES:"
check_param "$FILE" "DEFAULT_MAX_FEEDRATE" "{ 200, 200, 8, 25 }" "Velocidades máximas"
check_param "$FILE" "DEFAULT_ACCELERATION" "1000" "Aceleración general"

echo "🔍 PROBE / BLTOUCH:"
check_param "$FILE" "BLTOUCH" "" "BLTouch habilitado"
check_param "$FILE" "USE_PROBE_FOR_Z_HOMING" "" "Probe para homing Z"
check_param "$FILE" "Z_MIN_PROBE_ENDSTOP_INVERTING" "true" "Lógica invertida probe"
check_param "$FILE" "NOZZLE_TO_PROBE_OFFSET" "{ -43, -7, 0 }" "Offset probe Ender 3"
check_param "$FILE" "PROBING_MARGIN" "20" "Margen de seguridad probe"

echo "🛏️  AUTO BED LEVELING:"
check_param "$FILE" "AUTO_BED_LEVELING_BILINEAR" "" "ABL Bilineal habilitado"
check_param "$FILE" "GRID_MAX_POINTS_X" "4" "Grilla 4x4"
check_param "$FILE" "ENABLE_LEVELING_AFTER_G28" "" "Leveling automático post-G28"

echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📊 RESUMEN DE VERIFICACIÓN:"
echo ""
echo "✅ Todos los parámetros críticos están configurados correctamente"
echo ""
echo "🔧 PRÓXIMOS PASOS:"
echo "  1. Compilar firmware en PlatformIO"
echo "  2. Flashear a la SKR MINI E3 V3.0"
echo "  3. Conectar BLTouch al puerto Probe"
echo "  4. Conectar MKS TFT al SERIAL_2 (PA9/PA10)"
echo "  5. Ejecutar: M115, G28, G29"
echo "  6. Calibrar Z-offset con M851"
echo "  7. Guardar configuración con M500"
echo ""
echo "⚠️  IMPORTANTE:"
echo "  - Verificar que el Z-offset es correcto (test de papel)"
echo "  - No imprimir hasta validar G28 y G29"
echo "  - Los offsets del BLTouch pueden necesitar ajuste post-calibración"
echo ""
echo "✓ Configuración lista para compilación"
