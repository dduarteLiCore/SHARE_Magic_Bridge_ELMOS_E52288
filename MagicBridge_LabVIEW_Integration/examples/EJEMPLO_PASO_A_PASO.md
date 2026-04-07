# Ejemplo Paso a Paso: Integración LabVIEW + MagicBridge

## 📋 Objetivo

Crear una aplicación LabVIEW que programe chips ELMOS usando MagicBridge.

## 🎯 Resultado Final

Una aplicación LabVIEW que:
1. Detecta automáticamente el puerto COM del MagicBridge
2. Carga datos HMF una vez
3. Programa múltiples chips en loop
4. Muestra estadísticas en tiempo real

---

## ⚙️ Configuración Inicial

### Paso 1: Instalar Software Requerido

1. **Python 3.11**
   - Descargar: https://www.python.org/downloads/
   - ✅ IMPORTANTE: Marcar "Add Python to PATH"
   
2. **pyserial**
   ```cmd
   pip install pyserial
   ```

3. **Verificar instalación**
   ```cmd
   python --version
   python -c "import serial; print('pyserial OK')"
   ```

### Paso 2: Copiar Archivos MagicBridge

1. Crear estructura de carpetas:
   ```
   C:\MagicBridge\
   ├── bin\                  (wrappers + scripts compilados .pyc)
   ├── helpers\              (scripts helper)
   └── data\                 (archivos HMF)
   ```

2. Copiar archivos del paquete protegido:
   ```cmd
   xcopy MagicBridge_Protected_Package\bin C:\MagicBridge\bin\ /E /I
   xcopy MagicBridge_LabVIEW_Integration\python_wrappers C:\MagicBridge\helpers\ /E /I
   ```

3. Verificar estructura:
   ```cmd
   dir C:\MagicBridge\bin
   dir C:\MagicBridge\helpers
   ```

---

## 🔨 Ejemplo 1: Detección del Puerto COM

### Objetivo
Crear un VI que detecte automáticamente el puerto COM del MagicBridge.

### Pasos en LabVIEW

1. **Crear nuevo VI:** `DetectarMagicBridge.vi`

2. **Panel Frontal:**
   - Botón: "Detectar" (Boolean)
   - Indicador: "Puerto COM" (String)
   - LED: "Encontrado" (Boolean)

3. **Diagrama de Bloques:**

```
[Botón Detectar] ──┐
                   │
                   ▼
              [System Exec.vi]
                   │
         ┌─────────┴─────────┐
         │  command line:    │
         │  python C:\...    │
         │  detect_port.py   │
         │                   │
         │  standard output: │
         │  ──> "COM3"       │
         └─────────┬─────────┘
                   │
                   ▼
           [String Length > 0?]
                   │
         ┌─────────┴─────────┐
         │ True      False   │
         ▼           ▼        
    [Encontrado] [No Encontrado]
         │           │
         └───────────┴────> [Puerto COM]
```

4. **Configuración de System Exec.vi:**
   - command line: `python C:\MagicBridge\helpers\detect_port.py`
   - wait until completion: TRUE
   - timeout (ms): 10000

5. **Código de decisión:**
   ```
   IF Length(output) > 0 AND output != "NOT_FOUND" THEN
       Puerto_COM = output
       Encontrado = TRUE
   ELSE
       Puerto_COM = "No encontrado"
       Encontrado = FALSE
   END IF
   ```

### Prueba

1. Conectar MagicBridge
2. Ejecutar el VI
3. Presionar "Detectar"
4. Debe mostrar "COM3" (o el puerto correspondiente)

---

## 🔨 Ejemplo 2: Cargar Datos HMF

### Objetivo
Crear un VI que cargue datos HMF al MagicBridge.

### Pasos en LabVIEW

1. **Crear nuevo VI:** `CargarDatosHMF.vi`

2. **Panel Frontal - Controles:**
   - Path: "Archivo HMF" (File Path)
   - String: "Puerto COM" (String, default: "COM3")
   - Numeric: "PCB" (I32, Range: 3-6)
   - Enum: "Variante" (Enum: D, E)
   - Boolean: "Cargar" (Botón)

