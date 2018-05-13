REM Use double %
@echo off
cd C:\Users\Casey\Documents\GitHub\bluesquared

for /f %%i in ('dir /b/a-d/od/t:c') do set LAST=%%i
echo The most recently created file is %LAST%
Start "" %LAST%