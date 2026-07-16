function Start-Chrome {

    Log "Checking Chrome CDP..."

    if (Test-Port 9222) {
        Log "[OK] Chrome already running."
        return
    }

    $Chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

    if (!(Test-Path $Chrome)) {
        Log "[ERROR] Chrome not found."
        throw "Chrome is not installed."
    }

    Log "Starting Chrome..."

    Start-Process `
        -FilePath $Chrome `
        -ArgumentList "--remote-debugging-port=9222 --user-data-dir=C:\ChromeCDP https://www.tradingview.com/chart/" `
        -WindowStyle Minimized

    if (Wait-Port 9222 30) {

        Log "[OK] Chrome CDP Ready."

    }
    else {

        Log "[ERROR] Chrome failed to start."

        throw "Chrome startup failed."

    }

}

function Stop-Chrome {

    Log "Stopping Chrome..."

    Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force

    Start-Sleep 2

    if (Test-Port 9222) {

        Log "[ERROR] Chrome is still running."

    }
    else {

        Log "[OK] Chrome stopped."

    }

}

function Get-ChromeStatus {

    if (Test-Port 9222) {

        Write-Host "Chrome CDP : ONLINE" -ForegroundColor Green

    }
    else {

        Write-Host "Chrome CDP : OFFLINE" -ForegroundColor Red

    }

}

function Restart-Chrome {

    Stop-Chrome

    Start-Sleep 2

    Start-Chrome

}