function Test-Port {
    param([int]$Port)

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect("127.0.0.1",$Port)
        $tcp.Close()
        return $true
    }
    catch {
        return $false
    }
}

function Wait-Port {
    param(
        [int]$Port,
        [int]$Timeout = 30
    )

    for ($i = 1; $i -le $Timeout; $i++) {

        if (Test-Port $Port) {
            return $true
        }

        Log "Waiting... ($i/$Timeout)"

        Start-Sleep -Seconds 1
    }

    return $false
}