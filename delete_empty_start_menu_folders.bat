@echo off
rem delete empty start menu folders

rem for both current user and all users
set cfolder=%userprofile%\Start Menu\Programs
set afolder=%ALLUSERSPROFILE%\Start Menu\Programs
set count = 0

rem loop thru start menu folders for all users
for /f "delims=" %%d in ('dir /s /b /ad "%afolder%" ^| c:\windows\system32\sort /r') do (

  for /F %%N in ('dir /S/B "%%d\*" ^| c:\windows\system32\find /V /C "::"') do (
		if %%N EQU 0 (
			rd /q "%%d"
			set /a count+=1
		)
	)

)

rem loop thru start menu folders for current user
for /f "delims=" %%d in ('dir /s /b /ad "%cfolder%" ^| c:\windows\system32\sort /r') do (

	for /F %%N in ('dir /S/B "%%d\*" ^| c:\windows\system32\find /V /C "::"') do (
		if %%N EQU 0 (
			rd /q "%%d"
			set /a count+=1
		)
	)

)

:EXIT
echo Total Deleted [%count%]
