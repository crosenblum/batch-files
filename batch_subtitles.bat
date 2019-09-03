@echo off
rem get subtitles for movies and tvshows

rem set variables
set moviepath=D:\Movies
set tvshowpath=D:\TVShows
set subtleclipath=C:\Program Files (x86)\Subtle\
set cwd=%CD%
set video_type_list=avi,mkv,mp4,wmv,mpg,vob

rem description
echo ..Batch Movie and TV Show Scanner...

rem move to the movie folder
rem echo Changing to ..[%moviepath%]
rem cd %moviepath%

rem begin loop
for /f "delims=" %%i IN ('dir /ad /b "%moviepath%"') do (

	rem get subtitles
	rem echo ..[%%i]
	rem echo .
	
	rem check if this folder has a subtitle in it
	if not exist "%moviepath%\%%i\*.srt" (

		rem using subtle cli to download subtitles
		"%subtleclipath%Subtle-cli.exe" "%moviepath%\%%i"
	
	)

)
rem end loop


rem  end of file change back
rem echo Returning to ..[%cwd%]
rem cd %cwd%