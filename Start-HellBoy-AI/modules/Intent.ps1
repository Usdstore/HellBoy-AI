function Get-HellBoyIntent {

    param(
        [string]$Command
    )

    $cmd = $Command.ToLower().Trim()

    switch -Regex ($cmd) {

        "^analyze\s+" {
            return "Trading.Analyze"
        }

        "^scan\s+" {
            return "Trading.Scan"
        }

        "^find\s+best" {
            return "Trading.Best"
        }

        "^remember\s+" {
            return "Memory.Save"
        }

        "^status$" {
            return "System.Status"
        }

        default {
            return "Unknown"
        }
    }

}