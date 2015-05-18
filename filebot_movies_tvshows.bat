@echo off
rem get subtitles for movies and tvshows

rem set variables
set moviepath=
set tvshowpath=
set fb_path=C:\Program Files\FileBot\filebot.exe
set cwd=%CD%
set video_type_list=avi,mkv,mp4,wmv,mpg,vob

rem description
echo ..FileBot Movie and TV Show Scanner...

rem move to the movie folder
rem echo Changing to ..[%moviepath%]
cd %moviepath%

rem begin loop
for /D %%i in (*) do (

	rem get subtitles
	echo ..[%%i]
	"%fb_path%" -get-subtitles "%moviepath%\%%i" --q "%%i" --lang en --output srt --encoding utf8 -non-strict >nul 2>&1
	"%fb_path%" -script fn:artwork.tmdb "%moviepath%\%%i" >nul 2>&1

)
rem end loop

echo.

rem move to the tvshows folder
echo Changing to ..[%tvshowpath%]
cd %tvshowpath%

rem begin loop of videotypes
FOR /D %%A IN (%video_type_list%) DO (
  
  rem check for different video types
  rem echo Scanning for ..[%%A]
  
  rem begin loop for files of x-type
  For /R %tvshowpath% %%B IN (*.%%A) do (
  
	echo %%~nxB
	"%fb_path%" -get-subtitles "%%B" --q "%%~nxB" --lang en --output srt --encoding utf8 -non-strict >nul 2>&1
	"%fb_path%" -script fn:artwork.tmdb "%%B" >nul 2>&1
  
  
  )
  rem echo .
  rem end loop for files of x-type
  
)
rem end loop of videotypes

rem  end of file change back
rem echo Returning to ..[%cwd%]
cd %cwd%
