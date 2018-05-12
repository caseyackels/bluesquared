@ECHO OFF
REM
REM - This script assumes it is being ran in the 'root' directory of the repository. We are going to generate a
REM - directory one level up called Builds
REM

REM - LABEL INDICATING THE BEGINNING OF THE DOCUMENT.
:BEGIN
CLS
Title Project Builder
REM - Build our Builds dir

IF NOT EXIST Builds\ (MKDIR Builds)
::mkdir builds

REM Find out what project the user wants to build
::CHOICE /C:123 /M "1=BoxLabels 2=Efficiency Assist 3=NextGen-RM" %1
set /p project= 1=BoxLabels 2=Efficiency Assist 3=ReceiptMaker NG 4=DistributionHelper ^>
set /p wrap= Do you want to build an executable? 1/0 ^>
set /p installer= Would you like to create an installer? 1/0 ^>

:: Create a blank line
ECHO.

REM - Whatever number the user presses, we will then go to that category
IF %project% == 4 GOTO DISTHELPER
IF %project% == 3 GOTO NEXTGEN-RM
IF %project% == 2 GOTO EA
IF %project% == 1 GOTO BLUESQUIRREL
GOTO END

ECHO.

:DISTHELPER
:: Set program name
set programName=DistributionHelper
set programEXE=DistributionHelper.vfs

set thirdparty=about autoscroll csv debug IconThemes img log md5 md5crypt sqlite3_3801 tablelist5.13 tcom3.9 tkdnd2.2 tooltip twapi_4.1-dev mime smtpd base64 cawt_1.0.7 cmdline struct report

GOTO BUILDPROJECT

:NEXTGEN-RM
:: Set program name
set programName=NextGenRM
set programEXE=NextGenRM.vfs

set thirdparty=about autoscroll debug tablelist5.13 tooltip img log md5 sqlite3_3801

GOTO BUILDPROJECT


:EA
set programName=EfficiencyAssist
set programEXE=EfficiencyAssist.vfs

:: set thirdparty=about autoscroll csv debug IconThemes img log md5 md5crypt sqlite3_3801 tablelist5.13 tcom3.9 tkdnd2.2 tooltip twapi_4.1-dev tdbc mime smtpd base64 Cawt-2.1.0-User cmdline struct report soundex
set thirdparty=about autoscroll csv debug IconThemes img log md5 md5crypt sqlite3_3801 tablelist_6.1 tcom3.9 tkdnd2.2 tooltip twapi_4.3.5 tdbc mime smtpd base64 Cawt_2.4.2 cmdline struct report soundex

GOTO BUILDPROJECT


:BLUESQUIRREL
:: Set program name
set programName=BlueSquirrel
set programEXE=BlueSquirrel.vfs

set thirdparty=about autoscroll csv debug tablelist5.4 tooltip

GOTO BUILDPROJECT


:BUILDPROJECT
rem - Get the version number
if %wrap% == 1 (set /p version= %programName% Version-^>) ELSE (ECHO No version needed, skipping...)

:: Create the directory structure. Basically just copy the source files, then add in the 3rd party components.
ECHO Removing old files ...
ECHO.
IF EXIST Builds\%programEXE% (RMDIR /S /Q Builds\%programEXE%) ELSE (ECHO No files detected, continuing...)
ECHO.
rem - Insert a delay
ping -n 1 127.0.0.1>nul

ECHO Building %programName% - Starting...
ECHO Copying project files

rem - Insert a delay
ping -n 1 127.0.0.1>nul
xcopy /E /I /Y %programEXE% Builds\%programEXE% /S


ECHO.
rem - Insert a second delay
ping -n 1 127.0.0.1>nul
ECHO Copying 3rd Party Files...

:: Cycle through the 'generic' variable of 3rdparty to add in the libraries that the project needs. This will be set in the individual
:: projects section.
for %%a in (%thirdparty%) do xcopy /E /I /Y /S 3rdPartyLibraries\%%a Builds\%programEXE%\lib\app-%programName%\Libraries\%%a
ECHO.
ECHO Building %programName% - Finished!
ECHO.
rem - Insert a delay
ping -n 1 127.0.0.1>nul


GOTO :WRAP


:WRAP
ECHO.

:: Now we give the option to wrap it.
:: CHOICE /M "Do you want to wrap it?" %1
IF %wrap% == n GOTO NOWRAP

ECHO Generating executable file...
ECHO Please wait...
cd Builds
..\base-tcl8.6-thread-win32-ix86.exe ..\sdx.kit wrap %programName%.exe -runtime ..\base-tk8.6-thread-win32-ix86.exe -writable

ping -n 5 127.0.0.1>nul

::..\tclkitsh858.exe ..\sdx.kit wrap %programName%.exe -runtime ..\tclkit-858.exe -writable
::..\tclkit-tcl-win64-86.exe ..\sdx.kit wrap %programName%.exe -runtime ..\tclkit-tk-win64-86.exe

rename %programName%.exe %programName%-%version%.exe
cd ..
ECHO Finished Wrapping!
ECHO Moving executable to %cd%
rem - Insert a delay
ping -n 1 127.0.0.1>nul

:: Move the exe file to the main dir.
move /Y Builds\%programName%-%version%.exe .

::tclkitsh858.exe sdx.kit lsk BlueSquirrel-1.6.7-October2011.exe
::tclkitsh858.exe sdx.kit unwrap BlueSquirrel-1.6.7-October2011.kit


ECHO %time%: Your project has been built: %programName%-%version%.exe
:: Time Delay
ping -n 1 127.0.0.1>nul

if %installer% == 1 GOTO INSTALLER

GOTO END


:NOWRAP
ECHO.
ECHO %time%: Your finished project (%programName%) has been exported to Builds\%programName%
ping -n 10 127.0.0.1>nul

GOTO END

:INSTALLER
rem - Insert a delay
ping -n 2 127.0.0.1>nul

ECHO Creating Installer for: %programName%-%version%.exe - Starting...
ECHO Copying project files

rem - Insert a delay
ping -n 1 127.0.0.1>nul

rem - Look below for the 'clean up' section, files must be specified there as well.
copy /Y EA_setup.edb Installer\

move /Y %programName%-%version%.exe Installer\

cd Installer

rename %programName%-%version%.exe %programName%.exe
ECHO Renaming program to: %programName%.exe

"C:\Program Files (x86)\NSIS\makensis.exe" /DVERSION=%version% eaInstaller.nsi

ping -n 10 127.0.0.1>nul

ECHO Clean up files ...

del %programName%.exe
del EA_setup.edb

ECHO Finished ...
ping -n 1 127.0.0.1>nul

GOTO :END

:END
