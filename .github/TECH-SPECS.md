# Especificaciones Técnicas - Ender 3 Marlin Configuration

## 1. Especificaciones de Hardware

### Impresora: Creality Ender 3
- **Tamaño de cama:** 235 × 235 mm (configurado)
- **Altura máxima:** 250 mm (configurado)
- **Volumen de impresión:** 235 × 235 × 250 mm³
- **Sistema de ejes:** XYZ cartesiano
- **Estructura:** Marco de aluminio

### Placa Base: BigTreeTech SKR MINI E3 V3.0
- **Procesador:** STM32G0B1 ARM Cortex-M0+ 32-bit
- **Velocidad de reloj:** 64 MHz
- **Memoria:** 64 KB SRAM, 128 KB Flash
- **Puertos UART:** 2 (USART1 principal, USART2 secundario)
- **Drivers de motor:** TMC2209 (sin ajuste manual necesario)
- **Conexión USB:** Mini-USB para programación
- **Alimentación:** 24V DC (típicamente 30A)

### Sensor de Homing Z: BLTouch
- **Tipo:** Sensor de proximidad inductivo + servo
- **Rango de detección:** 3-5 mm
- **Exactitud:** ±0.2 mm
- **Lógica:** Activa-baja (necesita inversion en firmware) ✅
- **Voltaje:** 5V
- **Corriente:** 50 mA (máximo)
- **Conectores:** 3 pines (señal) + 2 pines (alimentación)

### Pantalla: MKS TFT32_L V3.0
- **Diagonal:** 3.2 pulgadas
- **Resolución:** 320 × 240 píxeles
- **Tipo de pantalla:** LCD color TFT
- **Interfaz:** UART (comunicación serial)
- **Baudrate:** 250000 bps (configurado)
- **Voltaje:** 5V
- **Corriente:** ~500 mA

### Sensores de Temperatura

#### Hotend (E0)
- **Tipo:** Termistor NTC 100K 3950B
- **Referencia:** TEMP_SENSOR_0 = 1 (configurado)
- **Rango:** -40°C a +280°C
- **Exactitud:** ±5°C

#### Cama Caliente
- **Tipo:** Termistor NTC 100K 3950B
- **Referencia:** TEMP_SENSOR_BED = 1 (configurado)
- **Rango:** -40°C a +150°C
- **Exactitud:** ±5°C

---

## 2. Especificaciones Mecánicas

### Motores Paso a Paso

#### XY (Horizontal)
- **Tipo:** NEMA 17
- **Torque:** 0.4 Nm
- **Corriente:** 1.5A
- **Configuración:** TMC2209 sin sensor de corriente
- **Steps/mm:** 80 (configurado ✅)
- **Reductor:** Engranaje directo (X), Polea GT2 (Y)

#### Z (Vertical)
- **Tipo:** NEMA 17
- **Torque:** 0.4 Nm
- **Corriente:** 1.5A
- **Configuración:** TMC2209
- **Steps/mm:** 400 (configurado ✅)
- **Sistema:** Tornillo de bola M8 de paso 2mm
- **Cálculo:** (200 pasos/revolución × 2 micropasos) / 2 mm = 400 steps/mm

#### E (Extrusor)
- **Tipo:** NEMA 17
- **Torque:** 0.4 Nm
- **Corriente:** 1.2A
- **Configuración:** TMC2209
- **Steps/mm:** 93 (configurado ✅)
- **Reductor:** Engranaje de extrusión (típicamente 3:1)

### Nozzle y Hotbed
- **Diámetro de boquilla:** 0.4 mm (estándar)
- **Tamaño de cama caliente:** 235 × 235 mm
- **Materiales soportados:** PLA, PETG, ABS, TPU

---

## 3. Especificaciones de Configuración Marlin

### Configuración de Velocidades

```
DEFAULT_MAX_FEEDRATE:
  X: 200 mm/min (3.33 mm/s)
  Y: 200 mm/min (3.33 mm/s)
  Z: 8 mm/min (0.13 mm/s)
  E: 25 mm/min (0.42 mm/s)

DEFAULT_ACCELERATION:
  General: 1000 mm/s²
  
DEFAULT_MAX_ACCELERATION:
  X: 1500 mm/s²
  Y: 1500 mm/s²
  Z: 100 mm/s² (eje vertical crítico)
  E: 5000 mm/s²
```

### Configuración del Probe (BLTouch)

```
NOZZLE_TO_PROBE_OFFSET: { -43, -7, 0 }
  X: -43 mm (probe 43mm a la izquierda de la boquilla)
  Y: -7 mm (probe 7mm hacia atrás de la boquilla)
  Z: 0 mm (se ajusta con M851 post-calibración)

XY_PROBE_FEEDRATE: 100 mm/min (100*60)
Z_PROBE_FEEDRATE_FAST: 2 mm/min (2*60)
Z_PROBE_FEEDRATE_SLOW: 1 mm/min (Z_PROBE_FEEDRATE_FAST/2)

PROBING_MARGIN: 20 mm (distancia mínima desde bordes de cama)
```

### Configuración de Auto Bed Leveling (ABL)

```
Tipo: BILINEAR
Grilla: 4 × 4 puntos (16 puntos de probing)
Punto de prueba: Inicia en (PROBING_MARGIN, PROBING_MARGIN)
Punto final: (X_BED_SIZE - PROBING_MARGIN, Y_BED_SIZE - PROBING_MARGIN)

Rango de movimiento en X: 20 a 215 mm
Rango de movimiento en Y: 20 a 215 mm

Desvanecimiento de leveling:
  Habilitado a partir de 10 mm de altura
  Se desactiva gradualmente hasta altura máxima
```

