function Show-Dashboard {

    Clear-Host

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                HellBoy AI Control Center" -ForegroundColor Green
    Write-Host "                      Version 1.0" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host (" Date : {0}" -f (Get-Date -Format "dd-MMM-yyyy"))
    Write-Host (" Time : {0}" -f (Get-Date -Format "HH:mm:ss"))
    Write-Host ""

    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " Services"
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray

    # Chrome
    if (Test-Port 9222) {
        Write-Host " Chrome CDP          [ONLINE]" -ForegroundColor Green
    }
    else {
        Write-Host " Chrome CDP          [OFFLINE]" -ForegroundColor Red
    }

    # FCC
     try {
    $response = Invoke-WebRequest `
        -Uri "http://localhost:8082/v1/models" `
        -Headers @{ Authorization = "Bearer freecc" } `
        -TimeoutSec 5 `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {
        Write-Host " FCC Server          [ONLINE]" -ForegroundColor Green
    }
    else {
        Write-Host " FCC Server          [OFFLINE]" -ForegroundColor Red
    }
    }
    catch {
    Write-Host " FCC Server          [OFFLINE]" -ForegroundColor Red
    }

    # MCP
    $mcp = wsl.exe bash -lc "pgrep -f server.js"

    if ($mcp) {
        Write-Host " TradingView MCP     [ONLINE]" -ForegroundColor Green
    }
    else {
        Write-Host " TradingView MCP     [OFFLINE]" -ForegroundColor Red
    }

    # Claude
    if (Get-Process claude -ErrorAction SilentlyContinue) {
        Write-Host " Claude Code         [RUNNING]" -ForegroundColor Green
    }
    else {
        Write-Host " Claude Code         [CLOSED]" -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}