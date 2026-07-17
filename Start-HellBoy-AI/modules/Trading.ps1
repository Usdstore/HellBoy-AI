function Invoke-TradingAnalyze {

    param([string]$Command)

    $symbol = ($Command -replace "(?i)^analyze\s+","").Trim().ToUpper()

    Analyze-Coin $symbol

}