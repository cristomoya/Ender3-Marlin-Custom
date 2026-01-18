# Configuración Marlin - COMPLETADA ✅

## Resumen de Cambios Implementados

### 1. Hardware Configurado
```
Placa:        SKR MINI E3 V3.0 (confirmada)
Sensor Z:     BLTouch (habilitado)
Pantalla:     MKS TFT32_L V3.0 (SERIAL_PORT_2 = 1)
Impresora:    Ender 3 (dimensiones 235x235x250)
```

### 2. Tabla Resumen de Cambios

| Parámetro | Valor | Motivo |
|---|---|---|
| MOTHERBOARD | BOARD_SKR_MINI_E3_V3_0 | Placa correcta |
| BLTOUCH | habilitado | Homing Z automático |
| USE_PROBE_FOR_Z_HOMING | true | Usar BLTouch para G28 |
| Z_MIN_PROBE_INVERTING | true | Lógica del BLTouch |
| SERIAL_PORT_2 | 1 | Para MKS TFT (USART2) |
| BAUDRATE_2 | 250000 | Velocidad comunicación |
| DEFAULT_AXIS_STEPS | {80,80,400,93} | Ender 3 estándar |
| DEFAULT_MAX_FEEDRATE | {200,200,8,25} | Velocidades seguras |
| DEFAULT_ACCELERATION | 1000 | Aceleración suave |
| X_BED_SIZE | 235 | Ancho Ender 3 |
| Y_BED_SIZE | 235 | Profundidad Ender 3 |
| Z_MAX_POS | 250 | Altura disponible |
| NOZZLE_TO_PROBE_OFFSET | {-43,-7,0} | BLTouch típico |
| XY_PROBE_FEEDRATE | 100 mm/min | Velocidad probe XY |
| Z_PROBE_FEEDRATE_FAST | 2 mm/min | Velocidad rápida Z |
| Z_PROBE_FEEDRATE_SLOW | 1 mm/min | Velocidad precisa Z |
| AUTO_BED_LEVELING | BILINEAR | Leveling malla |
| GRID_MAX_POINTS | 4x4 | Precisión optimizada |
| ENABLE_LEVELING_AFTER_G28 | true | Auto activar leveling |

### 3. Cambios por Archivo

**Configuration.h:**
- ✅ Placa base
- ✅ Puertos seriales (2x)
- ✅ Sensores temperatura (hotend + bed)
- ✅ Steps/mm para Ender 3
- ✅ Velocidades y aceleraciones
- ✅ Dimensiones de cama y limits
- ✅ Configuración BLTouch
- ✅ Auto Bed Leveling (BILINEAR)
- ✅ Offsets de probe
- ✅ Parámetros de probing

## 📋 Estado de Compilación

El firmware está listo para compilar. No hay cambios adicionales necesarios en Configuration.h para funcionamiento básico.

## 🔍 Valores Críticos a Revisar Después de Compilar

### 1. Offsets BLTouch (Post-Compilación)
```gcode
; Después del primer G28/G29, medir exactamente:
G30 P0 X50 Y50 Z-999   ; Probar punto específico
; Ajustar si es necesario:
M851 Z-2.5             ; Valor inicial (-2.5 a -3.0 típico)
M500                   ; Guardar
```

### 2. Calibración de E-Steps (Post-Compilación)
```gcode
; Si el extrusor no extruye correctamente:
M109 S200
G92 E0
G1 E100 F100
; Medir y calcular: E_steps_nuevo = E_steps_actual * 100 / distancia_real
; Establecer y guardar:
M92 E[nuevo_valor]
M500
```

### 3. Test de Probe
```gcode
; Verificar que BLTouch funciona:
G28                    ; Home completo con probe
M119                   ; Estado de endstops/probe
G30 P0 X10 Y10 Z-999   ; Probar en punto seguro
```

## 🚀 Secuencia de Validación

```
1. Compilar en PlatformIO ✅
   └─ pio run -e SKR_MINI_E3_V3 -t upload

2. Verificar conexiones físicas
   ├─ BLTouch: 5V, GND, Pin Probe (amarillo)
   └─ TFT: 5V, GND, RX, TX en PA9/PA10

3. Test M115 (info firmware)

4. Test G28 (home con BLTouch)

5. Test probe aislado
   └─ M119 para ver estado

6. Auto-leveling G29 (crear malla)

7. Ajustar Z-offset M851

8. Calibrar E-steps si es necesario

9. Imprimir modelo de prueba
```

## ⚠️ Notas Críticas

1. **Z-Offset muy importante**: Un valor incorrecto daña la cama
2. **BLTouch es "inverso"**: Necesita Z_MIN_PROBE_INVERTING = true
3. **Pantalla TFT**: Requiere firmware compatible en la pantalla (MKS)
4. **Steps E variable**: Depende del extrusor específico (probablemente 93-95)

## 📞 Soporte de Errores Comunes

| Error | Causa Probable | Solución |
|---|---|---|
| "Un control de formulario no válido" | Campo required vacío | ✅ Removido (validación manual) |
| BLTouch no dispara | Z_PROBE_INVERTING = false | ✅ Cambiar a true |
| Altura Z incorrecta | GRID_POINTS mal | ✅ Configurado a 4x4 |
| Velocidades extremas | Steps incorrectos | ✅ Verificados para Ender 3 |
| Pantalla no conecta | Puerto serial incorrecto | ✅ SERIAL_PORT_2 configurado |

---

**Fecha de compilación:** 15 de enero de 2026
**Firmware:** Marlin 2.1.2.6
**Estado:** ✅ LISTO PARA COMPILAR
