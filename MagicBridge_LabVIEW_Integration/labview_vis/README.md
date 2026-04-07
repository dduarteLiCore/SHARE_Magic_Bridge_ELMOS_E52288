# LabVIEW VIs - Ejemplos para MagicBridge

Esta carpeta contiene pseudocódigo y especificaciones para crear archivos `.vi` de LabVIEW.

**Nota:** Los archivos `.vi` son binarios y requieren LabVIEW para ser creados. Aquí proporcionamos:
- Pseudocódigo detallado de cada VI
- Especificaciones de controles e indicadores
- Diagramas de flujo
- Configuración de System Exec

## Archivos Incluidos

1. **Ejemplo_1_DetectarPuerto.txt** - VI para detectar puerto COM automáticamente
2. **Ejemplo_2_CargarDatos.txt** - VI para cargar archivo HMF
3. **Ejemplo_3_ProgramarChip.txt** - VI para programar un chip
4. **Ejemplo_4_AplicacionProduccion.txt** - VI de aplicación completa de producción

## Cómo Usar Estos Ejemplos

### Opción 1: Crear VIs Manualmente en LabVIEW

1. Abre LabVIEW
2. Crea un nuevo VI (File → New VI)
3. Sigue el pseudocódigo en cada archivo .txt
4. Implementa los controles, indicadores y lógica descritos
5. Conecta los bloques según el diagrama de flujo

### Opción 2: Usar como Referencia

- Usa estos archivos como guía para entender la lógica
- Implementa tu propia solución personalizada
- Adapta a tus necesidades específicas de producción

## Estructura de Cada Ejemplo

Cada archivo .txt contiene:

```
EJEMPLO X: [Nombre]
====================

DESCRIPCIÓN:
  - Qué hace el VI
  - Entradas necesarias
  - Salidas generadas

FRONT PANEL (Controles e Indicadores):
  - Lista de controles con tipos
  - Lista de indicadores con tipos
  - Layout recomendado

BLOCK DIAGRAM (Diagrama de bloques):
  - Pseudocódigo paso a paso
  - Configuración de System Exec
  - Manejo de errores
  - Parsing de JSON

EJEMPLO DE USO:
  - Cómo ejecutar el VI
  - Valores de prueba
  - Resultados esperados
```

## Métodos de Integración Soportados

### 1. System Exec (Recomendado) ⭐

**Ventajas:**
- Compatible con todas las versiones de LabVIEW
- No requiere toolkits adicionales
- Fácil debugging
- Usa scripts protegidos (.pyc) a través de wrappers .bat

**Configuración:**
```
System Exec.vi
├── Command Line: C:\MagicBridge\bin\magicbridge-load.bat [args]
├── Working Directory: C:\MagicBridge\
├── Wait Until Completion: TRUE
├── Standard Output: String output
└── Exit Code: Integer (0 = success)
```

### 2. Python Node

**Requisitos:**
- LabVIEW 2018 o superior
- Python Integration Toolkit
- Python 3.11 instalado

**Ventajas:**
- Llamadas directas a funciones Python
- Paso de datos nativo
- No requiere parsing de JSON

### 3. DLL Wrapper

**Requisitos:**
- Código C/C++
- Compilador
- Conocimientos avanzados

**Ventajas:**
- Máxima integración
- Mejor rendimiento
- Control total

## Scripts Python Disponibles

