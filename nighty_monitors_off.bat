@echo off
rem nightly turn off monitors
rem https://mybyways.com/blog/command-to-turn-off-monitor-in-windows-10
rem created 07-05-2023
powershell (Add-Type '[DllImport(\"user32.dll\")]public static extern int PostMessage(int h,int m,int w,int l);' -Name a -Pas)::PostMessage(-1,0x0112,0xF170,2)