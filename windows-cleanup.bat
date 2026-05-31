@echo off
title WINDOWS CLEANUP - SAFE PRODUCTION VERSION
color 0A

echo ============================================
echo   WINDOWS CLEANUP - SAFE MODE
echo   Run as Administrator
echo ============================================

echo.

:: =========================
:: 1. TEMP FILES
:: =========================
echo [1/12] Cleaning TEMP files...
del /q /f /s "%TEMP%\*" 2>nul
del /q /f /s "C:\Windows\Temp\*" 2>nul
del /q /f /s "C:\Temp\*" 2>nul

:: =========================
:: 2. PREFETCH
:: =========================
echo [2/12] Cleaning Prefetch...
del /q /f /s "C:\Windows\Prefetch\*" 2>nul

:: =========================
:: 3. EVENT LOGS
:: =========================
echo [3/12] Clearing Event Logs...
for /f "tokens=*" %%L in ('wevtutil el') do wevtutil cl "%%L" 2>nul

:: =========================
:: 4. RECENTS
:: =========================
echo [4/12] Cleaning Recent Files...
del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\*" 2>nul
del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" 2>nul
del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*" 2>nul

:: =========================
:: 5. THUMBNAIL CACHE
:: =========================
echo [5/12] Cleaning Thumbnail Cache...
del /q /f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
del /q /f "%LOCALAPPDATA%\Microsoft\Windows\Explorer\iconcache_*.db" 2>nul

:: =========================
:: 6. DNS + NETWORK
:: =========================
echo [6/12] Network cleanup...
ipconfig /flushdns >nul
arp -d * >nul
nbtstat -R >nul
netsh interface ip delete arpcache >nul

:: =========================
:: 7. WINDOWS UPDATE CACHE
:: =========================
echo [7/12] Windows Update cache...
net stop wuauserv >nul 2>&1
del /q /f /s "C:\Windows\SoftwareDistribution\Download\*" 2>nul
net start wuauserv >nul 2>&1

:: =========================
:: 8. ERROR REPORTS
:: =========================
echo [8/12] Cleaning error reports...
del /q /f /s "C:\ProgramData\Microsoft\Windows\WER\*" 2>nul
del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\WER\*" 2>nul

:: =========================
:: 9. CRASH DUMPS
:: =========================
echo [9/12] Cleaning crash dumps...
del /q /f "C:\Windows\Minidump\*" 2>nul
del /q /f "C:\Windows\MEMORY.DMP" 2>nul
del /q /f /s "%LOCALAPPDATA%\CrashDumps\*" 2>nul

:: =========================
:: 10. SEARCH INDEX
:: =========================
echo [10/12] Search index cleanup...
del /q /f /s "C:\ProgramData\Microsoft\Search\Data\*" 2>nul

:: =========================
:: 11. BROWSER CACHE
:: =========================
echo [11/12] Browser cache cleanup...

del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" 2>nul
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache\*" 2>nul
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*" 2>nul
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\*" 2>nul

for /d %%P in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
    del /q /f /s "%%P\cache2\*" 2>nul
    del /q /f /s "%%P\startupCache\*" 2>nul
)

:: =========================
:: 12. OPTIONAL SAFE TRACES
:: =========================
echo [12/12] Optional cleanup...

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f 2>nul
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f 2>nul

:: ==========================================================
:: 13. TWEAKS (PERFORMANCE BOOST - ADDITION)
:: ==========================================================

echo [13/13] Applying performance tweaks...

:: --- Power plan High Performance ---
powercfg -setactive SCHEME_MIN

:: --- Reduce visual lag  ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1

:: --- Disable Game DVR (background recording = lag) ---
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Network TCP tuning (safe defaults) ---
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=disabled >nul

:: --- Disable background apps (Windows 10/11 tweak) ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul

:: --- Restart Explorer (apply UI changes) ---
taskkill /f /im explorer.exe >nul 2>&1
start explorer.exe

:: Désactiver Superfetch
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

:: Désactiver DiagTrack (télémétrie)
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1

echo.
echo ============================================
echo CLEANUP + TWEAKS COMPLETED SUCCESSFULLY
echo ============================================
pause
