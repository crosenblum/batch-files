@echo off
rem step 1. make sure task scheduler is enabled
for /F "tokens=3 delims=: " %%H in ('sc query "Task Scheduler" ^| findstr "        STATE"') do (
  if /I "%%H" NEQ "RUNNING" (
   REM Put your code you want to execute here
   REM For example, the following line
   net start "Task Scheduler"
  )
)
rem step 2. get correct program files root

if "%ProgramFiles(x86)%XXX"=="XXX" (
set ProgFilesRoot=%ProgramFiles%
) else (
set ProgFilesRoot=%ProgramFiles(x86)%
)

::--------------------------------------------------------
::-- Add Scheduled Definition Updates & Daily Scanning
::--------------------------------------------------------

rem step 3. check which antivirus/antispyware they have
rem -- avast, mse, avira, avg, comodo

echo Check if avg is installed at %ProgFilesRoot%\AVG\AVG2012\
if exist "%ProgFilesRoot%\AVG\AVG2012\" call:AVGTASK

echo Check if avira is installed at %ProgFilesRoot%\Avira\AntiVir Desktop\
if exist "%ProgFilesRoot%\Avira\AntiVir Desktop\" call:AVIRTASK

echo Check if avira cl is installed at %ProgFilesRoot%\Avira\AntiVir Desktop\scancl.exe
if exist "%ProgFilesRoot%\Avira\AntiVir Desktop\scancl.exe" call:AVIRSCAN

echo Check if mse is installed at %ProgFilesRoot%\Microsoft Security Essentials
if exist "%ProgFilesRoot%\Microsoft Security Essentials" call:MSETASK

echo Check if malware antimalware is installed
if exist "%ProgFilesRoot%\Malwarebytes' Anti-Malware\mbam.exe" call:MALTASK

echo Check if spybot updater is installed
if exist "%ProgFilesRoot%\Spybot - Search & Destroy\SDUpdate.exe" call:SPYUPDATE

echo Check if spybot is installed
if exist "%ProgFilesRoot%\Spybot - Search & Destroy\SpybotSD.exe" call:SPYSCAN

::--------------------------------------------------------
::-- Add Monthly ChkDsk
::--------------------------------------------------------
echo Add for just main hard drive
SCHTASKS /Create /SC monthly /TN "Monthly ChkDsk Drive C" /RU SYSTEM /TR "\"%windir%\system32\chkdsk.exe" C: /F /R" 

::--------------------------------------------------------
::-- Add Scheduled Defrag & Disk Cleaning
::--------------------------------------------------------
echo Add for just main hard drive
SCHTASKS /Create /SC monthly /TN "Monthly Defrag Drive C" /RU SYSTEM /TR "\"%windir%\system32\defrag.exe" C: -F"

::--------------------------------------------------------
::-- Add Weekly Time Synchronization Task
::--------------------------------------------------------
echo Add for just main hard drive
SCHTASKS /Create /SC weekly /TN "Monthly Defrag Drive C" /RU SYSTEM /TR "\"%windir%\system32\w32tm.exe" /resync"

goto:eof

::--------------------------------------------------------
::-- Spyware/Antivirus Updates & Scanning Tasks
::--------------------------------------------------------

:AVGTASK
echo add avg definitions updater as a scheduled task every 7 days
SCHTASKS /Create /SC weekly /TN "Weekly AVG Update" /RU SYSTEM /TR "\"%ProgFilesRoot%\AVG\AVG2012\avgmfapx.exe\" /AppMode=UPDATE /pri=2"
goto:eof

:AVIRTASK
echo add avira definitions updater as a scheduled task every 7 days
SCHTASKS /Create /SC weekly /TN "Weekly Avira Update" /RU SYSTEM /TR "\"%ProgFilesRoot%\Avira\AntiVir Desktop\update.exe\" dm=2"
goto:eof

:AVIRSCAN
echo add avira daily scanner
SCHTASKS /Create /SC weekly /TN "Daily Avira Scanner" /RU SYSTEM /TR "\"%ProgFilesRoot%\Avira\AntiVir Desktop\scancl.exe\" --alldrives"
goto:eof

:MSETASK
echo add mse signature updater as a scheduled task every 7 days
SCHTASKS /Create /SC weekly /TN "Weekly MSE Update" /RU SYSTEM /TR "\"%ProgFilesRoot%\Microsoft Security Essentials\MpCmdRun.exe\" -SignatureUpdate"
echo add mse daily scanner
SCHTASKS /Create /SC daily /TN "Daily MSE Scanner" /RU SYSTEM /TR "\"%ProgFilesRoot%\Microsoft Security Essentials\MpCmdRun.exe\" -Scan 1"
goto:eof

:MALTASK
echo add malware def upater as a scheduled task every 7 days
SCHTASKS /Create /SC weekly /TN "Weekly Malware Update" /RU SYSTEM /TR "\"%ProgFilesRoot%\Malwarebytes' Anti-Malware\mbam.exe\" /update"
echo add daily malware scanner
SCHTASKS /Create /SC daily /TN "Daily Malware Scanner" /RU SYSTEM /TR "\"%ProgFilesRoot%\Malwarebytes' Anti-Malware\mbam.exe" /minimized /quickscanterminate"
goto:eof

:SPYUPDATE
echo add spybot updater as a scheduled task every 7 days
SCHTASKS /Create /SC weekly /TN "Weekly SpyBot Update" /RU SYSTEM /TR "\"%ProgFilesRoot%\Spybot - Search & Destroy\SDUpdate.exe" /taskbarhide /autoupdate /autoclose"
goto:eof

:SPYSCAN
echo add spybat weekly immunize
SCHTASKS /Create /SC weekly /TN "Weekly Spybot Immunize" /RU SYSTEM /TR "\"%ProgFilesRoot%\Spybot - Search & Destroy\SpybotSD.exe\" /taskbarhide /autoimmunize /autoclose"
echo add spybot daily scanner
SCHTASKS /Create /SC daily /TN "Daily Spybot Scanner" /RU SYSTEM /TR "\"%ProgFilesRoot%\Spybot - Search & Destroy\SpybotSD.exe" /taskbarhide /autocheck /autofix /onlyspyware /autoclose"
goto:eof
