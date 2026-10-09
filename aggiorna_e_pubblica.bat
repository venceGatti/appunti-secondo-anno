@echo off
chcp 65001 >nul
title Sincronizzazione e Compilazione Dispense PDF - GitHub Sync

echo ========================================================
echo   SINCRONIZZAZIONE DISPENSE PDF CON GITHUB
echo ========================================================
echo.

cd /d "%~dp0"

echo Scegli la modalita' di aggiornamento:
echo   [1] Ricompila LaTeX a doppia passata e pubblica (consigliato per aggiornare indici e formule)
echo   [2] Pubblica direttamente i PDF attuali senza ricompilare
echo.
echo Se non premi nulla entro 8 secondi, verra' avviata l'opzione 1...
choice /c 12 /t 8 /d 1 /n /m "Inserisci 1 o 2: "
if errorlevel 2 goto SALTA_COMPILAZIONE

:COMPILAZIONE_LATEX
echo.
echo ========================================================
echo   FASE 1/3: Compilazione LaTeX a Doppia Passata
echo ========================================================
echo.

echo [*] Compilazione Analisi Matematica II (Teoria)...
cd /d "..\latex\analisi"
pdflatex -synctex=1 -interaction=nonstopmode analisi.tex >nul 2>&1
pdflatex -synctex=1 -interaction=nonstopmode analisi.tex >nul 2>&1
echo     [OK] analisi.pdf ricompilato con indice completo.

echo [*] Compilazione Analisi Matematica II (Eserciziario + Formulario)...
pdflatex -synctex=1 -interaction=nonstopmode eserciziario.tex >nul 2>&1
pdflatex -synctex=1 -interaction=nonstopmode eserciziario.tex >nul 2>&1
echo     [OK] eserciziario.pdf ricompilato con indice completo.

echo [*] Compilazione Fisica II (Teoria + Formulario Elettromagnetismo)...
cd /d "..\latex\fisica"
pdflatex -synctex=1 -interaction=nonstopmode fisica.tex >nul 2>&1
pdflatex -synctex=1 -interaction=nonstopmode fisica.tex >nul 2>&1
echo     [OK] fisica.pdf ricompilato con appendice formulario.

echo [*] Compilazione Programmazione Avanzata in Java e C (PAJC)...
cd /d "..\latex\PAJC"
pdflatex -synctex=1 -interaction=nonstopmode PAJC.tex >nul 2>&1
echo     [OK] PAJC.pdf aggiornato.

echo [*] Compilazione Reti di Telecomunicazioni (TLC)...
cd /d "..\latex\TLC"
pdflatex -synctex=1 -interaction=nonstopmode telecomunicazioni.tex >nul 2>&1
echo     [OK] telecomunicazioni.pdf aggiornato.

cd /d "%~dp0"
echo.

:SALTA_COMPILAZIONE
echo ========================================================
echo   FASE 2/3: Copia dei PDF nella cartella di pubblicazione
echo ========================================================
echo.

copy /Y "..\latex\TLC\telecomunicazioni.pdf" "telecomunicazioni.pdf" >nul
if %errorlevel% equ 0 (echo   [OK] telecomunicazioni.pdf pronto.) else (echo   [!] telecomunicazioni.pdf non trovato.)

copy /Y "..\latex\PAJC\PAJC.pdf" "PAJC.pdf" >nul
if %errorlevel% equ 0 (echo   [OK] PAJC.pdf pronto.) else (echo   [!] PAJC.pdf non trovato.)

copy /Y "..\latex\analisi\analisi.pdf" "analisi.pdf" >nul
if %errorlevel% equ 0 (echo   [OK] analisi.pdf pronto.) else (echo   [!] analisi.pdf non trovato.)

copy /Y "..\latex\analisi\eserciziario.pdf" "eserciziario.pdf" >nul
if %errorlevel% equ 0 (echo   [OK] eserciziario.pdf pronto.) else (echo   [!] eserciziario.pdf non trovato.)

copy /Y "..\latex\fisica\fisica.pdf" "fisica.pdf" >nul
if %errorlevel% equ 0 (echo   [OK] fisica.pdf pronto.) else (echo   [!] fisica.pdf non trovato.)

echo.
echo ========================================================
echo   FASE 3/3: Controllo Commit e Pubblicazione su GitHub
echo ========================================================
echo.

git add telecomunicazioni.pdf PAJC.pdf analisi.pdf eserciziario.pdf fisica.pdf README.md aggiorna_e_pubblica.bat >nul 2>&1

git diff-index --quiet HEAD --
if %errorlevel% neq 0 (
    echo   [OK] Nuove modifiche rilevate. Creazione commit...
    git commit -m "Aggiornamento dispense PDF [%date% %time%]"
) else (
    echo   [INFO] Nessun file modificato rispetto all'ultimo commit locale.
)

echo.
echo Invio modifiche e sincronizzazione con GitHub (git push)...
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   SUCCESSO! Tutti i PDF sono allineati e aggiornati su GitHub.
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
