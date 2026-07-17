function Invoke-HellBoy {

    param(
        [string]$Command
    )

    Write-Host ""
    Write-Host "========================================="
    Write-Host " HellBoy AI Brain"
    Write-Host "========================================="

    switch -Regex ($Command) {

        "^analyze\s+" {
            Invoke-Trading $Command
            return
        }

        "^remember\s+" {
            Save-Memory $Command
            return
        }

        "^status$" {
            Show-Dashboard
            return
        }

        default {
            Write-Host "I don't know how to do that yet."
        }
    }

}