3. **Panel Frontal - Indicadores:**
   - Boolean: "Éxito" (LED)
   - String: "Mensaje" (String Indicator)
   - String: "Salida Completa" (String Indicator)

4. **Diagrama de Bloques:**

```
[Archivo HMF Path] ──────┐
[Puerto COM] ────────────┤
[PCB] ───────────────────┤──> [Build Command String]
[Variante] ──────────────┤         │
[Botón Cargar] ──────────┘         │
                                   ▼
                          [System Exec.vi]
                                   │
                     ┌─────────────┴────────────┐
                     │                          │
                     ▼                          ▼
            [return code = 0?]           [standard output]
                     │                          │
            ┌────────┴───┐                      │
            │ True     False                    │
            ▼            ▼                      │
        [Éxito]       [Error]                   │
            │            │                      │
            └────────────┴──────────────────────┴──> [Mensaje]
```

5. **Build Command String (Formula Node o Concatenate Strings):**
   ```
   comando = "C:\MagicBridge\bin\magicbridge-load.bat " + 
             Path_to_String(archivo_hmf) + " " + 
             puerto_com + " " + 
             Number_to_String(pcb) + " " + 
             variante + " --quiet"
   ```

6. **Parsear resultado:**
   ```
   IF return_code == 0 THEN
       Éxito = TRUE
       Mensaje = "Datos cargados exitosamente"
   ELSE
       Éxito = FALSE
       CASE return_code:
           1: Mensaje = "Error en argumentos"
           2: Mensaje = "Archivo HMF no válido"
           3: Mensaje = "Error de conexión - Verificar puerto COM"
           4: Mensaje = "Error al cargar datos"
           Default: Mensaje = "Error desconocido"
       END CASE
   END IF
   ```

### Prueba

1. Seleccionar archivo HMF
2. Configurar: COM3, PCB 5, Variante D
3. Presionar "Cargar"
4. Debe mostrar "Éxito" en verde y mensaje "Datos cargados exitosamente"

---

## 🔨 Ejemplo 3: Programar un Chip

### Objetivo
Crear un VI que programe un chip usando los datos previamente cargados.

### Pasos en LabVIEW

1. **Crear nuevo VI:** `ProgramarChip.vi`

2. **Panel Frontal - Controles:**
   - String: "Puerto COM"
   - String: "Comando" (ej: "W5d", "R3e", "P6d")
   - Boolean: "Ejecutar"

3. **Panel Frontal - Indicadores:**
   - Boolean: "Éxito"
   - String: "Mensaje"
   - Numeric: "Tiempo (ms)"

4. **Diagrama de Bloques:**

```
[Puerto COM] ──────┐
[Comando] ─────────┤
[Ejecutar] ────────┘
        │
        ▼
   [Get Tick Count] ────┐ (inicio)
        │               │
        ▼               │
 [Build Command]        │
        │               │
        ▼               │
 [System Exec.vi]       │
        │               │
        ▼               │
 [Get Tick Count] ──────┘ (fin)
        │
        ▼
 [Subtract] ──> [Tiempo (ms)]
        │
        ▼
 [Parse Result] ──> [Éxito, Mensaje]
```

5. **Build Command:**
   ```
   comando = "C:\MagicBridge\bin\magicbridge-cmd.bat " + 
             puerto_com + " " + 
             comando + " --quiet"
   ```

6. **Calcular tiempo:**
   ```
   tiempo_ms = tick_final - tick_inicial
   ```

### Prueba

1. Configurar: COM3, Comando "W5d"
2. Presionar "Ejecutar"
3. Debe mostrar "Éxito" y tiempo ~5000-8000 ms

---

## 🔨 Ejemplo 4: Aplicación Completa de Producción

### Objetivo
Aplicación completa con loop de producción, estadísticas y logging.

### Diseño de la Aplicación

