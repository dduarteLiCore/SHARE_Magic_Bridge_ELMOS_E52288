# Ejemplos de Uso - MagicBridge

Esta carpeta contiene ejemplos prácticos de uso del MagicBridge.

## 📁 Archivos Disponibles

### Scripts Bash (Linux/macOS)

1. **[ejemplo_basico.sh](ejemplo_basico.sh)** - Programación básica de un chip
   ```bash
   ./ejemplo_basico.sh datos.hmf /dev/ttyACM0
   ```

2. **[ejemplo_multiple.sh](ejemplo_multiple.sh)** - Programación de múltiples chips
   ```bash
   ./ejemplo_multiple.sh datos.hmf /dev/ttyACM0 5
   ```

### Scripts Windows

3. **[ejemplo_basico.bat](ejemplo_basico.bat)** - Programación básica (Windows)
   ```cmd
   ejemplo_basico.bat datos.hmf COM3
   ```

### Scripts Python

4. **[ejemplo_json.py](ejemplo_json.py)** - Integración con salida JSON
   ```bash
   python3 ejemplo_json.py
   ```

## 🚀 Uso Rápido

### Linux/macOS

```bash
# Hacer scripts ejecutables (primera vez)
chmod +x *.sh

# Programar un chip
./ejemplo_basico.sh /ruta/a/datos.hmf /dev/ttyACM0

# Programar 5 chips
./ejemplo_multiple.sh /ruta/a/datos.hmf /dev/ttyACM0 5
```

### Windows

```cmd
REM Programar un chip
ejemplo_basico.bat C:\ruta\a\datos.hmf COM3
```

### Python (cualquier OS)

```bash
# Editar variables en ejemplo_json.py primero
python3 ejemplo_json.py
```

## 📝 Personalización

Todos los scripts tienen variables al inicio que puedes modificar:

```bash
# En scripts bash/bat
PCB=5          # Cambiar a 3, 5 o 6
VARIANTE=D     # Cambiar a D o E

# En ejemplo_json.py
ARCHIVO_HMF = "datos.hmf"
PUERTO = "/dev/ttyACM0"  # o "COM3" en Windows
PCB = 5
VARIANTE = "D"
```

## 💡 Tips

- **Primero prueba manualmente**: Antes de usar scripts automatizados, prueba los comandos manualmente
- **Revisa los logs**: Los scripts muestran mensajes detallados de lo que ocurre
- **JSON para producción**: Usa `ejemplo_json.py` como base para sistemas automatizados
- **Múltiples chips**: `ejemplo_multiple.sh` es ideal para producción en masa

## 🔧 Solución de Problemas

### "Permission denied" al ejecutar .sh

```bash
chmod +x ejemplo_basico.sh
./ejemplo_basico.sh ...
```

### Error "python3: command not found" (Windows)

Usar `python` en lugar de `python3`:
```cmd
python 1_cargar_datos_v3.py ...
```

### Scripts no encuentran los archivos Python

Los scripts asumen esta estructura:
```
MagicBridge_Client_Package/
├── scripts/      <- Scripts Python aquí
└── examples/     <- Scripts de ejemplo aquí
```

Si moviste archivos, actualiza las rutas en los scripts.

---

**MagicBridge ELMOS Programmer**
Ejemplos v1.0
