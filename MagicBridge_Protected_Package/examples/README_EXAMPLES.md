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

4. **[ejemplo_multiple.bat](ejemplo_multiple.bat)** - Múltiples chips (Windows)
   ```cmd
   ejemplo_multiple.bat datos.hmf COM3 5
   ```

### Scripts Python

5. **[ejemplo_json.py](ejemplo_json.py)** - Integración con salida JSON
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

REM Programar 5 chips
ejemplo_multiple.bat C:\ruta\a\datos.hmf COM3 5
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
- **Múltiples chips**: `ejemplo_multiple.bat` / `ejemplo_multiple.sh` son ideales para producción en masa

## 🔧 Solución de Problemas

### "Permission denied" al ejecutar .sh

```bash
chmod +x ejemplo_basico.sh
./ejemplo_basico.sh ...
```

### Error "python: command not found" (Linux)

Usar `python3` en lugar de `python`:
```bash
python3 ejemplo_json.py
```

### Cómo funcionan los scripts internamente

Los scripts `.bat` y `.sh` de esta carpeta llaman a los wrappers en `../bin/`:
```
examples/ejemplo_basico.bat
    → bin\magicbridge-load.bat   (carga datos HMF)
    → bin\magicbridge-cmd.bat    (programa el chip)
```

Las rutas se resuelven automáticamente — los scripts funcionan independientemente
de desde qué directorio se ejecuten.

---

**MagicBridge ELMOS Programmer**
Ejemplos v1.1
