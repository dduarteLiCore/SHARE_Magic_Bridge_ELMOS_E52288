@echo off
REM
REM Ejemplo Básico para Windows: Programar un chip ELMOS PCB 5 Variante D
REM
REM Uso: ejemplo_basico.bat <archivo.hmf> <puerto>
REM Ejemplo: ejemplo_basico.bat datos.hmf COM3
REM

if "%~2"=="" (
    echo Error: Faltan argumentos
    echo.
    echo Uso: %~nx0 ^<archivo.hmf^> ^<puerto^>
    echo.
    echo Ejemplo: %~nx0 datos.hmf COM3
    exit /b 1
)

set ARCHIVO_HMF=%~1
set PUERTO=%~2
set PCB=5
set VARIANTE=D

echo ========================================================
echo    MagicBridge - Programacion de Chip ELMOS
echo ========================================================
echo.
echo Configuracion:
echo    Archivo HMF: %ARCHIVO_HMF%
echo    Puerto:      %PUERTO%
echo    PCB:         %PCB%
echo    Variante:    %VARIANTE%
echo.

REM Paso 1: Cargar datos
echo ========================================================
echo PASO 1: Cargando datos HMF al MagicBridge...
echo ========================================================
cd ..\scripts
python 1_cargar_datos_v3.py "%ARCHIVO_HMF%" %PUERTO% %PCB% %VARIANTE%

if %ERRORLEVEL% NEQ 0 (
    echo Error al cargar datos
    exit /b 1
)

echo OK: Datos cargados exitosamente
echo.

REM Paso 2: Programar
echo ========================================================
echo PASO 2: Programando chip...
echo ========================================================
python 2_ejecutar_comando_v3.py %PUERTO% W%PCB%d

if %ERRORLEVEL% NEQ 0 (
    echo Error al programar chip
    exit /b 1
)

echo.
echo ========================================================
echo       PROGRAMACION COMPLETADA CON EXITO
echo ========================================================
