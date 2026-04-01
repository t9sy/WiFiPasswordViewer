Write-Host "Saved Wi-Fi Passwords Viewer" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object { $_.ToString().Split(":")[1].Trim() }

if ($profiles.Count -eq 0) {
    Write-Host "No saved Wi-Fi profiles found on this computer." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "$("{0,-30}" -f 'Wi-Fi Network Name (SSID)') | Password" -ForegroundColor Green
    Write-Host "$('-'*30) | $('-'*20)" -ForegroundColor Green

    foreach ($profile in $profiles) {
        $passwordInfo = netsh wlan show profile name="$profile" key=clear | Select-String "Key Content"
        if ($passwordInfo) {
            $password = $passwordInfo.ToString().Split(":")[1].Trim()
        } else {
            $password = "[No Password / Open Network]"
        }
        Write-Host "$("{0,-30}" -f $profile) | $password"
    }
}
Write-Host ""
Read-Host "Press Enter to exit..."
