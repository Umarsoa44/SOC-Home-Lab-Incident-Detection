# SOC Home Lab Portfolio

An enterprise-grade, virtualized Security Operations Center (SOC) home lab built to simulate advanced adversary tactics, capture low-level kernel telemetry, forward logs via secure pipelines, and perform automated SIEM correlation and threat hunting.

## Architecture & Network Topology

```text
+-------------------------------------------------------+
|                       Host (Hypervisor)               |
|                                                       |
|   +------------------------+  +--------------------+  |
|   |      Attacker VM       |  |     Victim VM      |  |
|   |    (Adversary Sim)     |  |    (Windows 11)    |  |
|   +------------------------+  +--------------------+  |
|               |                           |           |
|               +-------------+-------------+           |
|                             |                         |
|                             v                         |
|               +-----------------------------------+   |
|               |            Wazuh SIEM             |   |
|               |      (Log Ingestion & Engine)     |   |
|               +-----------------------------------+   |
+-------------------------------------------------------+
```

## IP Addressing & Subnet Schema

| Segment    | Interface | Subnet / CIDR    | IP Address     | Dynamic Pool / Scope           | Notes                |
| ---------- | --------- | ---------------- | -------------- | ------------------------------ | -------------------- |
| **WAN**    | `em0`     | `10.0.2.0/24`    | `10.0.2.15`    | Upstream Hypervisor DHCP       | Outbound NAT Enabled |
| **LAN**    | `em1`     | `192.168.1.0/24` | `192.168.1.1`  | Gateway Target                 | Static IPv4 Address  |
| **Client** | `eth0`    | `192.168.1.0/24` | `192.168.1.50` | `192.168.1.10 - 192.168.1.100` | DHCP Assigned        |

## Repository Structure

```text
├── Attacks/
│   ├── powershell_obfuscation.ps1
│   ├── scheduled_task_persistence.ps1
│   └── lsass_dump_sim.ps1
├── Configs/
│   ├── sysmonconfig.xml
│   ├── ossec.conf
│   └── sigma_lsass_dump.yml
├── Evidence/
│   └── screenshots/
├── Reports/
│   └── threat-hunting-report.md
└── README.md
```

## End-to-End Telemetry Pipeline

**01 - Adversary Simulation (`Attacks/`)**

Custom PowerShell scripts simulate adversary behavior through obfuscated execution, living-off-the-land utilities such as `rundll32.exe`, and scheduled task creation.

**02 - Kernel Telemetry Capture (`Configs/sysmonconfig.xml`)**

Sysmon is configured with advanced filtering rules to capture important Windows telemetry, including Process Creation (Event ID 1) and Process Access (Event ID 10).

**03 - Log Ingestion & Forwarding (`Configs/ossec.conf`)**

The Wazuh Agent running on the Windows victim system monitors the local Windows Event Channel:

`Microsoft-Windows-Sysmon/Operational`

Relevant events are forwarded to the Wazuh Manager over TCP port `1514`.

**04 - SIEM Correlation & Detection (`Configs/sigma_lsass_dump.yml`)**

Incoming telemetry is parsed and correlated using Wazuh rules and custom detection logic to identify suspicious activity and generate security alerts.

## MITRE ATT&CK Mapping

The simulated attack scenarios are mapped to the corresponding MITRE ATT&CK techniques:

| Threat Vector / Simulation     | MITRE ATT&CK Technique                        | Technique ID | Primary Sysmon / Windows Telemetry         | Severity Level |
| ------------------------------ | --------------------------------------------- | ------------ | ------------------------------------------ | -------------- |
| **PowerShell Obfuscation**     | Obfuscated Files or Information               | `T1027`      | Sysmon Event ID 1 — Process Creation       | Level 3–4      |
| **PowerShell Execution**       | Command and Scripting Interpreter: PowerShell | `T1059.001`  | Sysmon Event ID 1 — Process Creation       | Level 3–4      |
| **Scheduled Task Persistence** | Scheduled Task/Job: Scheduled Task            | `T1053.005`  | Sysmon Event ID 1 / Security Event ID 4698 | Level 4        |
| **LSASS Credential Dumping**   | OS Credential Dumping: LSASS Memory           | `T1003.001`  | Sysmon Event ID 10 — Process Access        | Level 10–15    |

## Verification & Evidence

### Master SIEM Proof

Live operational screenshots displaying real-time alert triggers are documented inside the `Evidence/` directory.

### Forensic Post-Mortem

The comprehensive incident breakdown, indicator analysis, detection results, and enterprise hardening recommendations are available in:

`Reports/threat-hunting-report.md`

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
