@echo off
REM ========================================================
REM Ejemplo Básico: Programar un chip ELMOS PCB 5 Variante D
REM
REM Uso: ejemplo_basico.bat <archivo.hmf> <puerto>
REM Ejemplo: ejemplo_basico.bat datos.hmf COM3
REM ========================================================

setlocal enabledelayedexpansion

REM Verificar argumentos
if "%~2"=="" (
    echo ERROR: Faltan argumentos
    echo.
    echo Uso: %~nx0 ^<archivo.hmf^> ^<puerto^>
    echo.
    echo Ejemplos:
    echo   Windows: %~nx0 datos.hmf COM3
    echo   Linux:   %~nx0 datos.hmf /dev/ttyACM0
    echo.
    pause
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
echo --------------------------------------------------------
echo PASO 1: Cargando datos HMF al MagicBridge...
echo --------------------------------------------------------
cd ..\scripts
python 1_cargar_datos_v3.py "%ARCHIVO_HMF%" "%PUERTO%" %PCB% %VARIANTE%

if errorlevel 1 (
    echo ERROR: Error al cargar datos
    cd ..\examples
    pause
    exit /b 1
)
echo OK: Datos cargados exitosamente
echo.

REM Paso 2: Programar chip
echo --------------------------------------------------------
echo PASO 2: Programando chip...
echo --------------------------------------------------------

REM Convertir variante a minúscula para el comando
set VARIANTE_MIN=%VARIANTE%
if "%VARIANTE%"=="D" set VARIANTE_MIN=d
if "%VARIANTE%"=="E" set VARIANTE_MIN=e

python 2_ejecutar_comando_v3.py "%PUERTO%" W%PCB%%VARIANTE_MIN%

if errorlevel 1 (
    echo ERROR: Error al programar chip
    cd ..\examples
    pause
    exit /b 1
)
echo OK: Chip programado exitosamente
echo.

echo ========================================================
echo           PROGRAMACION COMPLETADA CON EXITO
echo ========================================================
echo.
cd ..\examples
pause
