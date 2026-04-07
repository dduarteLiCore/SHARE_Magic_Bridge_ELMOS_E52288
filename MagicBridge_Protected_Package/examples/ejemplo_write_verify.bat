@echo off
REM ========================================================
REM Ejemplo: Escritura y Verificacion de multiples chips
REM
REM Carga el HMF una sola vez, luego para cada chip:
REM   1. Escribe (W)
REM   2. Verifica leyendo (R)
REM
REM Uso: ejemplo_write_verify.bat <archivo.hmf> <puerto> <cantidad>
REM Ejemplo: ejemplo_write_verify.bat datos.hmf COM3 5
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

REM Convertir variante a minuscula para el comando
set VARIANTE_MIN=%VARIANTE%
if "%VARIANTE%"=="D" set VARIANTE_MIN=d
if "%VARIANTE%"=="E" set VARIANTE_MIN=e

echo ========================================================
echo    MagicBridge - Escritura y Verificacion Multiple
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

REM Contadores
set /a EXITOSOS=0
set /a FALLIDOS=0

REM Paso 2: Ciclo de escritura y verificacion
for /L %%i in (1,1,%CANTIDAD%) do (
    echo ========================================================
    echo Chip %%i de %CANTIDAD%
    echo ========================================================

    if %%i GTR 1 (
        echo Presiona ENTER despues de cambiar el chip...
        pause >nul
    )

    REM Escritura
    echo [1/2] Escribiendo chip...
    call "%~dp0\..\bin\magicbridge-cmd.bat" "%PUERTO%" W%PCB%%VARIANTE_MIN% --quiet

    if errorlevel 1 (
        echo ERROR: Fallo la escritura del chip %%i
        set /a FALLIDOS=!FALLIDOS!+1
        echo.
        goto :siguiente_%%i
    )
    echo OK: Escritura exitosa

    REM Verificacion (lectura)
    echo [2/2] Verificando chip (lectura)...
    call "%~dp0\..\bin\magicbridge-cmd.bat" "%PUERTO%" R%PCB%%VARIANTE_MIN% --quiet

    if errorlevel 1 (
        echo ERROR: Fallo la verificacion del chip %%i
        set /a FALLIDOS=!FALLIDOS!+1
    ) else (
        echo OK: Verificacion exitosa
        set /a EXITOSOS=!EXITOSOS!+1
    )

    :siguiente_%%i
    echo.
)

REM Resumen final
echo ========================================================
echo                    RESUMEN FINAL
echo --------------------------------------------------------
echo   OK:    Chips exitosos: !EXITOSOS!
echo   ERROR: Chips fallidos: !FALLIDOS!
echo ========================================================
echo.

if !FALLIDOS! EQU 0 (
    pause
    exit /b 0
) else (
    pause
    exit /b 1
)
