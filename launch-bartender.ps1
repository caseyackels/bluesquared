$Prog = "C:\Program Files (x86)\Seagull\BarTender Suite\bartend.exe /P /MIN=TRAY"
$Running = Get-Process prog -ErrorAction SilentlyContinue
$Start = {([wmiclass]"win32_process").Create($Prog)}
if($Running -eq $null) # evaluating if the program is running
{& $Start}
