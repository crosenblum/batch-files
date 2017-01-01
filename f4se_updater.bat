@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: Name:     f4se_updater.bat
:: Purpose:  Updates Fallout 4 Script Extender into your Fallout 4 folder
:: Author:   crosenblum@gmail.com Craig M. Rosenblum
:: Revision: December 2016 - initial version

:: How to use this
:: 
:: This is a batch file created to help automate the process of updating
:: Fallout 4 Script Extender on your Fallout 4 folder.
:: 
:: But for this to work, requires a few following files and paths to be set correctly.
:: Wget is a command-line website downloader, parser, etc
:: http://gnuwin32.sourceforge.net/packages/wget.htm
:: https://eternallybored.org/misc/wget/
:: Or if you use Chocolatey as I do. you can install that from here.
:: https://chocolatey.org/packages/Wget
:: 
:: This also requires the installation of 7zip. Which you can get from the following sites
:: http://www.7-zip.org/download.html
:: or
:: https://chocolatey.org/packages/7zip
::
:: Also make sure the variables point to the correct folders.
::
:: Enjoy!
:: Craig M. Rosenblum
:: December 31st, 2016 9:45pm

:: setup variables - you must change these to point to the correct folder paths
set cpath=%cd%
set fallout_path="C:\Program Files (x86)\Steam\steamapps\common\Fallout 4"
set file_date=
set file_to_be_queried=%fallout_path%\f4se_loader.exe
set log_file="%cpath%\f4se_updater.log"
set log_toggle=Yes
SET RESULT=---
set wget_path="C:\ProgramData\chocolatey\bin"
set zip_path="C:\Program Files\7-Zip\7z.exe"

:: check if help parameter is passed
IF [%1]==[/?] GOTO :help

echo %* |find "/?" > nul
IF errorlevel 1 GOTO :main

:help
echo --- Welcome to F4SE Updater Batch File ---
echo.
echo Requirements: 7zip and Wget installed, file/folder paths updated in the batch file by you.
echo.
echo How To Use: After updating installing 7zip and wget, you must update the batch file
echo modify the path variables to make sure they are pointing at the correct file and folders.
echo Once that is done, then you should be able to run this without any errors.
echo.
echo What this does: It uses wget to download the F4SE website, download files linked
echo that match the correct file name and then extracts to your Fallout4 folder.
echo It can only do this without errors if you have the correct folders set.
echo.
echo Enjoy!
GOTO :End

:main
:: step 0. display welcome message
echo --- Welcome to F4SE Updater Batch File ---
echo.

:: start log file if logging is enabled
Call :LogThis "%log_toggle%" "F4SE Update used on %date% %time%" %log_file%

:: step 1. download f4se html page
rem echo [1] Attempt to download latest version

Call :LogThis "%log_toggle%" "[1] Attempt to download latest version" %log_file%

:: if logging is disabled then just do quiet wget
if ("%log_toggle%"=="No") (
	:: quiet wget no messages of any kind
	%wget_path%\wget -q -nH --cut-dirs=1 -r -np -A "f4se_*.7z" http://f4se.silverlock.org/
)
:: if logging enabled then push all output to the logfile for better diagnosis
if ("%log_toggle%"=="Yes") (
	:: verbose and full information being sent to log file
	%wget_path%\wget -nH --cut-dirs=1 -r -np -A "f4se_*.7z" http://f4se.silverlock.org/ --append-output=%log_file%
)

:: step 2. check for errors - check if wget installed or any errors from it occured
rem echo [2] Check if wget generated errors
Call :LogThis "%log_toggle%" "[2] Check if wget generated errors - %ERRORLEVEL%" %log_file%

IF %ERRORLEVEL% NEQ 0 (
	:: display error message
	Echo ----Error WGET is not installed, please install it and try again
	goto:End
)

:: step 3. check if downloaded file exists
rem echo [3] Check if downloaded file exists
Call :LogThis "%log_toggle%" "[3] Check if downloaded file exists" %log_file%

FOR /D %%d IN ("%cpath%\f4se*.7z") DO (
  SET RESULT=%%d
)

:: IF file not found or error of any kind display error message
if NOT "%RESULT%"=="---" (
	:: display error message on screen
	rem echo ---Error downloaded file does not exist
	:: send message to logfile if enabled
	Call :LogThis "%log_toggle%" "---Error downloaded file does not exist" %log_file%
	goto:End
)

:ExtractFile
:: step 4. extract file to Fallout 4 folder

:: if logging is enabled then pass verbose messages to log file
Call :LogThis "%log_toggle%" "[4] Attempting to extract to Fallout4 Folder" %log_file%

if ("%log_toggle%"=="Yes") (
	%zip_path% e f4se*.7z -o%fallout_path% -y >> %log_file%
)

:: if logging is disabled then just quietly extract files
if ("%log_toggle%"=="No") (
	%zip_path% e f4se*.7z -o%fallout_path% -y > nul
)
	
:: step 5. check for errors in the extract process
IF %ERRORLEVEL% NEQ 0 (
	
	Call :LogThis "%log_toggle%" "----Error either 7zip is not installed or there is some other file error, please try again." %log_file%"
	
	goto:End
)

:: step 6. delete downloaded f4se 7zip file
Call :LogThis "%log_toggle%" "[6] Deleting downloaded f4se zip file" %log_file%
for %%a in (f4se*.7z) do ( 
	del %%a
)

:: step 7. Update TimeStamp for F4SE Loader
Call :LogThis "%log_toggle%" "[7] Updating timestamp of f4se loader" %log_file%

:: move to the correct folder
cd %fallout_path%

:: modify timestamp to current datetime
copy /b %file_to_be_queried% +,, > nul

:: return to original folder
cd %cpath%

:: step 7. get last modified file date of f4se_loader.exe
FOR %%? IN (%file_to_be_queried%) DO (
	set file_date=%%~t?
)

Call :LogThis "%log_toggle%" "[8] F4SE updated on %file_date%" %log_file%

:End
Call :LogThis "%log_toggle%" "[9] F4SE Update Process Complete" %log_file%
echo.
@ENDLOCAL
@ECHO ON
@EXIT /B %ERRORLEVEL%

:LogThis
rem this will append a message to the log file if the following paramters are set correctly
rem %1 = log_toggle yes or no is logging enabled/disabled
rem %2 = what message will we send to the logfile
rem %3 = name of log file
set toggle=%~1
set message=%~2
set filename=%~3
echo %message%
if %toggle%==Yes echo %message% >> %filename%
EXIT /B 0