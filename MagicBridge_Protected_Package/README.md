# MagicBridge ELMOS Programmer

## 📦 Versión del Código

Los scripts están en formato bytecode Python (.pyc), lo que significa:
- ✅ Este paquete contiene los scripts de control del MagicBridge en formato **bytecode compilado (.pyc)**.
- ✅ Requiere Python 3.11 instalado
- ⚠️ Los archivos .pyc son específicos de la versión de Python (compilados con CPython 3.11)

## 🚀 Inicio Rápido

### Requisitos
- Python 3.11
- pyserial: `pip install pyserial`
- MagicBridge conectado vía USB

### Uso Básico

#### Linux/macOS:
```bash
# Cargar datos
./bin/magicbridge-load archivo.hmf /dev/ttyACM0 5 D

# Ejecutar comando
./bin/magicbridge-cmd /dev/ttyACM0 W5d
```

#### Windows:
```cmd
REM Cargar datos
bin\magicbridge-load.bat archivo.hmf COM3 5 D

REM Ejecutar comando
bin\magicbridge-cmd.bat COM3 W5d
```

## 📂 Estructura del Paquete

```
MagicBridge_Protected_Package/
├── bin/                           # Ejecutables
│   ├── magicbridge-load          # Wrapper carga (Linux/macOS)
│   ├── magicbridge-cmd           # Wrapper comandos (Linux/macOS)
│   ├── magicbridge-load.bat      # Wrapper carga (Windows)
│   ├── magicbridge-cmd.bat       # Wrapper comandos (Windows)
│   ├── runner_load.py            # Runner Python - carga datos
│   ├── runner_cmd.py             # Runner Python - ejecutar comando
│   ├── 1_cargar_datos_v3.cpython-311.pyc
│   ├── 2_ejecutar_comando_v3.cpython-311.pyc
│   └── hmf_loader.cpython-311.pyc
│
├── examples/                      # Ejemplos de uso
├── docs/                          # Documentación
└── README.md                      # Este archivo
```

## 📝 Comandos Disponibles

### magicbridge-load (Cargar Datos HMF)

```bash
# Sintaxis
./bin/magicbridge-load <archivo.hmf> <puerto> <PCB> <variante> [opciones]

# Parámetros
- archivo.hmf : Archivo con datos OTP
- puerto      : Puerto serial (/dev/ttyACM0 o COM3)
- PCB         : Número de PCB (3, 5, 6)
- variante    : Variante (D o E)

# Opciones
--json FILE   : Guardar resultado en JSON
--log FILE    : Guardar log en archivo
--quiet       : Modo silencioso

# Ejemplos
./bin/magicbridge-load datos.hmf /dev/ttyACM0 5 D
./bin/magicbridge-load datos.hmf /dev/ttyACM0 5 D --json result.json --quiet
```

### magicbridge-cmd (Ejecutar Comandos)

```bash
# Sintaxis
./bin/magicbridge-cmd <puerto> <comando> [opciones]

# Comandos disponibles
W<PCB><var> : Write (escribir y verificar)
R<PCB><var> : Read (solo lectura)
P<PCB><var> : Program (write + power cycle + read)

# Ejemplos
./bin/magicbridge-cmd /dev/ttyACM0 W5d  # Escribir PCB 5 variante D
./bin/magicbridge-cmd /dev/ttyACM0 R3e  # Leer PCB 3 variante E
./bin/magicbridge-cmd /dev/ttyACM0 P6d  # Programar PCB 6 variante D
```

## 🔄 Flujo de Trabajo

### Programación de un Chip

1. **Conectar MagicBridge** vía USB
2. **Conectar chip ELMOS** a programar
3. **Cargar datos** (una sola vez):
   ```bash
   ./bin/magicbridge-load archivo.hmf /dev/ttyACM0 5 D
   ```
4. **Programar chip**:
   ```bash
   ./bin/magicbridge-cmd /dev/ttyACM0 W5d
   ```

### Múltiples Chips (mismo modelo)

Los datos permanecen en RAM del MagicBridge:

```bash
# 1. Cargar datos una vez
./bin/magicbridge-load archivo.hmf /dev/ttyACM0 5 D

# 2. Programar chip 1
./bin/magicbridge-cmd /dev/ttyACM0 W5d

# 3. Cambiar chip y programar chip 2
./bin/magicbridge-cmd /dev/ttyACM0 W5d

# 4. Repetir para más chips...
```

## 📋 Configuración de PCBs

| PCB | Dirección I2C | Variantes | Comandos |
|-----|---------------|-----------|----------|
| 3   | 0x01          | D, E      | W3d, W3e, R3d, R3e, P3d, P3e |
| 5   | 0x03          | D, E      | W5d, W5e, R5d, R5e, P5d, P5e |
| 6   | 0x02          | D, E      | W6d, W6e, R6d, R6e, P6d, P6e |

## 🔧 Verificación

### Verificar Conexión MagicBridge

**Linux:**
```bash
ls /dev/ttyACM*
lsusb | grep 1d50
```

**Windows:**
```
Device Manager → Ports (COM & LPT)
Buscar: "LiCore ELMOS Programmer (COMx)"
```

### Verificar Python y pyserial

```bash
python3 --version   # debe ser 3.11.x
python3 -c "import serial; print(serial.__version__)"
```

## 💡 Ejemplos Prácticos

Ver carpeta `examples/` para scripts de ejemplo:
- `ejemplo_basico.sh` - Programación básica (Linux/macOS)
- `ejemplo_basico.bat` - Programación básica (Windows)
- `ejemplo_multiple.sh` - Múltiples chips (Linux/macOS)
- `ejemplo_multiple.bat` - Múltiples chips (Windows)
- `ejemplo_json.py` - Integración con JSON

## ❓ Ayuda

### Ver ayuda completa
```bash
# Linux/macOS
./bin/magicbridge-load --help
./bin/magicbridge-cmd --help

# Windows
bin\magicbridge-load.bat --help
bin\magicbridge-cmd.bat --help
```

### Documentación
- [docs/INSTALACION.md](docs/INSTALACION.md) - Guía de instalación
- [docs/REFERENCIA_RAPIDA.md](docs/REFERENCIA_RAPIDA.md) - Referencia rápida
- [examples/README_EXAMPLES.md](examples/README_EXAMPLES.md) - Guía de ejemplos

## ⚠️ Notas Importantes

1. **Bytecode .pyc**
   - Compilado con Python 3.11
   - Requiere Python 3.11 instalado
   - No es código fuente visible

2. **Los datos se cargan una vez**
   - Permanecen en RAM del MagicBridge
   - Puedes programar múltiples chips sin recargar

3. **Comando W incluye verificación**
   - No necesitas ejecutar R después de W
   - Usa P si el chip es difícil de programar

## 🐛 Solución de Problemas

### Error: "bad magic number in..."
**Causa:** Versión de Python incompatible con .pyc

**Solución:**
- Instalar Python 3.11
- Verificar con: `python --version`

### Error: "No module named 'serial'"
**Solución:**
```bash
pip install pyserial
```

### MagicBridge no detectado
**Solución:**
1. Desconectar y reconectar USB
2. Esperar 10 segundos
3. Verificar drivers CDC (Windows)

## 📞 Soporte

Para problemas técnicos, revisar:
1. Documentación en `docs/`
2. Ejemplos en `examples/`
3. Contactar soporte técnico

---

**MagicBridge ELMOS Programmer**
Paquete Cliente v1.1
© 2026 LiCore
