for /f %%i in ('dir /b/a-d/od/t:c') do set LAST=%%i
echo The most recently created file is %LAST%

echo Launching %LAST%
Start "" %LAST%

ping -n 5 127.0.0.1>nul
