@echo off
chcp 65001 >nul
title Aggiornamento Dispense PDF - GitHub Sync

echo ========================================================
echo   SINCRONIZZAZIONE DISPENSE PDF CON GITHUB
echo ========================================================
echo.

cd /d "%~dp0"

echo [1/3] Copia dei PDF aggiornati dalle cartelle LaTeX...
copy /Y "..\latex\TLC\telecomunicazioni.pdf" "telecomunicazioni.pdf" >nul
if %errorlevel% neq 0 (
    echo [ATTENZIONE] telecomunicazioni.pdf non trovato in ..\latex\TLC
) else (
    echo   [OK] telecomunicazioni.pdf aggiornato.
)

copy /Y "..\latex\PAJC\PAJC.pdf" "PAJC.pdf" >nul
if %errorlevel% neq 0 (
    echo [ATTENZIONE] PAJC.pdf non trovato in ..\latex\PAJC
) else (
    echo   [OK] PAJC.pdf aggiornato.
)

copy /Y "..\latex\analisi\analisi.pdf" "analisi.pdf" >nul
if %errorlevel% neq 0 (
    echo [ATTENZIONE] analisi.pdf non trovato in ..\latex\analisi
) else (
    echo   [OK] analisi.pdf aggiornato.
)

copy /Y "..\latex\analisi\eserciziario.pdf" "eserciziario.pdf" >nul
if %errorlevel% neq 0 (
    echo [ATTENZIONE] eserciziario.pdf non trovato in ..\latex\analisi
) else (
    echo   [OK] eserciziario.pdf aggiornato.
)

copy /Y "..\latex\fisica\fisica.pdf" "fisica.pdf" >nul
if %errorlevel% neq 0 (
    echo [ATTENZIONE] fisica.pdf non trovato in ..\latex\fisica
) else (
    echo   [OK] fisica.pdf aggiornato.
)

echo.
echo [2/3] Verifica modifiche con Git...

git status --porcelain > "%temp%\git_status_check.txt"
set /p MODIFICHE=<"%temp%\git_status_check.txt"
del "%temp%\git_status_check.txt" 2>nul

if "%MODIFICHE%"=="" (
    echo.
    echo ========================================================
    echo   NESSUNA MODIFICA RILEVATA: i PDF su GitHub sono gia' aggiornati!
    echo ========================================================
    echo.
    goto FINE
)

echo [3/3] Pubblicazione delle modifiche su GitHub...
git add .
git commit -m "Aggiornamento dispense PDF [%date% %time%]"
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   SUCCESSO! Tutti i PDF sono stati aggiornati su GitHub.
    echo   I tuoi compagni possono visualizzarli su:
    echo   https://github.com/venceGatti/appunti-secondo-anno
    echo ========================================================
    echo.
) else (
    echo.
    echo ========================================================
    echo   [ERRORE] Il caricamento su GitHub e' fallito.
    echo   Verifica la connessione internet o le credenziali GitHub.
    echo ========================================================
    echo.
)

:FINE
pause
