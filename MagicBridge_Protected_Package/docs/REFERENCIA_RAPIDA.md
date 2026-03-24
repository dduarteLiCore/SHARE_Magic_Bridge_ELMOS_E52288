# Referencia Rápida - MagicBridge

## 🎯 Comandos Esenciales

### Cargar Datos
```bash
python3 1_cargar_datos_v3.py <archivo.hmf> <puerto> <PCB> <variante>
```

### Ejecutar Comando
```bash
python3 2_ejecutar_comando_v3.py <puerto> <comando>
```

---

## 📝 Tabla de Comandos

| Comando | PCB | Variante | Descripción | Ejemplo |
|---------|-----|----------|-------------|---------|
| W3d | 3 | D | Write PCB 3 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W3d` |
| W3e | 3 | E | Write PCB 3 variante E | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W3e` |
| W5d | 5 | D | Write PCB 5 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W5d` |
| W5e | 5 | E | Write PCB 5 variante E | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W5e` |
| W6d | 6 | D | Write PCB 6 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W6d` |
| W6e | 6 | E | Write PCB 6 variante E | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 W6e` |
| R3d | 3 | D | Read PCB 3 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 R3d` |
| R5d | 5 | D | Read PCB 5 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 R5d` |
| R6d | 6 | D | Read PCB 6 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 R6d` |
| P3d | 3 | D | Program PCB 3 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 P3d` |
| P5d | 5 | D | Program PCB 5 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 P5d` |
| P6d | 6 | D | Program PCB 6 variante D | `python3 2_ejecutar_comando_v3.py /dev/ttyACM0 P6d` |

---

## 🔧 Opciones Comunes

### Salida JSON
```bash
python3 1_cargar_datos_v3.py datos.hmf /dev/ttyACM0 5 D --json resultado.json
```

### Logging a Archivo
```bash
python3 1_cargar_datos_v3.py datos.hmf /dev/ttyACM0 5 D --log carga.log
```

### Modo Silencioso
```bash
python3 1_cargar_datos_v3.py datos.hmf /dev/ttyACM0 5 D --quiet
```

### Combinación (JSON + Log + Silencioso)
```bash
python3 1_cargar_datos_v3.py datos.hmf /dev/ttyACM0 5 D \
  --json result.json --log carga.log --quiet
```

---

## 🔍 Verificar Dispositivo

### Linux
```bash
# Ver dispositivo USB
lsusb | grep 1d50

# Ver puerto serial
ls /dev/ttyACM*

# Ver detalles
lsusb -v -d 1d50:6015 | grep -A 3 "iManufacturer"
```

### Windows (PowerShell)
```powershell
# Listar puertos COM
Get-PnpDevice | Where-Object {$_.FriendlyName -like "*ELMOS*"}
```

---

## ⚡ Flujos de Trabajo

### Flujo Básico
1. Cargar datos → 2. Programar (W)

### Flujo con Verificación
1. Cargar datos → 2. Programar (W) → 3. Leer (R)

### Flujo con Power Cycle
1. Cargar datos → 2. Program (P) - incluye write + power cycle + read

### Múltiples Chips
1. Cargar datos (1 vez) → 2. Programar (W) → 3. Cambiar chip → 4. Programar (W) → 5. Repetir...

---

## 📊 Códigos de Salida

| Código | Significado | Acción |
|--------|-------------|--------|
| 0 | Éxito | Continuar |
| 1 | Error argumentos | Revisar sintaxis |
| 2 | Error archivo HMF | Verificar archivo |
| 3 | Error conexión | Verificar puerto/cable |
| 4 | Error operación | Ver log de errores |

---

## 🐛 Soluciones Rápidas

| Problema | Solución |
|----------|----------|
| `No such file or directory: /dev/ttyACM0` | Verificar conexión USB, esperar 10s |
| `Permission denied` (Linux) | `sudo usermod -a -G dialout $USER` |
| `ModuleNotFoundError: serial` | `pip3 install pyserial` |
| Sin respuesta del MagicBridge | Desconectar/reconectar, esperar 10s |
| "Low memory available" | Normal, ignorar |

---

## 📋 Configuración de PCBs

| PCB | Dirección I2C | Comandos |
|-----|---------------|----------|
| 3   | 0x01          | W3d, W3e, R3d, R3e, P3d, P3e |
| 5   | 0x03          | W5d, W5e, R5d, R5e, P5d, P5e |
| 6   | 0x02          | W6d, W6e, R6d, R6e, P6d, P6e |

---

## 💡 Tips

- **Cargar una vez**: Los datos permanecen en RAM, puedes programar múltiples chips sin recargar
- **Usar comando P**: Para chips difíciles, usa P (Program) que incluye power cycle
- **JSON para automatización**: Usa `--json` y `--quiet` para integrar con sistemas
- **Logs para debugging**: Usa `--log` para guardar logs detallados
- **Códigos de salida**: Verifica `$?` (Linux) o `$LASTEXITCODE` (PowerShell) para automatización

---

## 📞 Ayuda

Ver ayuda completa:
```bash
python3 1_cargar_datos_v3.py --help
python3 2_ejecutar_comando_v3.py --help
```

---

**MagicBridge ELMOS Programmer**
Referencia Rápida v1.0
