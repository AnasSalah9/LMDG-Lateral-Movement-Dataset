# IT_Behavioural_Script.ps1

# Define tasks and their weights
$tasks = @{
    "BrowsingInternet" = @{
        "Weight" = 20
        "Options" = @{
            "https://www.google.com" = 4
            "https://www.reddit.com" = 3
            "https://www.microsoft.com" = 3
            "https://www.cisco.com/c/en/us/support/index.html" = 3
            "https://kb.vmware.com/" = 4
            "https://oriondemo.solarwinds.com/" = 3
            "https://nagios.org/" = 3
            "https://www.zabbix.com/" = 3
            "https://www.nist.gov/" = 4
            "https://www.sans.org/" = 3
            "https://owasp.org/" = 3
            "https://stackoverflow.com/" = 4
            "https://community.spiceworks.com/" = 3
            "https://www.reddit.com/r/sysadmin/" = 3
            "https://portal.azure.com/" = 3
            "https://aws.amazon.com/console/" = 3
            "https://console.cloud.google.com/" = 3
            "https://www.veeam.com/" = 4
            "https://www.acronis.com/" = 3
            "https://www.ansible.com/products/awx-project" = 3 
            "https://my.vmware.com/" = 3
            "https://hub.docker.com/" = 4
            "https://docs.microsoft.com/" = 3
            "https://puppet.com/" = 3
	    "http://192.168.58.13/maintanance.html" = 3
	    "http://192.168.58.13/about.html" = 3
	    "http://192.168.58.13/construction.html" = 3
	    "http://192.168.58.13/contact.html" = 3
	    "http://192.168.58.13/welcome.html" = 3
	    "http://192.168.58.13/it.html" = 3


            "https://www.facebook.com/" = 1
            "https://www.twitter.com/" = 1
            "https://www.linkedin.com/" = 1
            "https://www.instagram.com/" = 1
            "https://www.tiktok.com/" = 1
            "https://www.snapchat.com/" = 1
            
            
            "https://www.cnn.com/" = 2
            "https://www.bbc.com/news" = 2
            "https://www.nytimes.com/" = 2
            "https://www.theguardian.com/" = 2
            "https://www.aljazeera.com/" = 2
            "https://www.foxnews.com/" = 2
            "https://www.bloomberg.com/" = 2

        }
    }
    "AccessingShares" = @{
        "Weight" = 10
        "Options" = @{
            
            "\\DB-Server.servers.lmt.com\AllShares\IT\Infrastructure\Servers\server1_config.txt" = 10
            "\\DB-Server.servers.lmt.com\AllShares\IT\Infrastructure\Network\network_diagram.docx" = 10
            "\\DB-Server.servers.lmt.com\AllShares\IT\Infrastructure\Security\security_policy.docx" = 10

            "\\DB-Server.servers.lmt.com\AllShares\IT\Documentation\Policies\IT_Policies.docx" = 10
            "\\DB-Server.servers.lmt.com\AllShares\IT\Documentation\Procedures\IT_Procedures.docx" = 10

            "\\DB-Server.servers.lmt.com\AllShares\IT\Tools\MonitoringTool.exe" = 10
            "\\DB-Server.servers.lmt.com\AllShares\IT\Tools\BackupScript.ps1" = 10

            "\\DB-Server.servers.lmt.com\AllShares\IT\Resources\Templates\IT_Template.docx" = 10
            "\\DB-Server.servers.lmt.com\AllShares\IT\Resources\Guidelines\IT_Guidelines.docx" = 20


        }
    }
    "RunningLocalPrograms" = @{
        "Weight" = 15
        "Options" = @{
            "ServerManager.exe" = 3  #(Server Manager)
            "compmgmt.msc" = 3  #(Computer Management)
            "powershell.exe" = 3  #(PowerShell)
            "eventvwr.exe" = 3  #(Event Viewer)
            "taskmgr.exe" = 3  #(Task Manager)
            "resmon.exe" = 3  #(Resource Monitor)
            "perfmon.exe" = 3  #(Performance Monitor)
            "regedit.exe" = 3  #(Registry Editor)
            "gpmc.msc" = 3  #(Group Policy Management Console)
            "dsa.msc" = 3  #(Active Directory Users and Computers)
            "dnsmgmt.msc" = 3  #(DNS Manager)
            "dhcpmgmt.msc" = 3  #(DHCP Manager)
            "mmc.exe" = 3  #(Microsoft Management Console)
            "services.msc" = 3  #(Services Manager)
            "diskmgmt.msc" = 3  #(Disk Management)
            "devenv.exe" = 3  #(Visual Studio, if installed for development purposes)
            "mstsc.exe" = 3  #(Remote Desktop Connection)
            "control.exe" = 3  #(Control Panel)
            "gpedit.msc" = 3  #(Local Group Policy Editor)
            "sysdm.cpl" = 3  #(System Properties)
            "notepad.exe" = 3  #(Notepad)
            "msinfo32.exe" = 3  #(System Information)
            "lusrmgr.msc" = 3  #(Local Users and Groups Manager)
            "secpol.msc" = 3  #(Local Security Policy)
            "regedt32.exe" = 3  #(Advanced Registry Editor)
            "odbcad32.exe" = 3  #(ODBC Data Source Administrator)
            "wbadmin.msc" = 3  #(Windows Server Backup)
            "eventvwr.msc" = 3  #(Event Viewer)
            "winver.exe" = 3  #(Windows Version Information)
            "sconfig.cmd" = 4  #(Server Configuration Tool)

        }
    }
    "CreatingDeletingFiles" = @{
        "Weight" = 10
        "Options" = @{
            "CreateFile" = 50
            "DeleteFile" = 50
        }
    }
    "DownloadingFiles" = @{
        "Weight" = 10
        "Options" = @{

            "https://github.com/weechat/weechat/blob/master/src/core/core-config-file.c" = 10
            "https://github.com/wasm3/wasm3/blob/main/source/m3_bind.c" = 10
            "https://github.com/AutoHotkey/AutoHotkey/blob/alpha/source/ahkversion.h" = 10
            "https://github.com/AutoHotkey/AutoHotkey/blob/alpha/source/MdFunc.cpp" = 10
            "https://github.com/swiftbar/SwiftBar/blob/main/SwiftBar/AppShared.swift" = 10
            "https://github.com/swiftbar/SwiftBar/blob/main/SwiftBar/AppDelegate%2BIntents.swift" = 10
            "https://github.com/kellyjonbrazil/jello/blob/master/man/jello.1" = 10
            "https://github.com/kellyjonbrazil/jello/blob/master/build-package.sh" = 10
            "https://github.com/SwiftOnSecurity/sysmon-config/blob/master/sysmonconfig-export.xml" = 10
            "https://download.sysinternals.com/files/Sysmon.zip" = 10
        }
    }
    "RemoteAccess" = @{
        "Weight" = 10
        "Options" = @{
            "lmt.com" = 10
            "servers.lmt.com" = 20
            "sales.lmt.com" = 10
            "hr.lmt.com" = 10
            "dev.lmt.com" = 10
            "marketing.lmt.com" = 10
            "jump-server.it.lmt.com" = 10
            "db-server.servers.lmt.com" = 10
            "mail-server.servers.lmt.com" = 10
        }
    }
    "UserManagement" = @{
        "Weight" = 5
        "Options" = @{
            "AddUser" = 50
            "RemoveUser" = 50
        }
    }
    "NetworkManagement" = @{
        "Weight" = 5
        "Options" = @{
            "NetworkRestart" = 100
        }
    }
    "SystemMonitor" = @{
        "Weight" = 10
        "Options" = @{
            "CheckCPU" = 50
            "CheckMemory" = 50
        }
    }
    "BackupManagement" = @{
        "Weight" = 5
        "Options" = @{
            "StartBackup" = 50
            "StopBackup" = 50
        }
    }
}

