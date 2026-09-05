# Threat Hunting & Detection Engineering Post-Mortem
**Target Asset:** ACER44 (Windows 11 Enterprise)  
**SIEM Engine:** Wazuh Manager (192.168.0.104)  
**Lead Investigator:** Umar Farooq Shaikh  

## 1. Executive Overview
A targeted simulation was executed against endpoint `ACER44` to evaluate baseline endpoint telemetry generation, Wazuh SIEM agent parsing pipelines, and alert correlation efficacy. The engagement focused on three core phases of the MITRE ATT&CK kill chain: execution evasion, persistence establishment, and credential theft.

## 2. Technical Attack & Telemetry Breakdown

### Phase A: PowerShell Obfuscation & Encoded Execution
* **Adversary Technique:** T1027 (Obfuscated Files or Information) & T1059.001 (PowerShell)
* **Execution Vector:** Base64 encoded payload passed via command-line arguments to bypass naive signature-based string matching.
* **Telemetry Evidence (Sysmon Event ID 1):**
  - Parent Process: `explorer.exe` -> `powershell.exe -EncodedCommand SwBpAHabeA...`
  - Detection Response: Wazuh Rule ID level correlation identified abnormal command line length and dynamic decoding behavior.

### Phase B: Scheduled Task Persistence
* **Adversary Technique:** T1053.005 (Scheduled Task)
* **Execution Vector:** `schtasks /create /tn "SOC_Lab_Persistence_Test" /tr "calc.exe" /sc ONLOGON /ru "SYSTEM"`
* **Telemetry Evidence (Sysmon Event ID 1 / Security Event Log):**
  - Process creation showing `schtasks.exe` writing a new XML task definition into `C:\Windows\System32\Tasks\`.
  - Security Log Event ID 4698 (A scheduled task was created) captured context regarding SYSTEM-level execution context.

### Phase C: LSASS Memory Scraping via Comsvcs.dll
* **Adversary Technique:** T1003.001 (OS Credential Dumping: LSASS Memory)
* **Execution Vector:** Native Living-off-the-Land (LotL) abuse invoking `rundll32.exe` to trigger the exported `MiniDump` function within `comsvcs.dll`.
* **Telemetry Evidence (Sysmon Event ID 10 - Process Access):**
  - Source Image: `C:\Windows\System32\rundll32.exe`
  - Target Image: `C:\Windows\System32\lsass.exe`
  - Granted Access Flags: High privilege handle permissions (`0x1f3fff` / `0x10ff`) flagged instantly by SwiftOnSecurity Sysmon rule blocks.

## 3. Engineering Recommendations & Hardening
1. **Attack Surface Reduction (ASR):** Enable ASR rule *“Block credential stealing from the Windows local security authority subsystem (lsass.exe)”* across all enterprise endpoints.
2. **PowerShell Logging:** Enforce Module Logging (Event ID 4103), Script Block Logging (Event ID 4104), and Transcription Logging via Group Policy to capture decoded script content natively.
3. **Restricted Rundll32:** Monitor and audit outbound or anomalous uses of `comsvcs.dll` through application control policies (WDAC/AppLocker).