Todos los scripts están en `../bin/` (o `C:\MagicBridge\bin\` si se copió):

### Wrappers Principales (usar estos desde LabVIEW)
- `magicbridge-load.bat` - Cargar datos HMF (Windows)
- `magicbridge-cmd.bat` - Ejecutar comandos (Windows)
- `magicbridge-load` - Cargar datos HMF (Linux/macOS)
- `magicbridge-cmd` - Ejecutar comandos (Linux/macOS)

### Scripts Auxiliares
- `detect_port.py` - Detectar puerto COM automáticamente
- `magicbridge_api.py` - API wrapper con JSON output

### Bytecode Compilado (no llamar directamente)
- `1_cargar_datos_v3.cpython-311.pyc`
- `2_ejecutar_comando_v3.cpython-311.pyc`
- `hmf_loader.cpython-311.pyc`

## Ejemplos Rápidos de Llamadas System Exec

### Detectar Puerto COM
```
Command: python C:\MagicBridge\bin\detect_port.py
Output: "COM3" o "NOT_FOUND"
```

### Cargar Datos HMF
```
Command: C:\MagicBridge\bin\magicbridge-load.bat C:\Data\file.hmf COM3 5 D --json C:\Temp\result.json
Output: JSON con resultados
```

### Programar Chip
```
Command: C:\MagicBridge\bin\magicbridge-cmd.bat COM3 W5d --json C:\Temp\write.json
Output: JSON con resultados
```

### Verificar Chip
```
Command: C:\MagicBridge\bin\magicbridge-cmd.bat COM3 R5d --json C:\Temp\read.json
Output: JSON con resultados
```

## Parsing de JSON en LabVIEW

### Método 1: Unflatten From JSON (LabVIEW 2013+)
```
JSON String → Unflatten From JSON → Cluster
```

### Método 2: Manual con Match Pattern
```
JSON String → Match Pattern → Extract values
```

### Método 3: VI Package Manager (JKI JSON)
```
Instalar: JKI JSON Toolkit
Usar: Parse JSON.vi
```

## Estructura de JSON Retornados

### Carga de Datos (LOAD)
```json
{
  "success": true,
  "command": "LOAD",
  "port": "COM3",
  "timestamp": "2026-03-23T16:30:00",
  "duration": 6.7,
  "total_entries": 759,
  "successful": 759,
  "failed": 0
}
```

### Programación (WRITE)
```json
{
  "success": true,
  "command": "W5d",
  "port": "COM3",
  "pcb": 5,
  "variant": "D",
  "timestamp": "2026-03-23T16:31:00",
  "duration": 32.5,
  "crc": "A5B3"
}
```

### Lectura (READ)
```json
{
  "success": true,
  "command": "R5d",
  "port": "COM3",
  "pcb": 5,
  "variant": "D",
  "timestamp": "2026-03-23T16:32:00",
  "duration": 30.2,
  "data_count": 759,
  "crc": "A5B3"
}
```

## Códigos de Error

| Exit Code | Significado |
|-----------|-------------|
| 0 | Éxito |
| 1 | Error de argumentos |
| 2 | Error de conexión serial |
| 3 | Error de timeout |
| 4 | Error de validación/CRC |

## Tips para Desarrollo en LabVIEW

### Tip 1: Usar Rutas Absolutas
Siempre usa rutas absolutas en System Exec para evitar problemas.

**Correcto:**
```
C:\MagicBridge\bin\magicbridge-load.bat C:\Data\file.hmf COM3 5 D
```

**Incorrecto:**
```
..\bin\magicbridge-load.bat ..\data\file.hmf COM3 5 D
```

### Tip 2: Verificar Exit Code
Siempre verifica el código de salida antes de procesar la salida.

```
If (Exit Code = 0) then
  Parse JSON output
  Display results
Else
  Display error message
  Log error
End If
```

### Tip 3: Usar Timeouts Adecuados
- Detección de puerto: 5 segundos
- Carga HMF: 60 segundos
- Programación: 120 segundos
- Lectura: 120 segundos

### Tip 4: Logging
Implementa logging detallado para troubleshooting:
- Timestamp de cada operación
- Comandos ejecutados
- Exit codes
- Mensajes de error
- Resultados

### Tip 5: UI/UX
Proporciona feedback visual al usuario:
- Indicadores LED para status
- Progress bar para operaciones largas
- Mensajes de status
- Contadores de chips programados/fallidos

## Rendimiento Esperado

**Operaciones individuales:**
- Detectar puerto: <1 segundo
- Cargar HMF: ~7 segundos (760 registros)
- Programar chip: ~30-40 segundos
- Verificar chip: ~30-40 segundos

**Throughput de producción:**
- Con manejo manual: 7-10 chips/minuto
- Con robot: 10-12 chips/minuto

**Carga HMF:**
- Una vez al inicio del turno
- Programar múltiples chips sin recargar

## Soporte y Referencias

**Documentación:**
- `../docs/INTEGRACION_LABVIEW.md` - Guía técnica completa
- `../examples/EJEMPLO_PASO_A_PASO.md` - Tutorial detallado

**Scripts:**
- `../bin/` - Todos los scripts Python y wrappers

## Próximos Pasos

1. Lee los archivos .txt en orden (Ejemplo_1 → Ejemplo_4)
2. Implementa cada VI en LabVIEW siguiendo el pseudocódigo
3. Prueba cada VI individualmente
4. Integra en tu aplicación de producción
5. Personaliza según tus necesidades

---

**Nota:** Estos ejemplos son pseudocódigo. Debes implementarlos en LabVIEW según tu versión y requisitos específicos.

Para crear archivos .vi reales, necesitas LabVIEW instalado. Contacta al equipo de desarrollo si necesitas archivos .vi pre-construidos.
