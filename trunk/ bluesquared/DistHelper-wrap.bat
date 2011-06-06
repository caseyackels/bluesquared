@echo off
taskkill /IM EfficiencyAssist.exe /T /F

tclkitsh858.exe sdx.kit wrap EfficiencyAssist.exe -runtime tclkit-858.exe

EfficiencyAssist.exe

exit