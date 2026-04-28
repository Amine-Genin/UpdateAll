@echo off
setlocal enabledelayedexpansion
title UpdateAll -- Mise a jour complete Windows 11

:: ============================================================
::  UpdateAll.bat
::  Winget - Chocolatey - pip - npm - Windows Update
::  Necessite d'etre lance en tant qu'Administrateur
:: ============================================================

:: --- Activer les couleurs ANSI dans cmd (Windows 10/11) ---
reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Obtenir le caractere ESC via PowerShell (methode fiable) ---
set "ESC="
for /f "delims=" %%E in ('powershell -NoProfile -Command "[char]27"') do set "ESC=%%E"

set "C_CYAN=%ESC%[96m"
set "C_BLUE=%ESC%[94m"
set "C_GREEN=%ESC%[92m"
set "C_YELLOW=%ESC%[93m"
set "C_MAGENTA=%ESC%[95m"
set "C_WHITE=%ESC%[97m"
set "C_GRAY=%ESC%[90m"
set "C_RED=%ESC%[91m"
set "C_RESET=%ESC%[0m"

:: ============================================================

set "LOG=%TEMP%\updateall_log.txt"
set "REPORT=%USERPROFILE%\Desktop\UpdateReport.html"

if exist "%LOG%" del "%LOG%"

set "RES_WINGET=SKIP"
set "RES_CHOCO=SKIP"
set "RES_PIP=SKIP"
set "RES_NPM=SKIP"
set "RES_WSUS=SKIP"

:: ============================================================
:: VERIFIER DROITS ADMIN
:: ============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo %C_RED%  [ERREUR] Lancez ce script en tant qu'Administrateur.%C_RESET%
    echo %C_YELLOW%  Clic droit sur le .bat ^> Executer en tant qu'administrateur%C_RESET%
    echo.
    pause
    exit /b 1
)

:: ============================================================
:: BANNIERE
:: ============================================================
cls
echo.
echo %C_CYAN%  ================================================================%C_RESET%
echo %C_CYAN%   UpdateAll - Mise a jour complete Windows 11%C_RESET%
echo %C_CYAN%  ================================================================%C_RESET%
echo %C_GRAY%   Winget  ->  Chocolatey  ->  pip  ->  npm  ->  Windows Update%C_RESET%
echo %C_GRAY%   Analyse . Telechargement . Installation%C_RESET%
echo %C_CYAN%  ================================================================%C_RESET%
echo %C_YELLOW%   Developed by Amine Genin%C_RESET%
echo %C_CYAN%  ================================================================%C_RESET%
echo.
echo %C_GREEN%  [INFO]%C_RESET% Log     : %C_GRAY%%LOG%%C_RESET%
echo %C_GREEN%  [INFO]%C_RESET% Rapport : %C_GRAY%%REPORT%%C_RESET%
echo.
echo %C_YELLOW%  Demarrage dans 3 secondes ...%C_RESET%
timeout /t 3 /nobreak >nul
echo.

:: ============================================================
:: 1. WINGET
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[1/5]%C_CYAN%  ^>^>  %C_YELLOW%WINGET%C_CYAN%  --  Mise a jour des packages              %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo [%DATE% %TIME%] WINGET >> "%LOG%"

where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo %C_RED%  [WARN] winget introuvable sur ce systeme%C_RESET%
    echo WARN winget introuvable >> "%LOG%"
    set "RES_WINGET=WARN"
    goto :WINGET_END
)

echo %C_BLUE%  [....] Packages disponibles :%C_RESET%
winget upgrade
winget upgrade >> "%LOG%" 2>&1

echo %C_BLUE%  [....] Installation de toutes les mises a jour...%C_RESET%
winget upgrade --all --accept-source-agreements --accept-package-agreements
winget upgrade --all --accept-source-agreements --accept-package-agreements >> "%LOG%" 2>&1

