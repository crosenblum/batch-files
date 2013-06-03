@echo off
rem Use Pip To  Update Everything
rem http://stackoverflow.com/questions/2720014/upgrading-all-packages-with-pip
for /F "delims===" %%i in ('c:\python27\scripts\pip.exe freeze -l') do c:\python27\scripts\pip.exe install -U %%i
