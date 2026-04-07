@echo off
REM ========================================================
REM Ejemplo Avanzado: Programar múltiples chips del mismo modelo
REM
REM Uso: ejemplo_multiple.bat <archivo.hmf> <puerto> <cantidad>
REM Ejemplo: ejemplo_multiple.bat datos.hmf COM3 5
REM ========================================================

setlocal enabledelayedexpansion

REM Verificar argumentos
if "%~3"=="" (
    echo ERROR: Faltan argumentos
    echo.
    echo Uso: %~nx0 ^<archivo.hmf^> ^<puerto^> ^<cantidad^>
    echo.
    echo Ejemplos:
    echo   %~nx0 datos.hmf COM3 5
    echo.
    pause
    exit /b 1
)

set ARCHIVO_HMF=%~1
set PUERTO=%~2
set CANTIDAD=%~3
set PCB=5
set VARIANTE=D

echo ========================================================
echo    MagicBridge - Programacion Multiple
echo ========================================================
echo.
echo Configuracion:
echo    Archivo HMF: %ARCHIVO_HMF%
echo    Puerto:      %PUERTO%
echo    PCB:         %PCB%
echo    Variante:    %VARIANTE%
echo    Cantidad:    %CANTIDAD% chips
echo.

REM Paso 1: Cargar datos (UNA SOLA VEZ)
echo --------------------------------------------------------
echo Cargando datos HMF al MagicBridge (solo una vez)...
echo --------------------------------------------------------
call "%~dp0\..\bin\magicbridge-load.bat" "%ARCHIVO_HMF%" "%PUERTO%" %PCB% %VARIANTE% --quiet

if errorlevel 1 (
    echo ERROR: Error al cargar datos
    pause
    exit /b 1
)
echo OK: Datos cargados en RAM del MagicBridge
echo.

REM Contador de éxitos y fallos
set /a EXITOSOS=0
set /a FALLIDOS=0

REM Convertir variante a minúscula para el comando
set VARIANTE_MIN=%VARIANTE%
if "%VARIANTE%"=="D" set VARIANTE_MIN=d
if "%VARIANTE%"=="E" set VARIANTE_MIN=e

REM Paso 2: Programar múltiples chips
for /L %%i in (1,1,%CANTIDAD%) do (
    echo --------------------------------------------------------
    echo Chip %%i de %CANTIDAD%
    echo --------------------------------------------------------

    if %%i GTR 1 (
        echo Presiona ENTER despues de cambiar el chip...
        pause >nul
    )

    echo Programando...
    call "%~dp0\..\bin\magicbridge-cmd.bat" "%PUERTO%" W%PCB%%VARIANTE_MIN% --quiet

    if errorlevel 1 (
        echo ERROR: Error al programar chip %%i
        set /a FALLIDOS=!FALLIDOS!+1
    ) else (
        echo OK: Chip %%i programado exitosamente
        set /a EXITOSOS=!EXITOSOS!+1
    )
    echo.
)

REM Resumen
echo ========================================================
echo                    RESUMEN FINAL
echo --------------------------------------------------------
echo   OK: Chips programados: !EXITOSOS!
echo   ERROR: Chips fallidos:    !FALLIDOS!
echo ========================================================
echo.

if !FALLIDOS! EQU 0 (
    pause
    exit /b 0
) else (
    pause
    exit /b 1
)
