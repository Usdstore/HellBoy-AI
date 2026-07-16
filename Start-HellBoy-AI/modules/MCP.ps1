function Start-MCP {

    Log "Checking TradingView MCP..."

    $running = Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -eq "wsl.exe" -and
            $_.CommandLine -like "*tradingview-mcp-jackson*"
        }

    if ($running) {
        Log "[OK] TradingView MCP already running."
        return
    }

    Log "Starting TradingView MCP..."

    Start-Process `
    -WindowStyle Minimized `
    -FilePath "wsl.exe" `
    -ArgumentList 'bash -lc "cd ~/tradingview-mcp-jackson && nodejs src/server.js"'

    Start-Sleep -Seconds 3

    $running = Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -eq "wsl.exe" -and
            $_.CommandLine -like "*tradingview-mcp-jackson*"
        }

    if ($running) {
        Log "[OK] TradingView MCP Ready."
    }
    else {
        Log "[ERROR] TradingView MCP failed to start."
        throw "MCP Startup Failed"
    }

}