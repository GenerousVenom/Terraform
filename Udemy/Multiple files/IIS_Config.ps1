Import-Module servermanager
Add-WindowsFeature web-server -IncludeAllSubFeature
Add-WindowsFeature web-asp-net45
Add-WindowsFeature NET-Framwork-Features
Set-Content -Path "C:\inetpub\wwwroot\Default.html" -Value "This is the server $($env:COMPUTERNAME)"