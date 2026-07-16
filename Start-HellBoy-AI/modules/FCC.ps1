function Start-FCC {

    Log "Checking FCC Server..."

    if (Test-Port 8082) {
        Log "[OK] FCC already running."
        return
    }

    Log "Starting FCC Server..."

    Start-Process `
    -WindowStyle Minimized `
    -FilePath "wsl.exe" `
    -ArgumentList 'bash -lc "source ~/venv/bin/activate && cd ~/fcc/nvidia-nim && free-claude-code"'

    Log "Waiting for FCC..."

    if (Wait-Port 8082 60) {

        Log "[OK] FCC Port Open."

        try {
            Invoke-WebRequest `
                -Uri "http://localhost:8082/v1/models" `
                -Headers @{ Authorization = "Bearer freecc" } `
                -TimeoutSec 5 `
                -ErrorAction Stop | Out-Null

            Log "[OK] FCC API Ready."
        }
        catch {
            Log "[WARNING] Port is open but API check failed."
            Log $_.Exception.Message
        }

    }
    else {

        Log "[ERROR] FCC failed to start."

        throw "FCC Startup Failed"

    }

}