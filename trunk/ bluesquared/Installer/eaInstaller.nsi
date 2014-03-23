# This example shows how to handle silent installers.
# In short, you need IfSilent and the /SD switch for MessageBox to make your installer
# really silent when the /S switch is used.
;--------------------------------

; The name of the installer
Name "Efficiency Assist Installer"

; The installer
OutFile "install_EfficiencyAssist.exe"

; The default installation directory
InstallDir "$DOCUMENTS\EfficiencyAssist"

; Request application privileges for Windows Vista, 7 and later
RequestExecutionLevel user

;--------------------------------
AutoCloseWindow false
ShowInstDetails show

;--------------------------------

;Page license
;Page components
Page directory
Page instfiles

; The name of the running .exe
;Var programName
;StrCopy $programName "EfficiencyAssist.exe"


# uncomment the following line to make the installer silent by default.
; SilentInstall silent

Function .onInit
  # `/SD IDYES' tells MessageBox to automatically choose IDYES if the installer is silent
  # in this case, the installer can only be silent if the user used the /S switch or if
  # you've uncommented line number 5
  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like the installer to be silent from now on?" \
    /SD IDYES IDNO no IDYES yes

  # SetSilent can only be used in .onInit and doesn't work well along with `SetSilent silent'

  yes:
    SetSilent silent
    Goto done
  no:
    SetSilent normal
  
  done:
FunctionEnd


Section
  ;#IfSilent 0 +2
    ;MessageBox MB_OK|MB_ICONINFORMATION 'This is a "silent" installer'

    ; Create the folder
    SetOutPath $INSTDIR

    #File /oname=$DOCUMENTS EfficiencyAssist.exe
    File /a EfficiencyAssist.exe
    File /a config.txt
    
    ; set the config to readonly
    setFileAttributes config.txt readonly

SectionEnd
