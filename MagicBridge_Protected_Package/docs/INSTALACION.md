# Guía de Instalación - MagicBridge

## 🖥️ Instalación en Linux

### 1. Instalar Python 3

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# Verificar instalación
python3 --version
```

### 2. Instalar pyserial

```bash
pip3 install pyserial

# O con sudo si es necesario
sudo pip3 install pyserial
```

### 3. Configurar Permisos de Puerto Serial

```bash
# Agregar usuario al grupo dialout
sudo usermod -a -G dialout $USER

# Cerrar sesión y volver a entrar para aplicar cambios
# O ejecutar:
newgrp dialout
```

### 4. Verificar MagicBridge

```bash
# Conectar MagicBridge vía USB
# Esperar 10 segundos

# Verificar dispositivo USB
lsusb | grep 1d50
# Debe mostrar: ID 1d50:6015 OpenMoko, Inc. LiCore ELMOS Programmer

# Verificar puerto serial
ls /dev/ttyACM*
# Debe mostrar: /dev/ttyACM0 (o similar)
```

### 5. Hacer Scripts Ejecutables

```bash
cd bin
chmod +x magicbridge-load magicbridge-cmd
```

### 6. Prueba Rápida

```bash
# Ver ayuda
./bin/magicbridge-load --help
./bin/magicbridge-cmd --help
```

---

## 🪟 Instalación en Windows

### 1. Instalar Python 3

1. Descargar Python desde: https://www.python.org/downloads/
2. **IMPORTANTE:** Marcar "Add Python to PATH" durante instalación
3. Instalar

### 2. Verificar Instalación de Python

Abrir **PowerShell** o **CMD**:

```cmd
python --version
```

Si no funciona, intentar:
```cmd
python3 --version
```

### 3. Instalar pyserial

```cmd
pip install pyserial
```

O si no funciona:
```cmd
python -m pip install pyserial
```

### 4. Verificar MagicBridge

1. Conectar MagicBridge vía USB
2. Esperar 10 segundos
3. Abrir **Administrador de dispositivos** (Win+X → Administrador de dispositivos)
4. Expandir "Puertos (COM y LPT)"
5. Buscar: **"LiCore ELMOS Programmer (COMx)"**
6. Anotar el número de puerto (ej: COM3)

### 5. Prueba Rápida

Abrir PowerShell en la carpeta del paquete:

```powershell
# Ver ayuda
bin\magicbridge-load.bat --help
bin\magicbridge-cmd.bat --help
```

---

## 🍎 Instalación en macOS

### 1. Instalar Python 3

```bash
# Si tienes Homebrew instalado
brew install python3

# Verificar
python3 --version
```

### 2. Instalar pyserial

```bash
pip3 install pyserial
```

### 3. Verificar MagicBridge

```bash
# Conectar MagicBridge
# Esperar 10 segundos

# Verificar USB
system_profiler SPUSBDataType | grep -A 5 "ELMOS"

# Verificar puerto
ls /dev/cu.usbmodem*
```

### 4. Hacer Scripts Ejecutables

```bash
cd bin
chmod +x magicbridge-load magicbridge-cmd
```

### 5. Prueba Rápida

```bash
./bin/magicbridge-load --help
./bin/magicbridge-cmd --help
```

---

## ✅ Verificación de Instalación Completa

### Test de Conexión

**Linux/macOS:**
```bash
# Prueba básica de detección de puerto
python3 -c "import serial.tools.list_ports; \
  ports = list(serial.tools.list_ports.comports()); \
  print('Puertos encontrados:', [p.device for p in ports])"
```

**Windows:**
```powershell
# Verificar en Device Manager
Get-PnpDevice -Class Ports | Where-Object {$_.FriendlyName -like "*ELMOS*"}
```

### Test con MagicBridge

**Linux/macOS:**
```bash
# Probar comando de ayuda
./bin/magicbridge-load --help

# Si sale ayuda, instalación OK
```

**Windows:**
```cmd
REM Probar comando de ayuda
bin\magicbridge-load.bat --help

REM Si sale ayuda, instalación OK
```

---

## 🔧 Solución de Problemas de Instalación

### Linux: "ModuleNotFoundError: No module named 'serial'"

**Solución:**
```bash
pip3 install --user pyserial

# Verificar
python3 -c "import serial; print('pyserial OK')"
```

### Linux: "Permission denied" al ejecutar scripts

**Solución:**
```bash
# Hacer ejecutables
chmod +x bin/magicbridge-*

