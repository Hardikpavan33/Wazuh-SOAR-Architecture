# Wazuh-SOAR-Architecture
An automated SIEM & SOAR pipeline built with Wazuh, Sysmon, and PowerShell to detect and neutralize endpoint threats.

# Enterprise SIEM & SOAR Pipeline (Wazuh Active Response)

## 📌 Objective
The goal of this project is to engineer a centralized Security Information and Event Management (SIEM) environment with an automated Security Orchestration, Automation, and Response (SOAR) pipeline. This architecture detects malicious file creation on endpoint devices, queries global threat intelligence, and dynamically executes a custom PowerShell payload to neutralize the threat without human intervention.

## 🏗️ Architecture & Technologies
* **SIEM Manager:** Wazuh running on Ubuntu Server.
* **Endpoint Agent:** Windows 10 with Microsoft Sysmon configured for advanced telemetry.
* **Threat Intelligence:** VirusTotal API integration.
* **Automation (SOAR):** Custom PowerShell scripting & Windows Command Line wrappers.
* **Hypervisor:** VMware Workstation (bridged/NAT networking).

## ⚙️ The Automated Kill Chain (Workflow)
1. **Detection:** File Integrity Monitoring (FIM) detects a newly created file in a highly sensitive Windows directory.
2. **Analysis:** The Wazuh Manager extracts the file's SHA256 hash and queries the VirusTotal API.
3. **Alerting:** If VirusTotal flags the file as malicious, the SIEM generates a confirmed malware alert (Rule `87105`).
4. **Orchestration:** The Manager beams an Active Response command to the Windows endpoint, bypassing execution policies using a `.cmd` wrapper.
5. **Eradication:** A custom PowerShell script (`remove-threat.ps1`) intercepts the raw JSON alert data, extracts the precise file path, and force-deletes the malware.

## 📂 Repository Contents
* `remove-threat.ps1`: The core PowerShell payload responsible for parsing the incoming Wazuh JSON data, handling errors, and executing the removal command.
* `wrapper.cmd`: The batch script deployed to the Wazuh agent's `active-response/bin` directory to bridge the Linux manager's commands with the Windows PowerShell environment.
* `custom_rules.xml`: The modified Wazuh detection rules, including logic to capture dropped packets from Windows Defender Firewall and trigger the Active Response on VirusTotal alerts.

## 📸 Proof of Concept & Execution

<img width="1280" height="804" alt="wazuh dashboard image" src="https://github.com/user-attachments/assets/d4f1640c-3ce3-4faf-9073-775ddcf4e818" />

**Figure 1:** *Wazuh Dashboard successfully logging the Active Response pipeline firing on a confirmed threat.*


<img width="1280" height="948" alt="ar debug image" src="https://github.com/user-attachments/assets/8b4d39d5-2485-41bf-9491-881423024593" />

**Figure 2:** *Local endpoint forensic debug log proving the PowerShell script successfully extracted the target path and destroyed the malicious file.*

## 👤 Author
**Taddi Pavan Satish Kumar**
* LinkedIn Profile - https://www.linkedin.com/in/pavan-satish-kumar-7939ab2a1?utm_source=share_via&utm_content=profile&utm_medium=member_android
* Email: pavansatishkumar33@gmail.com
