function Start-Claude {

    Log "Checking Claude..."

    $claude = Get-Process -Name "claude" -ErrorAction SilentlyContinue

    if ($claude) {
        Log "[OK] Claude already running."
        return
    }

    $cmd = @"
set ANTHROPIC_BASE_URL=http://localhost:8082
set ANTHROPIC_AUTH_TOKEN=freecc
cd /d C:\Users\Admin\Desktop\Start-HellBoy-AI
claude
"@

    $tmp = "$env:TEMP\start_claude.cmd"
    $cmd | Set-Content $tmp

    Start-Process cmd.exe `
    -ArgumentList "/k `"$tmp`""

    Log "[OK] Claude Started."

}