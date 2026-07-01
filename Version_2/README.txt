=======================================
 Network Monitor - Rainmeter Skin 
=======================================

【架构说明】
本皮肤采用模块化设计：
- Network.ini   ：主界面文件，包含 UI 及 Rainmeter 原生网络数据采集逻辑。
- Variables.inc ：配置文件，包含字体样式及动态网卡名称。
- GetNetwork.ps1：自动化脚本，通过 PowerShell 抓取系统中活动的网卡名称，并覆写 Variables.inc。

【首次运行指南】
1. 将所有文件放在同一个目录下。
2. 在 Rainmeter 管理器中加载 `Network.ini`。
3. 默认情况下网卡名称为"以太网"和"WLAN"。
4. 皮肤加载后，【对着皮肤点击鼠标中键】即可触发自动检测：
   - 皮肤会在后台静默调用 GetNetwork.ps1
   - 脚本提取目前状态为 "Up" 的有线和无线网卡名称
   - 更新 Variables.inc 并自动 Refresh(刷新) 皮肤以显示最新数据。

【常见问题排查 (Troubleshooting)】
- Q: 点击中键后没有反应/未获取到 IP？
  A: 检查系统的 PowerShell 执行策略。如果系统完全禁用了脚本执行，请以管理员身份运行 PowerShell 并输入：
     Set-ExecutionPolicy RemoteSigned

- Q: 如果一台设备上有多个活跃网卡？
  A: GetNetwork.ps1 脚本默认抓取 Get-NetAdapter 列表中第一个处于活动状态的有线和无线网卡。如有更复杂的虚拟网卡环境，可根据设备具体情况修改 PS1 脚本中的过滤条件 (Where-Object)。
