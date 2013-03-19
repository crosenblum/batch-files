@echo off
rem Downloaded Movies & Tv Show Folder Cleaners

rem setup folder paths
set movie_path=G:\Completed_Downloads\movies
set tv_path=G:\Completed_Downloads\tv show

rem setup delete file extension list
set junk=txt rar png jpg url idx html

echo Scanning Movie Path
echo.

rem loop thru all folders inside movie path
FOR /F "tokens=*" %%G IN ('dir/b /ad ^"%movie_path%^"') DO (

  echo --%%G

	rem change folder
	cd "%movie_path%\%%G\"

	rem delete junk
	if exist *.txt del *.txt /q
	if exist *.rar del *.rar /q
	if exist *.png del *.png /q
	if exist *.jpg del *.jpg /q
	if exist *.url del *.url /q
	if exist *.idx del *.idx /q
	if exist *.html del *.html /q
	

)

echo.
echo Scanning TV Path
echo.

rem loop thru all folders inside tv path
FOR /F "tokens=*" %%G IN ('dir/b /ad ^"%tv_path%^"') DO (

	echo --%%G

	rem change folder
	cd "%tv_path%\%%G\"

	rem delete junk
	if exist *.txt del *.txt /q
	if exist *.rar del *.rar /q
	if exist *.png del *.png /q
	if exist *.jpg del *.jpg /q
	if exist *.url del *.url /q
	if exist *.idx del *.idx /q
	if exist *.html del *.html /q

)
