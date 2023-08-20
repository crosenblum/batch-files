@echo off
setlocal enabledelayedexpansion
rem get subtitles and artwork for movies
rem Craig M. Rosenblum

rem set variables
set moviepath=\movies
set fb_path=C:\Program Files\FileBot\filebot.exe
set count=0

rem description
echo ..FileBot Movie and TV Show Scanner...

rem Create an array to store folders without subtitles
set "folders_without_subtitles="

rem Loop through all subdirectories in the root folder
for /d %%i in ("%moviepath%\*") do (

	rem set has subtitles
    set "has_subtitles=0"
    
    rem Check if the current folder has any .srt files
    for %%f in ("%%i\*.srt") do (
        set "has_subtitles=1"
        rem goto :end_check
    )
    
    :end_check
    if !has_subtitles! == 0 (
        set "folders_without_subtitles=!folders_without_subtitles! "%%i""
    )
)

echo.

rem Count the number of folders without subtitles
set "count=0"
for %%a in (!folders_without_subtitles!) do (
    set /a "count+=1"
)

rem If no folders were found without subtitles, exit
if !count! == 0 (
    rem echo No folders without subtitles found.
    exit /b
	rem goto :checktvshows
)

rem Generate a random number within the range of folder count
set /a "random_num=!random! %% count"

rem Get the folder path at the randomly selected index
for %%b in (!folders_without_subtitles!) do (
    if !random_num! == 0 (
        set "selected_folder=%%~b"
        goto :found_movie_folder
    )
    set /a "random_num-=1"
)

:found_movie_folder
if "%selected_folder%" == "" (
    rem echo No folder was selected.
) else (
    rem echo Randomly selected folder without subtitles: %selected_folder%
    
    rem Get the path of the selected folder (without the last folder name)
    set "selected_folder_path=!selected_folder:\%last_folder%=!"
    rem echo Selected folder path: !selected_folder_path!
)

rem Extract the last folder name from the selected folder path
for %%a in ("%selected_folder%") do (
    set "last_folder=%%~nxa"
)

rem get the subtitles and artwork for one folder
echo %last_folder% 
echo -- Downloading Subtitles
"%fb_path%" -get-subtitles "%selected_folder%" --q "%last_folder%" --lang en --output srt --encoding utf8 -non-strict >nul 2>&1
echo -- Downloading Artwork
"%fb_path%" -script fn:artwork.tmdb "%selected_folder%"  >nul 2>&1