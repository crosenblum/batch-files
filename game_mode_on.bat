@echo off
rem Craigs Game Mode
rem kills all non-gaming related apps running in service tray
rem Craig M. Rosenblum crosenblum@gmail.com

rem set variable
set count=1

rem show into menu
echo :::::::::::::::::::::::::::::::::::::
echo ::                                 ::
echo ::          Game Mode ON           ::
echo ::                                 ::
echo ::   This kills system tray apps   ::
echo ::   to improve performance when   ::
echo ::   gaming...Enjoy!!              ::
echo ::                                 ::
echo ::                                 ::
echo :::::::::::::::::::::::::::::::::::::


call :KillTask Discord discord.exe
call :KillTask Lightbulb LightBulb.exe
call :KillTask SpyBot SDTray.exe
call :KillTask Webcam CameraHelperShell.exe 
call :KillTask Garmin express.exe
call :KillTask Rainmeter Rainmeter.exe

goto end

:KillTask
rem https://stackoverflow.com/questions/162291/how-to-check-if-a-process-is-running-via-a-batch-script
rem echo check for %~1 running %~2
if "%~1"=="" (
	rem parameter not passed
	echo :: Parameter not passed
) else (
	rem program found so lets kill it
	tasklist /FI "IMAGENAME eq %~2" 2>NUL | find /I /N "%~2">NUL
	if "%ERRORLEVEL%"=="1" (
		echo :: %~1 program is running
		echo :: Now killing %~1 
		taskkill /F /IM %~2 >nul 2>&1
	) else (
		rem program is not running therefore doesnt need to be killed
		echo :: %~1 program not running [%ERRORLEVEL%]
	)
)
:end

rem echo :: Finished.................... :