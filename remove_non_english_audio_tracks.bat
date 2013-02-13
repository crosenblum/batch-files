@echo off
rem Remove Non-English Audio Tracks
cd H:\Movies
FOR /F "delims=*" %%A IN ('dir /b /s *.MKV') DO "C:\Program Files\MKVToolNix\mkvmerge.exe" -o "fixed_%%A" -a !3 --compression -1:none "%%A"
PAUSE
