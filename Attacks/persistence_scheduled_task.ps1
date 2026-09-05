# Scheduled Task Persistence Simulation (MITRE ATT&CK T1053.005)
# Creates a scheduled task that executes calc.exe for testing SIEM persistence alerts

schtasks /create /tn "SOC_Lab_Persistence_Test" /tr "calc.exe" /sc ONLOGON /ru "SYSTEM"