```
┌─────────────────────────────────────────────────────┐
│              INICIALIZACIÓN                         │
│  1. Detectar Puerto COM                             │
│  2. Cargar Datos HMF                                │
│  3. Verificar Comunicación                          │
└───────────────────┬─────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────┐
│           LOOP DE PRODUCCIÓN                        │
│  ┌───────────────────────────────────┐              │
│  │ 1. Esperar Chip Nuevo             │              │
│  │ 2. Programar Chip (W5d)           │              │
│  │ 3. Verificar Resultado            │              │
│  │ 4. Actualizar Estadísticas        │              │
│  │ 5. Guardar Log                    │              │
│  │ 6. Continuar? ─────────────────┐  │              │
│  └───────────┬────────────────────┘  │              │
│              └───────────────────────┘              │
└─────────────────────┬───────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────┐
│              FINALIZACIÓN                           │
│  1. Mostrar Resumen Final                           │
│  2. Guardar Reporte                                 │
│  3. Cerrar Aplicación                               │
└─────────────────────────────────────────────────────┘
```

### Panel Frontal

```
╔═══════════════════════════════════════════════════════════╗
║  MagicBridge - Producción ELMOS        [Minimizar] [X]    ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  🔧 CONFIGURACIÓN                                         ║
║  ┌─────────────────────────────────────────────────────┐  ║
║  │ Archivo HMF: [C:\Data\prod.hmf    ] [Browse...]     │  ║
║  │ Puerto COM:  [COM3 ▼]  [Detectar Auto]              │  ║
║  │ PCB:         [5 ▼]      Variante: [D ▼]             │  ║
║  │                                                     │  ║
║  │ [✓] Cargado  [✓] Conectado  [ ] En Producción       │  ║
║  └─────────────────────────────────────────────────────┘  ║
║                                                           ║
║  📊 ESTADÍSTICAS                                          ║
║  ┌─────────────────────────────────────────────────────┐  ║
║  │ Chips Programados:  [ 245 ]  ████████████░░░ 89%    │  ║
║  │ Chips Error:        [  30 ]                         │  ║
║  │ Tiempo Promedio:    [ 7.8s]                         │  ║
║  │ Tasa de Éxito:      [ 89% ]                         │  ║
║  │ Tiempo Total:       [ 2h 15m ]                      │  ║
║  └─────────────────────────────────────────────────────┘  ║
║                                                           ║
║  🔄 CHIP ACTUAL                                           ║
║  ┌─────────────────────────────────────────────────────┐  ║
║  │ ID: [CHIP-245]      Estado: ●●● PROGRAMANDO         │  ║
║  │ Progreso: ████████████████████████░░ 90%            │  ║
║  │ Tiempo: [ 7.1s ]                                    │  ║
║  └─────────────────────────────────────────────────────┘  ║
║                                                           ║
║  📝 LOG                                                   ║
║  ┌─────────────────────────────────────────────────────┐  ║
║  │ [15:30:22] CHIP-243: OK (7.2s)                      │  ║
║  │ [15:30:35] CHIP-244: OK (7.5s)                      │  ║
║  │ [15:30:48] CHIP-245: Programando...                 │  ║
║  │                                                     │  ║
║  └─────────────────────────────────────────────────────┘  ║
║                                                           ║
║  [▶ Iniciar Producción]  [⏸ Pausar]  [⏹ Detener]          ║
╚═══════════════════════════════════════════════════════════╝
```

### Estructura del VI Principal

**Estado: Inicialización**
```
1. Detectar Puerto COM
   IF NOT Found THEN
       Mostrar Error y Salir
   END IF

2. Cargar Datos HMF
   IF NOT Success THEN
       Mostrar Error y Salir
   END IF

3. Test de Comunicación
   Ejecutar Comando "R5d" (solo lectura)
   IF NOT Success THEN
       Advertencia pero continuar
   END IF
```

