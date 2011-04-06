@echo off
taskkill /IM DistributionHelper.exe /T /F

tclkit858.exe sdx.kit wrap DistributionHelper.exe -runtime tclkit-858.exe