# Function to select a random item based on weight
function Get-RandomWeighted {
    param (
        [hashtable]$items
    )
    $sum = ($items.Values | Measure-Object -Sum).Sum
    $rand = Get-Random -Maximum $sum
    $current = 0
    foreach ($key in $items.Keys) {
        $current += $items[$key]
        if ($rand -lt $current) {
            return $key
        }
    }
}

# Construct a hashtable with task names and their weights
$taskWeights = @{}
foreach ($key in $tasks.Keys) {
    $taskWeights[$key] = $tasks[$key].Weight
}

# Select a task based on weight
$taskName = Get-RandomWeighted $taskWeights
$task = $tasks[$taskName]

# Select an option for the task based on weight
$option = Get-RandomWeighted $task.Options

Write-Host "Selected Task: $taskName"
Write-Host "Selected Option: $option"

# Execute the selected task and option
switch ($taskName) {
    "BrowsingInternet" {
        Start-Process curl -ArgumentList $option -NoNewWindow -PassThru
    }
    "AccessingShares" {
        # Assuming accessing share means mapping a drive
        Get-Content $option
    }
    "RunningLocalPrograms" {
        Start-Process $option
    }
    "CreatingDeletingFiles" {
        $filePath = "C:\Temp\testfile.txt"
        if ($option -eq "CreateFile") {
            New-Item -Path $filePath -ItemType File -Force
        } elseif ($option -eq "DeleteFile") {
            Remove-Item -Path $filePath -Force
        }
    }
    "DownloadingFiles" {
        $destPath = "C:\Temp\" + [System.IO.Path]::GetFileName($option)
        Invoke-WebRequest -Uri $option -OutFile $destPath
    }
    "RemoteAccess" {
        # Example of remote access (Ping for simplicity)
        Test-Connection -ComputerName $option -Count 1
    }
    "UserManagement" {
        if ($option -eq "AddUser") {
            New-LocalUser -Name "TestUser" -Password (ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force)
        } elseif ($option -eq "RemoveUser") {
            Remove-LocalUser -Name "TestUser"
        }
    }
    "NetworkManagement" {
        if ($option -eq "NetworkRestart") {
            Restart-Service -Name "Network"
        }
    }
    "SystemMonitor" {
        if ($option -eq "CheckCPU") {
            Get-WmiObject -Class Win32_Processor | Select-Object -Property LoadPercentage
        } elseif ($option -eq "CheckMemory") {
            Get-WmiObject -Class Win32_OperatingSystem | Select-Object -Property FreePhysicalMemory
        }
    }
    "BackupManagement" {
        if ($option -eq "StartBackup") {
            # Assuming a backup command (replace with actual command)
            Write-Host "Starting Backup"
        } elseif ($option -eq "StopBackup") {
            # Assuming a backup stop command (replace with actual command)
            Write-Host "Stopping Backup"
        }
    }
}
