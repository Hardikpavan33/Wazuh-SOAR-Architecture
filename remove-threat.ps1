# 1. Read the incoming Wazuh JSON data
$jsonString = [Console]::In.ReadLine()
$logFile = "C:\SensitiveData\ar-debug.txt"

# 2. Start writing our forensic log
Add-Content -Path $logFile -Value "=== ACTIVE RESPONSE TRIGGERED ==="
Add-Content -Path $logFile -Value "RAW JSON RECEIVED: $jsonString"

# 3. Parse the JSON
$inputJson = $jsonString | ConvertFrom-Json

# 4. Extract the paths
$fimPath = $inputJson.parameters.alert.syscheck.path
$vtPath = $inputJson.parameters.alert.data.virustotal.source.file

Add-Content -Path $logFile -Value "Extracted FIM Path: $fimPath"
Add-Content -Path $logFile -Value "Extracted VT Path: $vtPath"

# 5. Determine which path to use
$targetPath = $fimPath
if ([string]::IsNullOrEmpty($targetPath)) { 
    $targetPath = $vtPath 
}

Add-Content -Path $logFile -Value "Final Target Path: $targetPath"

# 6. Attempt the kill and log the result
if ($targetPath -and (Test-Path $targetPath)) {
    Remove-Item -Path $targetPath -Force
    Add-Content -Path $logFile -Value "RESULT: Target Destroyed!"
} else {
    Add-Content -Path $logFile -Value "RESULT: Could not find the file to delete."
}
Add-Content -Path $logFile -Value "================================="
