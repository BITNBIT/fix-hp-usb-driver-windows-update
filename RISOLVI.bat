@echo off
rem Doppio clic: chiede i permessi di amministratore e nasconde l'aggiornamento HP USB che ricompare sempre.
net session >nul 2>nul || (powershell -NoProfile -Command "Start-Process -Verb RunAs -FilePath '%~f0'" & exit /b)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0nascondi-aggiornamento.ps1" %*
pause
