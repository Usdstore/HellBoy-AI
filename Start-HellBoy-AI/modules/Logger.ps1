$LogFile = "$PSScriptRoot\..\logs\launcher.log"

function Log {

    param([string]$Text)

    $time = Get-Date -Format "HH:mm:ss"

    $line = "$time  $Text"

    Write-Host $line

    Add-Content $LogFile $line

}