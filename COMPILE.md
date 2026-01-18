# Guía de Compilación - Marlin para Ender 3 + SKR MINI E3 V3.0

## Requisitos Previos

### 1. Instalar PlatformIO

**Opción A: Instalación local (Recomendado)**
```bash
# Instalar Python 3.8 o superior (si no lo tienes)
python3 --version

# Instalar PlatformIO CLI
pip install platformio

# Verificar instalación
pio --version
```

**Opción B: Usar VS Code Extension**
- Instala la extensión "PlatformIO IDE" desde el marketplace de VS Code
- Abre la carpeta del proyecto en VS Code
- Usa la interfaz gráfica de PlatformIO

---

## Compilación

### Método 1: Compilar solo (sin flashear)

```bash
cd /Users/cristobalmoyalopez/Documents/Ender3_skr_mini_e3_v3_Marlin-2.1.2.6

# Compilar para SKR MINI E3 V3.0
pio run -e SKR_MINI_E3_V3

# Esperado: "Environment SKR_MINI_E3_V3 ===== [SUCCESS] ====="
```

El firmware compilado estará en:
```
.pio/build/SKR_MINI_E3_V3/firmware.bin
```

### Método 2: Compilar y Flashear (con cable USB)

```bash
# 1. Conecta la placa SKR MINI E3 V3.0 por USB a la Mac
# 2. Ejecuta:

pio run -e SKR_MINI_E3_V3 -t upload

# El sistema detectará el puerto COM automáticamente
```

### Método 3: Generar solo el .bin (para SD card)

```bash
pio run -e SKR_MINI_E3_V3

# Copia el archivo a una SD card:
# 1. Localiza el firmware: .pio/build/SKR_MINI_E3_V3/firmware.bin
# 2. Copia a una SD card formateada en FAT32
# 3. Inserta en la impresora y reinicia
```

---

## Solución de Problemas

### Error: "ModuleNotFoundError: No module named 'platformio'"

**Solución:**
```bash
# Instala platformio globalmente
pip3 install platformio --user

# O usa brew (si tienes Homebrew)
brew install platformio
```

### Error: "Environment 'SKR_MINI_E3_V3' not found"

**Solución:**
```bash
# Verifica los environments disponibles
pio env

# Los válidos son:
# - SKR_MINI_E3_V3
# - SKR_MINI_E3_V2
# - SKR_MINI_E3
```

### Error de compilación con conflictos

**Solución:**
```bash
# Limpia la caché de compilación
pio run -e SKR_MINI_E3_V3 -t clean

# Recompila
pio run -e SKR_MINI_E3_V3
```

### Puerto USB no detectado en upload

**En macOS:**
```bash
# Lista puertos disponibles
ls /dev/tty.*

# Flashea manualmente especificando puerto
pio run -e SKR_MINI_E3_V3 -t upload --upload-port /dev/tty.usbserial-XXXX
```

---

## Pasos Recomendados

### Primera Compilación:

```bash
cd /Users/cristobalmoyalopez/Documents/Ender3_skr_mini_e3_v3_Marlin-2.1.2.6

# 1. Limpia compilaciones previas
pio run -e SKR_MINI_E3_V3 -t clean

# 2. Compila (sin flashear primero, para verificar)
pio run -e SKR_MINI_E3_V3

# Si todo está bien, verás:
# ========================================= [SUCCESS] =========================================
```

### Si la compilación es exitosa:

```bash
# 3. Conecta el cable USB a la SKR MINI E3 V3.0
# 4. Flashea el firmware
pio run -e SKR_MINI_E3_V3 -t upload

# Verás:
# Uploading .pio/build/SKR_MINI_E3_V3/firmware.bin
# [============================] 100% Upload Success
```

---

## Verificación Post-Compilación

Después de flashear, verifica:

```gcode
# En OctoPrint, Pronterface o terminal serie:
M115     ; Información del firmware
M851     ; Mostrar offset del probe Z
M900     ; Verificar configuración
```

---

## Archivos Importantes

| Archivo | Ubicación | Descripción |
|---------|-----------|-------------|
| Configuración Principal | `Marlin/Configuration.h` | Parámetros de máquina, probe, etc. |
| Configuración Avanzada | `Marlin/Configuration_adv.h` | Parámetros avanzados |
| Firmware compilado | `.pio/build/SKR_MINI_E3_V3/firmware.bin` | Archivo para flashear |
| Proyecto PlatformIO | `platformio.ini` | Configuración de compilación |

---

## Comandos Útiles

```bash
# Ver todos los environments disponibles
pio env

# Ver información sobre un environment
pio run -e SKR_MINI_E3_V3 -t info

# Compilar verbosamente (para debugging)
pio run -e SKR_MINI_E3_V3 -v

# Compilar sin optimizaciones
pio run -e SKR_MINI_E3_V3 --no-verbose
```

---

## Notas Importantes

- **BLTouch requiere compilación correcta**: Si no compila, BLTouch no funcionará
- **Velocidad USB**: En macOS a veces es lenta; sé paciente durante el upload
- **EEPROM**: Los valores de EEPROM se resetean al flashear. Necesitarás recalibrar offsets Z
- **Respaldo**: Guarda una copia de `Configuration.h` antes de hacer cambios

---

¿Necesitas ayuda adicional? Ejecuta primero:
```bash
cd /Users/cristobalmoyalopez/Documents/Ender3_skr_mini_e3_v3_Marlin-2.1.2.6
pio run -e SKR_MINI_E3_V3 -t clean
pio run -e SKR_MINI_E3_V3
```

Y comparte el resultado/error.
