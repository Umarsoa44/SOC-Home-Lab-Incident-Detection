# PowerShell Obfuscation & Encoded Execution Simulation
# Simulates obfuscated command-line execution for detection testing

$command = "Write-Output 'SOC Lab PowerShell Detection Test'"
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)

powershell.exe -EncodedCommand $encodedCommand