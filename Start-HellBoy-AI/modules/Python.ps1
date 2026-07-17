function Invoke-PythonEngine {

    param(
        [string]$Arguments
    )

    $python = "python"

    & $python "$PSScriptRoot\..\python\main.py" $Arguments
}