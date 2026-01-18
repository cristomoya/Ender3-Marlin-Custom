# Configuración Marlin para Ender 3 + SKR MINI E3 V3.0 + BLTouch + MKS TFT32_L V3.0

## Cambios Aplicados ✅

### 1. **Placa Base**
- ✅ `MOTHERBOARD BOARD_SKR_MINI_E3_V3_0` - Configurada correctamente

### 2. **BLTouch (Homing Z)**
- ✅ `#define BLTOUCH` - Habilitado
- ✅ `#define USE_PROBE_FOR_Z_HOMING` - Probe para homing Z
- ✅ `Z_MIN_PROBE_ENDSTOP_INVERTING true` - Lógica invertida para BLTouch

**Conexiones en SKR MINI E3 V3.0**:
- Pin Rojo (5V): 5V
- Pin Negro (GND): GND
- Pin Amarillo (Señal): Conector de Probe (Pin dedicado)

### 3. **Pantalla MKS TFT32_L V3.0**
- ✅ `#define SERIAL_PORT_2 1` - Puerto serial USART2
- ✅ `#define BAUDRATE_2 250000` - Velocidad de comunicación

**Conexiones en SKR MINI E3 V3.0**:
```
MKS TFT32_L → SKR MINI E3 V3.0
GND         → GND
5V          → 5V
RX          → PA10 (USART2 TX)
TX          → PA9  (USART2 RX)
```

## Verificaciones Pendientes ⚠️

### En Configuration.h:
1. [ ] Revisar valores de pasos/mm (M92) para Ender 3:
   - X/Y/Z steps (usualmente 80 para X/Y, 400-800 para Z)
   - E steps (95 típico para Ender 3)

2. [ ] Verificar límites de carrera (endstops):
   - X_MIN_ENDSTOP_INVERTING: false ✅
   - Y_MIN_ENDSTOP_INVERTING: false ✅
   - Z_MIN_ENDSTOP_INVERTING: false (mecánico) ✅
   - Z_MIN_PROBE_ENDSTOP_INVERTING: true (BLTouch) ✅

3. [ ] Dimensiones de la cama:
   - Ender 3 típicamente: X_BED_SIZE 235, Y_BED_SIZE 235

4. [ ] Temperatura:
   - TEMP_SENSOR_0: 1 (100K thermistor)
   - TEMP_SENSOR_BED: 1 (100K thermistor)

### En Configuration_adv.h:
1. [ ] Configurar offset BLTouch (después del primer test)
   - Típicamente Z_OFFSET: -2.5 a -3.0 (ajustar según necesidad)

2. [ ] Habilitar compensación automática de cama (ABL)
   - ENABLE_LEVELING_AFTER_G28
   - Z_STEPPER_AUTO_ALIGN (si hay múltiples motores Z)

## Pasos Finales

### 1. Compilar y Flashear
```bash
# En PlatformIO (VSCode)
pio run -e SKR_MINI_E3_V3 -t upload
```

### 2. Testing Inicial
```gcode
; Verificar comunicación
M115                    ; Información de firmware

; Test de motores
G28                     ; Home todos los ejes (usará BLTouch para Z)
G1 Z10 F100            ; Mover Z 10mm

; Calibración BLTouch
M851 Z-2.5             ; Ajustar offset Z (valores negativos bajan la boquilla)
M500                   ; Guardar en EEPROM

; Test pantalla TFT
; La pantalla debe mostrar conexión serial correcta
```

### 3. Calibración Completa
```gcode
; Bed leveling manual (con pantalla o por Gcode)
G29                    ; Probing automático (si ABL configurado)

; Calibración de extrusor
M109 S200              ; Calentar a 200°C
G92 E0                 ; Reset extrusor
G1 E100 F100           ; Extruir 100mm
; Medir distancia real extruída y ajustar E-steps
```

## Notas Importantes 📝

- **BLTouch necesita firmware reciente**: Asegúrate de que Marlin esté actualizado
- **Calibración de Z offset crítica**: Una mala calibración puede dañar la cama
- **MKS TFT32 requiere firmware compatible**: Verifica versión en la pantalla
- **Puerto Serial 2**: Algunos bootloaders pueden causar conflictos, usa el protocolo MKS TFT

## URLs de Referencia
- Marlin Docs: https://marlinfw.org/docs/configuration/probes.html
- SKR MINI E3: https://github.com/bigtreetech/SKR-mini-E3
- MKS TFT32: https://github.com/makerbase-mks/MKS-TFT32
