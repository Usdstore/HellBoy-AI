function Invoke-HellBoy {

    param(
        [string]$Command
    )

    $intent = Get-HellBoyIntent $Command

    switch ($intent) {

        "Trading.Analyze" {
            Invoke-TradingAnalyze $Command
        }

        "Trading.Scan" {
            Invoke-TradingScan
        }

        "Trading.Best" {
            Invoke-TradingBest
        }

        "Memory.Save" {
            Save-Memory $Command
        }

        "System.Status" {
            Show-Dashboard
        }

        default {
            Write-Host "I don't understand that command yet." -ForegroundColor Yellow
        }

    }

}