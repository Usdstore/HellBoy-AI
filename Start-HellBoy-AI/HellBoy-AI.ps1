Clear-Host

# ============================================================
# Load Modules
# ============================================================

. "$PSScriptRoot\modules\Common.ps1"
. "$PSScriptRoot\modules\Logger.ps1"
. "$PSScriptRoot\modules\Chrome.ps1"
. "$PSScriptRoot\modules\FCC.ps1"
. "$PSScriptRoot\modules\MCP.ps1"
. "$PSScriptRoot\modules\Claude.ps1"
. "$PSScriptRoot\modules\Dashboard.ps1"
. "$PSScriptRoot\modules\Brain.ps1"
. "$PSScriptRoot\modules\Trading.ps1"

# ============================================================
# Main Menu Loop
# ============================================================

while ($true) {

    Show-Dashboard

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "         HellBoy AI Control Center" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "  [1] Start HellBoy AI" -ForegroundColor White
    Write-Host "  [2] Stop HellBoy AI" -ForegroundColor White
    Write-Host "  [3] Restart HellBoy AI" -ForegroundColor White
    Write-Host "  [4] Status" -ForegroundColor White
    Write-Host "  [0] Exit" -ForegroundColor DarkGray

    Write-Host ""

    $Command = Read-Host "Select an option"

    switch ($Command.ToLower()) {
        '1' { $command = 'start'; break }
        'start' { $command = 'start'; break }

        '2' { $command = 'stop'; break }
        'stop' { $command = 'stop'; break }

        '3' { $command = 'restart'; break }
        'restart' { $command = 'restart'; break }

        '4' { $command = 'status'; break }
        'status' { $command = 'status'; break }

        '0' { break }
        'exit' { break }

        default {
            Write-Host ""
            Write-Host "Invalid Option!" -ForegroundColor Red
            Read-Host "Press ENTER"
            continue
        }
    }


   Clear-Host

    switch ($command) {

    "start" {

        Clear-Host

        Start-Chrome
        Start-FCC
        Start-MCP
        Start-Claude

        Write-Host ""
        Write-Host "========================================="
        Write-Host " HellBoy AI Started Successfully"
        Write-Host "=========================================" -ForegroundColor Green
    }

    "stop" {

        Write-Host ""
        Write-Host "========================================="
        Write-Host "       Stopping HellBoy AI"
        Write-Host "========================================="
        Write-Host ""

        # Claude
        Write-Host "Stopping Claude..."

        Get-Process claude -ErrorAction SilentlyContinue | Stop-Process -Force

        Start-Sleep 1

        if (Get-Process claude -ErrorAction SilentlyContinue) {
            Write-Host "[FAILED] Claude" -ForegroundColor Red
        }
        else {
            Write-Host "[OK] Claude" -ForegroundColor Green
        }

        # MCP
        Write-Host ""
        Write-Host "Stopping TradingView MCP..."

        wsl.exe bash -lc "pkill -f server.js" | Out-Null

        Start-Sleep 2

        $mcp = wsl.exe bash -lc "pgrep -f server.js"

        if ($mcp) {
            Write-Host "[FAILED] TradingView MCP" -ForegroundColor Red
        }
        else {
            Write-Host "[OK] TradingView MCP" -ForegroundColor Green
        }

        # FCC
        Write-Host ""
        Write-Host "Stopping FCC..."

        wsl.exe bash -lc "pkill -f free-claude-code" | Out-Null

        Start-Sleep 2

        try {

            Invoke-WebRequest `
                -Uri "http://localhost:8082/v1/models" `
                -Headers @{ Authorization = "Bearer freecc" } `
                -TimeoutSec 2 | Out-Null

            Write-Host "[FAILED] FCC" -ForegroundColor Red

        }
        catch {

            Write-Host "[OK] FCC" -ForegroundColor Green

        }

        # Chrome
        Write-Host ""
        Write-Host "Stopping Chrome..."

        Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force

        Start-Sleep 2

        if (Test-Port 9222) {
            Write-Host "[FAILED] Chrome" -ForegroundColor Red
        }
        else {
            Write-Host "[OK] Chrome" -ForegroundColor Green
        }

        Write-Host ""
        Write-Host "========================================="
        Write-Host " HellBoy AI Stopped Successfully"
        Write-Host "=========================================" -ForegroundColor Green

    }

    "restart" {

        Write-Host ""
        Write-Host "Restarting HellBoy AI..." -ForegroundColor Yellow
        Write-Host ""

        Get-Process claude -ErrorAction SilentlyContinue | Stop-Process -Force
        wsl.exe bash -lc "pkill -f server.js" | Out-Null
        wsl.exe bash -lc "pkill -f free-claude-code" | Out-Null
        Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force

        Start-Sleep 2

        Start-Chrome
        Start-FCC
        Start-MCP
        Start-Claude

        Write-Host ""
        Write-Host "========================================="
        Write-Host " Restart Completed Successfully"
        Write-Host "=========================================" -ForegroundColor Green

    }

    "status" {

        Write-Host ""
        Write-Host "========================================="
        Write-Host "        HellBoy AI Status"
        Write-Host "========================================="
        Write-Host ""

        if (Test-Port 9222) {
            Write-Host "[OK] Chrome CDP          ONLINE" -ForegroundColor Green
        }
        else {
            Write-Host "[--] Chrome CDP          OFFLINE" -ForegroundColor Red
        }

        try {
            Invoke-WebRequest `
                -Uri "http://localhost:8082/v1/models" `
                -Headers @{ Authorization = "Bearer freecc" } `
                -TimeoutSec 2 | Out-Null

            Write-Host "[OK] FCC Server          ONLINE" -ForegroundColor Green
        }
        catch {
            Write-Host "[--] FCC Server          OFFLINE" -ForegroundColor Red
        }

        $mcp = wsl.exe bash -lc "pgrep -f server.js"

        if ($mcp) {
            Write-Host "[OK] TradingView MCP     ONLINE" -ForegroundColor Green
        }
        else {
            Write-Host "[--] TradingView MCP     OFFLINE" -ForegroundColor Red
        }

        if (Get-Process claude -ErrorAction SilentlyContinue) {
            Write-Host "[OK] Claude Code         RUNNING" -ForegroundColor Green
        }
        else {
            Write-Host "[--] Claude Code         CLOSED" -ForegroundColor Red
        }

    }

    default {

        Write-Host ""
        Write-Host "Unknown Command" -ForegroundColor Red

    }
 }

    Write-Host ""
    Read-Host "Press ENTER to return to the menu"

} 