# O ejecutar con python directamente
python3 bin/magicbridge-load archivo.hmf /dev/ttyACM0 5 D
```

### Windows: "Python no se reconoce como comando"

**Solución:**
1. Reinstalar Python marcando "Add to PATH"
2. O agregar Python manualmente al PATH:
   - Panel de Control → Sistema → Variables de entorno
   - Editar PATH y agregar: `C:\Python3x\` y `C:\Python3x\Scripts\`
3. Reiniciar PowerShell/CMD

### Windows: Scripts .bat no funcionan

**Solución:**
```cmd
REM Ejecutar directamente con Python
python bin\1_cargar_datos_v3.cpython-311.pyc archivo.hmf COM3 5 D
```

### macOS: "Permission denied"

**Solución:**
```bash
# Instalar pyserial con permisos
sudo pip3 install pyserial

# Hacer ejecutables
chmod +x bin/magicbridge-*
```

### Cualquier OS: "Permission denied" al acceder al puerto

**Linux/macOS:**
```bash
# Solución temporal
sudo chmod 666 /dev/ttyACM0

# Solución permanente
sudo usermod -a -G dialout $USER
# Cerrar sesión y volver a entrar
```

**Windows:**
- Ejecutar PowerShell/CMD como Administrador
- O verificar que drivers CDC estén instalados

### Error: "bad magic number" en archivos .pyc

**Causa:** Versión de Python incompatible con bytecode

**Solución:**
```bash
# Verificar versión de Python
python3 --version

# Los archivos .pyc requieren Python 3.11
# Si tienes otra versión, instalar Python 3.11
```

---

## 📦 Requisitos del Sistema

| Componente | Requisito Mínimo |
|------------|------------------|
| Python | 3.8 o superior (para bytecode .pyc) |
| pyserial | 3.5 o superior |
| RAM | 512 MB |
| Disco | 50 MB libres |
| USB | Puerto USB 2.0 o superior |
| SO | Linux (kernel 4.x+), Windows 10+, macOS 10.13+ |

**Nota:** Este paquete usa bytecode Python (.pyc) compilado con Python 3.11. Requiere Python 3.11 instalado.

---

## 🚀 Siguiente Paso

### Para Usuarios (Recomendado)

Usar los **wrappers** que simplifican el uso:

**Linux/macOS:**
```bash
./bin/magicbridge-load archivo.hmf /dev/ttyACM0 5 D
./bin/magicbridge-cmd /dev/ttyACM0 W5d
```

**Windows:**
```cmd
bin\magicbridge-load.bat archivo.hmf COM3 5 D
bin\magicbridge-cmd.bat COM3 W5d
```

### Para Automatización (Avanzado)

Llamar los archivos .pyc directamente:

```bash
# Linux/macOS
python3 bin/1_cargar_datos_v3.cpython-311.pyc archivo.hmf /dev/ttyACM0 5 D

# Windows
python bin\1_cargar_datos_v3.cpython-311.pyc archivo.hmf COM3 5 D
```

---

## 📚 Documentación Adicional

Después de completar la instalación:

- Ver [README.md](../README.md) para uso básico
- Ver [REFERENCIA_RAPIDA.md](REFERENCIA_RAPIDA.md) para comandos
- Ver carpeta [examples/](../examples/) para ejemplos prácticos

---

## 💡 Tips de Instalación

### Tip 1: Verificar todo antes de empezar
```bash
# Verificar Python
python3 --version

# Verificar pyserial
python3 -c "import serial; print(f'pyserial {serial.__version__}')"

# Verificar MagicBridge
lsusb | grep 1d50  # Linux/macOS
```

### Tip 2: Crear alias (Linux/macOS)
```bash
# Agregar a ~/.bashrc o ~/.zshrc
alias mb-load='~/MagicBridge/bin/magicbridge-load'
alias mb-cmd='~/MagicBridge/bin/magicbridge-cmd'

# Usar:
mb-load archivo.hmf /dev/ttyACM0 5 D
mb-cmd /dev/ttyACM0 W5d
```

### Tip 3: Agregar al PATH (Windows)
```cmd
REM Agregar carpeta bin al PATH
set PATH=%PATH%;C:\MagicBridge\bin

REM Usar:
magicbridge-load.bat archivo.hmf COM3 5 D
```

---

## 🔐 Notas de Seguridad

1. **No modificar archivos .pyc** - Están compilados y no son editables
2. **Mantener backups** de archivos HMF originales
3. **Verificar siempre** después de programar
4. **No compartir** archivos .pyc entre diferentes versiones de Python

---

**MagicBridge ELMOS Programmer**
Guía de Instalación - Paquete Protegido v1.0
© 2026 LiCore
