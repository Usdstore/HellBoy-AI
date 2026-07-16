param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("start","stop","restart","status","closeall")]
    [string]$Command
)

Clear-Host

. "$PSScriptRoot\modules\Common.ps1"
. "$PSScriptRoot\modules\Logger.ps1"
. "$PSScriptRoot\modules\Chrome.ps1"
. "$PSScriptRoot\modules\FCC.ps1"
. "$PSScriptRoot\modules\MCP.ps1"
. "$PSScriptRoot\modules\Claude.ps1"

Write-Host ""
Write-Host "========================================="
Write-Host "        HellBoy AI Control Center"
Write-Host "========================================="
Write-Host ""

switch ($Command) {

    "start" {

        Start-Chrome
        Start-FCC
        Start-MCP
        Start-Claude

    }

   "stop" {

    Write-Host ""
    Write-Host "========================================="
    Write-Host "       Stopping HellBoy AI"
    Write-Host "========================================="
    Write-Host ""

    # -------------------------------------------------
    # Claude
    # -------------------------------------------------
    Write-Host "Stopping Claude..."

    Get-Process claude -ErrorAction SilentlyContinue | Stop-Process -Force

    Start-Sleep 1

    if (Get-Process claude -ErrorAction SilentlyContinue) {
        Write-Host "[FAILED] Claude" -ForegroundColor Red
    }
    else {
        Write-Host "[OK] Claude" -ForegroundColor Green
    }

    # -------------------------------------------------
    # TradingView MCP
    # -------------------------------------------------
    Write-Host ""
    Write-Host "Stopping TradingView MCP..."

    wsl.exe bash -lc "pkill -f server.js" | Out-Null

    Start-Sleep 2

    $mcp = Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -eq "wsl.exe" -and
            $_.CommandLine -like "*tradingview-mcp-jackson*"
        }

    if ($mcp) {
        Write-Host "[FAILED] TradingView MCP" -ForegroundColor Red
    }
    else {
        Write-Host "[OK] TradingView MCP" -ForegroundColor Green
    }

    # -------------------------------------------------
    # FCC
    # -------------------------------------------------
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

    # -------------------------------------------------
    # Chrome
    # -------------------------------------------------
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
    Write-Host " Everything Stopped"
    Write-Host "========================================="
    Write-Host ""

}

    "restart" {

    Write-Host ""
    Write-Host "========================================="
    Write-Host "      Restarting HellBoy AI"
    Write-Host "========================================="
    Write-Host ""

    & $PSCommandPath stop

    Start-Sleep -Seconds 2

    & $PSCommandPath start

}

    "status" {

    Write-Host ""
    Write-Host "========================================="
    Write-Host "        HellBoy AI Status"
    Write-Host "========================================="
    Write-Host ""

    # Chrome
    if (Test-Port 9222) {
        Write-Host "[OK] Chrome CDP          ONLINE" -ForegroundColor Green
    }
    else {
        Write-Host "[--] Chrome CDP          OFFLINE" -ForegroundColor Red
    }

    # FCC
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

    # MCP
    $mcp = wsl.exe bash -lc "pgrep -f server.js"

    if ($mcp) {
    Write-Host "[OK] TradingView MCP     ONLINE" -ForegroundColor Green
    }
    else {
    Write-Host "[--] TradingView MCP     OFFLINE" -ForegroundColor Red
    }


    # Claude
    $claude = Get-Process -Name "claude" -ErrorAction SilentlyContinue

    if ($claude) {
        Write-Host "[OK] Claude Code         RUNNING" -ForegroundColor Green
    }
    else {
        Write-Host "[--] Claude Code         CLOSED" -ForegroundColor Red
    }

    Write-Host ""
}

    "closeall" {

        Write-Host "CloseAll function coming next..."

    }

}

Write-Host ""
Write-Host "Done."
Write-Host ""