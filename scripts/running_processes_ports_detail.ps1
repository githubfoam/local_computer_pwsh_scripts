Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' } | ForEach-Object {
    $ProcessId = $_.OwningProcess
    $Process = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        ProcessName    = $Process.ProcessName
        Protocol       = $_.Protocol
        LocalAddress   = $_.LocalAddress
        LocalPort      = $_.LocalPort
        RemoteAddress  = $_.RemoteAddress
        RemotePort     = $_.RemotePort
        State          = $_.State
    }
} | Format-Table -AutoSize
