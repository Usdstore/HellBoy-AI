function Get-RSI {

    param(
        [array]$Candles,
        [int]$Period = 14
    )

    Write-Host "RSI calculation coming..."
}

function Get-EMA {

    param(
        [array]$Candles,
        [int]$Period
    )

    Write-Host "EMA calculation coming..."
}

function Get-MACD {

    param(
        [array]$Candles
    )

    Write-Host "MACD calculation coming..."
}