if %errorlevel% equ 0 (
    echo %C_GREEN%  [ OK ] Winget termine avec succes%C_RESET%
    set "RES_WINGET=OK"
) else (
    echo %C_YELLOW%  [WARN] Winget termine avec avertissements%C_RESET%
    set "RES_WINGET=WARN"
)
echo RES_WINGET=%RES_WINGET% >> "%LOG%"

:WINGET_END

:: ============================================================
:: 2. CHOCOLATEY
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[2/5]%C_CYAN%  ^>^>  %C_YELLOW%CHOCOLATEY%C_CYAN%  --  Mise a jour des packages          %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo [%DATE% %TIME%] CHOCOLATEY >> "%LOG%"

where choco >nul 2>&1
if %errorlevel% neq 0 (
    echo %C_RED%  [WARN] Chocolatey introuvable -- etape ignoree%C_RESET%
    echo WARN choco introuvable >> "%LOG%"
    set "RES_CHOCO=WARN"
    goto :CHOCO_END
)

echo %C_BLUE%  [....] choco upgrade all -y ...%C_RESET%
choco upgrade all -y
choco upgrade all -y >> "%LOG%" 2>&1

if %errorlevel% equ 0 (
    echo %C_GREEN%  [ OK ] Chocolatey termine avec succes%C_RESET%
    set "RES_CHOCO=OK"
) else (
    echo %C_YELLOW%  [WARN] Chocolatey termine avec code %errorlevel%%C_RESET%
    set "RES_CHOCO=WARN"
)
echo RES_CHOCO=%RES_CHOCO% >> "%LOG%"

:CHOCO_END

:: ============================================================
:: 3. PYTHON / PIP
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[3/5]%C_CYAN%  ^>^>  %C_YELLOW%PYTHON / PIP%C_CYAN%  --  Mise a jour des packages      %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo [%DATE% %TIME%] PYTHON/PIP >> "%LOG%"

where python >nul 2>&1
if %errorlevel% neq 0 (
    echo %C_RED%  [WARN] Python introuvable -- etape ignoree%C_RESET%
    echo WARN python introuvable >> "%LOG%"
    set "RES_PIP=WARN"
    goto :PIP_END
)

echo %C_BLUE%  [....] Mise a jour de pip...%C_RESET%
python -m pip install --upgrade pip >> "%LOG%" 2>&1

echo %C_BLUE%  [....] Mise a jour des packages outdated...%C_RESET%
set "PIP_ERR=0"
set "PIP_FOUND=0"

for /f "delims=" %%P in ('python -m pip list --outdated --format=freeze 2^>nul ^| findstr /r "=="') do (
    set "PIP_FOUND=1"
    for /f "tokens=1 delims==" %%A in ("%%P") do (
        echo %C_BLUE%  [....] Upgrade pip package: %%A%C_RESET%
        python -m pip install --upgrade %%A >> "%LOG%" 2>&1
        if errorlevel 1 set "PIP_ERR=1"
    )
)

if "%PIP_FOUND%"=="0" (
    echo %C_GREEN%  [ OK ] Tous les packages pip sont deja a jour%C_RESET%
)

if "%PIP_ERR%"=="0" (
    echo %C_GREEN%  [ OK ] pip termine avec succes%C_RESET%
    set "RES_PIP=OK"
) else (
    echo %C_YELLOW%  [WARN] pip termine avec avertissements%C_RESET%
    set "RES_PIP=WARN"
)
echo RES_PIP=%RES_PIP% >> "%LOG%"

:PIP_END

:: ============================================================
:: 4. NODE / NPM
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[4/5]%C_CYAN%  ^>^>  %C_YELLOW%NODE / NPM%C_CYAN%  --  Packages globaux               %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo [%DATE% %TIME%] NPM >> "%LOG%"

where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo %C_RED%  [WARN] npm introuvable -- etape ignoree%C_RESET%
    echo WARN npm introuvable >> "%LOG%"
    set "RES_NPM=WARN"
    goto :NPM_END
)

echo %C_BLUE%  [....] Packages globaux obsoletes :%C_RESET%
npm outdated -g >> "%LOG%" 2>&1
set "NPM_ERR=0"

