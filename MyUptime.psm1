#requires -version 4.0


Class MyUptime {

#properties
[string]$Computername
[datetime]$LastRebootTime
[timespan]$Uptime
[int]$Days
[int]$Hours
[int]$Minutes
[int]$Seconds
hidden[boolean]$CimSession

#methods
[void]Refresh() {
    $cimParams = @{
        Classname = "Win32_Operatingsystem"
        ErrorAction = "Stop"
    }
    If ($this.CimSession) {
        $cimParams.Add("CimSession",(Get-CimSession -computername $this.computername))
    }
    else {
        $cimParams.Add("Computername",$this.Computername)
    }
    Try {
        $data = Get-CimInstance @cimParams

        $this.LastRebootTime = $data.LastBootUpTime
        $Up = (Get-Date) - $data.LastBootUpTime
        $this.Uptime = $Up
        $this.Days = $up.Days
        $this.Hours = $up.Hours
        $this.Minutes = $up.Minutes
        $this.Seconds = $up.Seconds
    }
    Catch {
        Write-Error $_
    }
}

[object]GetTimeZone() {
  $cimHash = @{
    Classname = "Win32_TimeZone"
    Property = "Caption"
    }

    If ($this.CimSession) {
        $cimHash.Add("CimSession",(Get-CimSession -computername $this.computername))
    }
    else {
        $cimHash.Add("Computername",$this.computername)
    }
    $result = Get-CimInstance @cimHash | 
    Select-Object -Property @{Name="Computername";Expression={$_.PSComputername.ToUpper()}},
    Caption,@{Name="CurrentTimeZone";Expression={ ($_ | Get-CimAssociatedInstance).CurrentTimeZone}}
    return $result
}

[object]GetLocalTime() {
    $cimHash = @{
      Classname = "Win32_OperatingSystem"
     Property = "LocalDateTime","CSName"
    }
    If ($this.CimSession) {
        $cimHash.Add("CimSession",(Get-CimSession -computername $this.computername))
    }
    else {
    $cimHash.Add("Computername",$this.computername)
    }
              
    $data = Get-CimInstance @cimHash | Select-Object -Property @{Name="Computername";Expression={$_.CSName}},
    LocalDateTime
 return $data
}


#constructors
MyUptime ( [Microsoft.Management.Infrastructure.CimSession]$CimSession) {
 
  Try {
    $data = Get-CimInstance -classname Win32_OperatingSystem -cimsession $CimSession -ErrorAction Stop
    Write-Verbose ($data | Out-String)
    $this.Computername = $data.CSName
    $this.LastRebootTime = $data.LastBootUpTime
    $this.CimSession = $True
    $Up = (Get-Date) - $data.LastBootUpTime
    $this.Uptime = $Up
    $this.Days = $up.Days
    $this.Hours = $up.Hours
    $this.Minutes = $up.Minutes
    $this.Seconds = $up.Seconds
    
  }
  catch {
    Write-Error "[$($CimSession.Computername)] $($_.exception.message)"
  }
  
}

MyUptime ([string]$Computername) {

  Try {
    $data = Get-CimInstance -classname Win32_OperatingSystem -ComputerName $computername -ErrorAction Stop
    Write-Verbose ($data | Out-String)
    $this.Computername = $data.CSName
    $this.LastRebootTime = $data.LastBootUpTime
    $Up = (Get-Date) - $data.LastBootUpTime
    $this.Uptime = $Up
    $this.Days = $up.Days
    $this.Hours = $up.Hours
    $this.Minutes = $up.Minutes
    $this.Seconds = $up.Seconds
   
  }
  catch {
    Write-Error "[$computername] $($_.exception.message)"
  }

}

} #end class

#load external functions
. $PSScriptRoot\MyUptimeFunctions.ps1

#region Module options

#define a custom alias
Set-Alias -Name gmu -Value Get-MyUptime
Set-Alias -name gtz -Value Get-MyTimeZone
Set-Alias -Name glt -Value Get-MyLocalTime
Set-Alias -Name umu -Value Update-MyUptime

#endregion
