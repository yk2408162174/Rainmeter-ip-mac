# 获取当前目录
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$incFile = Join-Path $scriptDir "Variables.inc"

# 定义更新函数
function Update-NetworkVariables {
    $allAdapters = Get-NetAdapter | Where-Object { $_.Virtual -eq $false }
    $ethAdapter = $allAdapters | Where-Object { $_.Status -eq 'Up' -and $_.MediaType -eq '802.3' } | Select-Object -First 1
    $wifiAdapter = $allAdapters | Where-Object { $_.Status -eq 'Up' -and ($_.MediaType -eq 'Native 802.11' -or $_.Name -match "Wi-Fi|WLAN") } | Select-Object -First 1
    
    $ethName = if ($ethAdapter) { $ethAdapter.Name } else { "以太网" }
    $wifiName = if ($wifiAdapter) { $wifiAdapter.Name } else { "WLAN" }
    
    $config = Get-Content $incFile
    $newConfig = $config | ForEach-Object {
        if ($_ -match "^AdapterEthernet=") { "AdapterEthernet=$ethName" }
        elseif ($_ -match "^AdapterWiFi=") { "AdapterWiFi=$wifiName" }
        else { $_ }
    }
    $newConfig | Set-Content $incFile -Encoding Unicode
}

# 初始运行一次
Update-NetworkVariables

# 监听网络连接状态变更事件 (当任何网卡状态发生变化时自动执行)
Register-WmiEvent -Query "SELECT * FROM __InstanceModificationEvent WITHIN 5 WHERE TargetInstance ISA 'MSFT_NetAdapter'" -Action {
    Update-NetworkVariables
    # 这一行是通过 rainmeter.exe 发送刷新皮肤的命令
    & "C:\Program Files\Rainmeter\Rainmeter.exe" !Refresh
}