echo %C_BLUE%  [....] Mise a jour des packages globaux...%C_RESET%
npm update -g >> "%LOG%" 2>&1
if %errorlevel% neq 0 set "NPM_ERR=1"

if "%NPM_ERR%"=="0" (
    echo %C_GREEN%  [ OK ] npm termine avec succes%C_RESET%
    set "RES_NPM=OK"
) else (
    echo %C_YELLOW%  [WARN] npm termine avec avertissements%C_RESET%
    set "RES_NPM=WARN"
)
echo RES_NPM=%RES_NPM% >> "%LOG%"

:NPM_END

:: ============================================================
:: 5. WINDOWS UPDATE
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[5/5]%C_CYAN%  ^>^>  %C_YELLOW%WINDOWS UPDATE%C_CYAN%  --  Mises a jour systeme        %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo [%DATE% %TIME%] WINDOWS UPDATE >> "%LOG%"

echo %C_BLUE%  [....] Verification du module PSWindowsUpdate...%C_RESET%
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) { Install-Module PSWindowsUpdate -Force -Scope CurrentUser -ErrorAction SilentlyContinue }"

echo %C_BLUE%  [....] Recherche et installation des mises a jour...%C_RESET%
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue; $u = Get-WindowsUpdate -ErrorAction SilentlyContinue; if ($u.Count -eq 0) { Write-Host '  Aucune mise a jour disponible.' } else { Write-Host \"  $($u.Count) mise(s) a jour trouvee(s)\"; Install-WindowsUpdate -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue }" >> "%LOG%" 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue; $u = Get-WindowsUpdate -ErrorAction SilentlyContinue; if ($u.Count -eq 0) { Write-Host '  Aucune mise a jour disponible.' } else { Write-Host \"  $($u.Count) mise(s) a jour trouvee(s)\"; Install-WindowsUpdate -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue }"

if %errorlevel% equ 0 (
    echo %C_GREEN%  [ OK ] Windows Update termine avec succes%C_RESET%
    set "RES_WSUS=OK"
) else (
    echo %C_YELLOW%  [WARN] Windows Update termine avec avertissements%C_RESET%
    set "RES_WSUS=WARN"
)
echo RES_WSUS=%RES_WSUS% >> "%LOG%"

:: ============================================================
:: GENERATION DU RAPPORT HTML
:: ============================================================
echo.
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[6/6]%C_CYAN%  ^>^>  %C_YELLOW%GENERATION DU RAPPORT HTML%C_CYAN%                      %C_CYAN%^|%C_RESET%
echo %C_CYAN%  ----------------------------------------------------------------%C_RESET%

set "W=%RES_WINGET%"
set "C=%RES_CHOCO%"
set "P=%RES_PIP%"
set "N=%RES_NPM%"
set "U=%RES_WSUS%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$log = (Get-Content '%LOG%' -ErrorAction SilentlyContinue) -join [char]10; $logHtml = [System.Net.WebUtility]::HtmlEncode($log) -replace [char]10,'<br>'; $res = @{Winget='%W%';Chocolatey='%C%';'Python/pip'='%P%';'Node/npm'='%N%';'Windows Update'='%U%'}; $col = @{OK='#22c55e';WARN='#f59e0b';FAIL='#ef4444';SKIP='#6b7280'}; $cards=''; foreach ($k in @('Winget','Chocolatey','Python/pip','Node/npm','Windows Update')) { $v=$res[$k]; $c=$col[$v]; $cards+=\"<div class='card' style='border-left:4px solid $c'><span class='lbl'>$k</span><span class='badge' style='background:$c'>$v</span></div>\" }; $now=(Get-Date -Format 'dd/MM/yyyy HH:mm:ss'); $html='<!DOCTYPE html><html lang=fr><head><meta charset=UTF-8><title>UpdateAll</title><style>*{box-sizing:border-box;margin:0;padding:0}body{background:#0a0e1a;color:#e2e8f0;font-family:Consolas,monospace}header{padding:2rem 3rem;border-bottom:1px solid #1e2d40;background:linear-gradient(135deg,#0a0e1a 60%,#0d1f3c)}h1{font-size:1.6rem;color:#60a5fa;font-weight:800}p.sub{color:#64748b;font-size:.8rem;margin-top:.3rem}main{max-width:800px;margin:2rem auto;padding:0 1.5rem;display:grid;gap:.8rem}.card{background:#111827;border:1px solid #1e2d40;border-radius:8px;padding:.9rem 1.2rem;display:flex;align-items:center;gap:1rem}.lbl{flex:1;font-weight:700;font-size:.95rem}.badge{font-size:.7rem;font-weight:700;padding:.2rem .8rem;border-radius:99px;color:#000;text-transform:uppercase}details{max-width:800px;margin:.5rem auto 2rem;padding:0 1.5rem}summary{cursor:pointer;padding:.6rem 1rem;background:#111827;border:1px solid #1e2d40;border-radius:8px;color:#94a3b8;font-size:.8rem}summary:hover{color:#e2e8f0}.logbox{background:#060a14;border:1px solid #1e2d40;border-top:none;border-radius:0 0 8px 8px;padding:1rem;font-size:.7rem;line-height:1.8;color:#64748b;max-height:400px;overflow-y:auto;white-space:pre-wrap;word-break:break-all}footer{text-align:center;padding:1.5rem;color:#475569;font-size:.75rem}</style></head><body><header><h1>UpdateAll -- Rapport</h1><p class=sub>'+$now+' -- Windows 11 -- Developed by Amine Genin</p></header><main>'+$cards+'</main><details><summary>Journal complet</summary><div class=logbox>'+$logHtml+'</div></details><footer>UpdateAll.bat -- Developed by Amine Genin</footer></body></html>'; $html | Out-File -FilePath '%REPORT%' -Encoding UTF8"

if exist "%REPORT%" (
    echo %C_GREEN%  [ OK ] Rapport genere : %C_GRAY%%REPORT%%C_RESET%
    start "" "%REPORT%"
) else (
    echo %C_YELLOW%  [WARN] Rapport non genere%C_RESET%
)

:: ============================================================
:: RESUME FINAL
:: ============================================================
echo.
echo %C_CYAN%  ================================================================%C_RESET%
echo %C_CYAN%  ^|                                                              ^|%C_RESET%
echo %C_CYAN%  ^|              %C_WHITE%RESUME FINAL%C_CYAN%                                   ^|%C_RESET%
echo %C_CYAN%  ^|                                                              ^|%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[1/5]  Winget          :%C_RESET%  %C_GREEN%%RES_WINGET%%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[2/5]  Chocolatey      :%C_RESET%  %C_GREEN%%RES_CHOCO%%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[3/5]  Python / pip    :%C_RESET%  %C_GREEN%%RES_PIP%%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[4/5]  Node / npm      :%C_RESET%  %C_GREEN%%RES_NPM%%C_RESET%
echo %C_CYAN%  ^|  %C_WHITE%[5/5]  Windows Update  :%C_RESET%  %C_GREEN%%RES_WSUS%%C_RESET%
echo %C_CYAN%  ^|                                                              ^|%C_RESET%
echo %C_CYAN%  ^|  %C_GRAY%Log     : %LOG%%C_RESET%
echo %C_CYAN%  ^|  %C_GRAY%Rapport : %REPORT%%C_RESET%
echo %C_CYAN%  ^|                                                              ^|%C_RESET%
echo %C_CYAN%  ^|   %C_YELLOW%Developed by  %C_MAGENTA%>>>  Amine Genin  <<<  %C_CYAN%                      ^|%C_RESET%
echo %C_CYAN%  ================================================================%C_RESET%
echo.
echo %C_GREEN%  Toutes les etapes terminees. Appuyez sur une touche pour quitter.%C_RESET%
pause >nul
exit /b 0
