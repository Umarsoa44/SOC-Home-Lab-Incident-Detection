# 🛡️ Enterprise SOC Home Lab & Detection Engineering Framework

> **Author:** Umar Farooq Shaikh  
> **Target Infrastructure:** Windows 11 Enterprise Endpoint (`ACER44`)  
> **SIEM & Ingestion Engine:** Wazuh Manager (`192.168.0.104`)  
> **Core Objective:** Deliver an enterprise-grade threat hunting, adversary emulation, and detection engineering repository demonstrating advanced telemetry correlation, rule writing, and forensic reporting.

---

## 🏗️ Repository Architecture & Directory Layout

```text
soc-home-lab/
├── Alerts/
│   ├── powershell_obfuscation_alert.json
│   ├── scheduled_task_alert.json
│   └── lsass_dump_alert.json
├── Architecture/
│   └── network-topology.drawio
├── Attacks/
│   ├── powershell_obfuscation.ps1
│   ├── persistence_scheduled_task.ps1
│   └── lsass_dump.ps1
├── Configs/
│   ├── sysmonconfig.xml
│   ├── ossec.conf
│   └── sigma_lsass_dump.yml
├── Evidence/
│   ├── wazuh_siem_master_alert_proof.png
│   └── README.md
├── Reports/
│   └── threat-hunting-report.md
└── README.md


🔄 End-to-End Telemetry Pipeline - 

01 - Adversary Simulation (Attacks/): Custom PowerShell scripts mimic real-world adversary behavior, bypassing baseline defenses via obfuscated execution, living-off-the-land utilities (rundll32.exe), and scheduled task creation.

02 - Kernel Telemetry Capture (Configs/sysmonconfig.xml): Configured with advanced SwiftOnSecurity filtering rules to log low-level Windows kernel events, specifically process creation (Event ID 1), process access handle manipulation (Event ID 10), and task persistence registration.

03 - Log Ingestion & Forwarding (Configs/ossec.conf): The Wazuh Agent running on ACER44 polls the local Windows Event Channel (Microsoft-Windows-Sysmon/Operational), securely streaming payloads over TCP port 1514 to the Wazuh Manager (192.168.0.104).

04 - SIEM Correlation & Detection (Configs/sigma_lsass_dump.yml): Incoming events are indexed and parsed against native Wazuh rules and custom Sigma detection logic to surface high-severity alerts.



| Threat Vector / Simulation | MITRE ATT&CK Technique | ID | Primary Sysmon Telemetry | Severity Level |
| --- | --- | --- | --- | --- |
| **PowerShell Obfuscation** | Obfuscated Files or Information | T1027 / T1059.001 | Event ID 1 (Process Creation - Long Base64 Strings) | Level 3 - 4 |
| **Scheduled Task Persistence** | Scheduled Task / Job | T1053.005 | Event ID 1 / Security 4698 (Task Creation XML) | Level 4 |
| **LSASS Credential Dumping** | OS Credential Dumping: LSASS Memory | T1003.001 | Event ID 10 (Process Access - comsvcs.dll handle) | Level 10 - 15 |

🔍 Verification & Evidence - 

 - Master SIEM Proof: Live operational screenshots displaying real-time alert triggers are documented inside the Evidence/ directory.

 - Forensic Post-Mortem: Comprehensive incident breakdown, indicator analysis, and enterprise hardening recommendations are available in Reports/threat-hunting-report.md.

 🚀 Quick Start & Git Deployment
To clone and initialize this repository locally for review:
- git clone [https://github.com/YOUR_USERNAME/soc-home-lab.git](https://github.com/YOUR_USERNAME/soc-home-lab.git)
  cd soc-home-lab
  git status

