Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' } | ForEach-Object {
    $ProcessId = $_.OwningProcess
    $Process = Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        ProcessName = $Process.ProcessName
        PortNumber = $_.LocalPort
    }
}