**Estado: Loop de Producción**
```
WHILE NOT Detener DO
    1. Esperar Chip Nuevo
       Mostrar: "Coloque chip y presione CONTINUAR"
       Wait for Button Click OR Timeout
       
    2. Incrementar Contador
       chip_id = "CHIP-" + String(contador)
       
    3. Timestamp Inicio
       t_start = Get Tick Count()
       
    4. Programar
       resultado = ProgramarChip(puerto, "W5d")
       
    5. Timestamp Fin
       t_end = Get Tick Count()
       tiempo_ms = t_end - t_start
       
    6. Actualizar Estadísticas
       IF resultado == Success THEN
           contador_ok++
           suma_tiempos += tiempo_ms
       ELSE
           contador_error++
       END IF
       
       tasa_exito = (contador_ok / (contador_ok + contador_error)) * 100
       tiempo_promedio = suma_tiempos / contador_ok
       
    7. Actualizar UI
       Actualizar Gráficos
       Actualizar Indicadores
       Agregar Línea a Log
       
    8. Guardar en Archivo
       Append to File: chip_id, resultado, tiempo_ms, timestamp
END WHILE
```

**Estado: Finalización**
```
1. Generar Resumen
   total_chips = contador_ok + contador_error
   duracion_total = tiempo_final - tiempo_inicial
   
2. Mostrar Diálogo
   "Producción Finalizada"
   "Total chips: " + total_chips
   "Éxito: " + contador_ok + " (" + tasa_exito + "%)"
   "Errores: " + contador_error
   
3. Guardar Reporte
   Guardar estadísticas en C:\MagicBridge\logs\reporte_YYYYMMDD.txt
   
4. Cerrar
   Close VI
```

### Variables Globales

Crear `MagicBridge_Globals.vi` con:
- `Puerto_COM` (String)
- `Datos_Cargados` (Boolean)
- `Archivo_HMF_Actual` (Path)
- `PCB_Configurado` (I32)
- `Variante_Configurada` (String)

---

## 💡 Tips de Implementación

### Tip 1: Usar State Machine

Implementar el VI principal como máquina de estados:
```
Estados:
- Idle
- Inicializando
- EsperandoChip
- Programando
- Verificando
- Logging
- Error
- Finalizando
```

### Tip 2: Manejo de Timeouts

```
System Exec con Timeout:
- Cargar Datos: 300000 ms (5 min)
- Programar Chip: 60000 ms (1 min)
- Leer Chip: 30000 ms (30 seg)
```

### Tip 3: Logging Robusto

```
Formato CSV:
timestamp,chip_id,comando,resultado,tiempo_ms,error_msg

Ejemplo:
2026-03-23 15:30:22,CHIP-001,W5d,OK,7200,
2026-03-23 15:30:35,CHIP-002,W5d,ERROR,12000,Timeout
```

### Tip 4: Reintentos Automáticos

```
IF Resultado == Error THEN
    IF reintentos < 3 THEN
        Esperar 5 segundos
        Reintentar Programación
        reintentos++
    ELSE
        Reportar Error Final
        Continuar con Siguiente Chip
    END IF
END IF
```

---

## 🐛 Debugging

### Ver Salida de Python en Consola

Durante desarrollo, quitar `--quiet` para ver output completo:
```
comando = "python ... W5d"  // Sin --quiet
```

Ver en "standard output" del System Exec.vi

### Modo Debug en LabVIEW

Agregar indicadores para ver:
- Comando completo generado
- Return code
- Standard output
- Standard error
- Timestamp de cada paso

### Log Detallado

Agregar más información al log:
```
timestamp,chip_id,comando,resultado,tiempo_ms,return_code,output
```

---

## ✅ Checklist de Pruebas

- [ ] Detección automática de puerto funciona
- [ ] Carga de datos exitosa (archivo válido)
- [ ] Error manejado correctamente (archivo inválido)
- [ ] Programación de chip exitosa
- [ ] Manejo de errores de programación
- [ ] Estadísticas actualizan correctamente
- [ ] Log se guarda correctamente
- [ ] Reintentos funcionan
- [ ] Aplicación no se cuelga en errores
- [ ] UI responde durante operaciones largas
- [ ] Producción de 100 chips sin problemas

---

**MagicBridge + LabVIEW**
Ejemplo Paso a Paso v1.0
© 2026 LiCore
