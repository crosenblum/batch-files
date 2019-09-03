@echo off
rem remove non-english audiotracks from mkv
rem https://forum.doom9.org/showthread.php?t=162639


FOR /F "delims=*" %%A IN ('dir /b *.MKV') DO "C:\Program Files\MKVToolNix\mkvmerge.exe" -o "fixed_%%A" -a !3 --compression -1:none "%%A"
PAUSE