---

## 4. Cálculos y Validaciones

### Cálculo de Steps/mm para Z

```
Tornillo M8, paso 2 mm:
  Pasos por revolución: 200 (NEMA 17 sin microstepping)
  Microstepping: 2 (TMC2209)
  Pasos efectivos: 200 × 2 = 400
  Avance por vuelta: 2 mm
  Steps/mm = 400 / 2 = 200 ✗ (Este es sin engranaje)

Con 2:1 de engranaje (típico en Ender 3):
  Steps/mm = 400 pasos/mm configurado ✅
```

### Cálculo de Steps/mm para E

```
Engranaje Ender 3: ~3:1
Rueda dentada: 39 dientes
Paso de filamento: 1.75 mm
Estimación: 93-95 steps/mm típico
Configurado: 93 steps/mm ✅

Calibración post-printing recomendada.
```

### Límites de Velocidad Recomendados

```
XY: 200 mm/s máximo (velocidades seguras para Ender 3)
    Típicamente: 40-60 mm/s para impresiones de calidad
    
Z: 8 mm/s máximo (muy lento por estabilidad)
   Típicamente: 2-4 mm/s

E: 25 mm/s máximo
   Típicamente: 10-15 mm/s
```

---

## 5. Puertos y Conectividad

### UART Connections

#### SERIAL_PORT 0 (Principal)
- **Propósito:** Comunicación con host (PC/Octoprint)
- **Velocidad:** 250000 bps
- **Pines:** PA9 (RX), PA10 (TX)
- **Conector:** USB mini-B en SKR (incluye adaptador FTDI)

#### SERIAL_PORT_2 1 (Secundario)
- **Propósito:** Pantalla MKS TFT32
- **Velocidad:** 250000 bps (configurado ✅)
- **Pines:** PA2 (RX), PA3 (TX)
- **Conector:** Directamente en header USART2

### Pin Configuration

```
SKR MINI E3 V3.0 Pin Mapping:

Motores:
  X Motor: MOTOR_0
  Y Motor: MOTOR_1
  Z Motor: MOTOR_2
  E Motor: MOTOR_3

Endstops:
  X-Min: P1.28 (active low)
  Y-Min: P1.26 (active low)
  Z-Min: P0.10 (active low)

Probe (Z-Min en Probe):
  Probe Pin: P0.10 (mismo que Z-Min por defecto)

Heaters:
  Hotend: P2.05 (PWM)
  Bed: P2.04 (PWM)

Fans:
  Fan: P2.01
  Hotend Fan: P2.06

Sensors:
  Bed Thermistor: A0
  Hotend Thermistor: A1
```

---

## 6. Rangos Operativos Seguros

### Temperaturas

```
Hotend:
  Mínimo: 170°C (EXTRUDE_MINTEMP - protección)
  Máximo: 250°C (recomendado para PLA/PETG)
  Nominal: 200-210°C (PLA)

Cama:
  Mínimo: 20°C (temperatura ambiente)
  Máximo: 110°C (recomendado)
  Nominal: 60°C (PLA), 80°C (ABS)
```

### Espacios de Movimiento

```
X: 0 a 235 mm
Y: 0 a 235 mm
Z: 0 a 250 mm

Nota: Los offsets del probe pueden reducir el área de probing
      a 20-215 mm en X/Y (PROBING_MARGIN = 20)
```

---

## 7. Valores de Referencia Post-Calibración

Después de compilar y probar, espera aproximadamente:

```
BLTouch Z-Offset: -2.5 a -3.0 mm (rango típico)
E-Steps: 93-98 (después de calibración)
Aceleración óptima: 500-1500 mm/s² (depende del tuning)
Velocidad de impresión: 40-80 mm/s (después de tune-up)
```

---

## 📊 Tabla Resumen de Parámetros

| Parámetro | Valor | Unidad | Notas |
|---|---|---|---|
| Tamaño cama X | 235 | mm | Ender 3 |
| Tamaño cama Y | 235 | mm | Ender 3 |
| Altura máxima Z | 250 | mm | Ender 3 V3 |
| Steps/mm X | 80 | steps/mm | Exacto |
| Steps/mm Y | 80 | steps/mm | Exacto |
| Steps/mm Z | 400 | steps/mm | Exacto (M8x2) |
| Steps/mm E | 93 | steps/mm | Calibrable |
| Velocidad máxima X | 200 | mm/min | Seguro |
| Velocidad máxima Y | 200 | mm/min | Seguro |
| Velocidad máxima Z | 8 | mm/min | Muy conservador |
| Velocidad máxima E | 25 | mm/min | Seguro |
| Aceleración general | 1000 | mm/s² | Conservador |
| Offset probe X | -43 | mm | Ender 3 típico |
| Offset probe Y | -7 | mm | Ender 3 típico |
| Offset probe Z | 0 | mm | Variable (M851) |
| Punto de probing | 4×4 | - | 16 puntos |
| Margen de probe | 20 | mm | De seguridad |
| Puerto pantalla | USART2 | - | PA2/PA3 |
| Baudrate pantalla | 250000 | bps | MKS TFT |

---

**Documento técnico:** 15 de enero de 2026
**Marlin:** 2.1.2.6
**Placa:** SKR MINI E3 V3.0
