#requires -version 5.0

#define a private function to be used in this command
Function IsWsManAvailable {
[cmdletbinding()]
Param([string]$Computername)

Write-Verbose "Testing WSMan for $computername"
Try {
    $text = (Test-WSMan $computername -ErrorAction Stop).lastchild.innertext
    Write-Verbose $Text
    if ($text.Split(":")[-1] -as [double] -ge 3) {
        $True
    }
    else {
        $False
    }
} #Try
Catch {
    #failed to run Test-WSMan most likely due to name resolution or offline state
    $False
} #Catch
} #close IsWsManAvailable

Function Get-MyUptime {


[cmdletbinding(DefaultParameterSetName="Name")]

Param(
[Parameter(
    Position=0,
    ValueFromPipeline,
    ValueFromPipelineByPropertyName,
    ParameterSetName = "Name"
)]
[ValidateNotNullorEmpty()]
[Alias("cn","name")]
[String[]]$Computername = $env:Computername,

[Parameter(ParameterSetName = "Name")]
[Switch]$Test,

[Parameter(
    ValueFromPipeline,
    ParameterSetName="Session"
)]
[ValidateNotNullorEmpty()]
[Microsoft.Management.Infrastructure.CimSession[]]$CimSession

)

Begin {
    Write-Verbose "[BEGIN  ] Starting $($MyInvocation.Mycommand)"  
    Write-Verbose "[BEGIN  ] PSBoundParameters"
    Write-Verbose  ($PSBoundParameters | Out-String).Trim()
} #begin

Process {
 Write-Verbose "[PROCESS] Using parameter set $($PSCmdlet.ParameterSetName)"
    if ($PSCmdlet.ParameterSetName -eq "Session") {
        Write-Verbose "[PROCESS] Getting uptime via existing CIMSessions"
        foreach ($session in $cimsession) {
         Try {
                $ErrorActionPreference = "Stop"
                [MyUptime]::New($session)
                
            } #Try
            Catch {
               Write-Warning "[PROCESS] Failed to get CIM instance from $($session.computername.toupper())"
               Write-Warning "[PROCESS] $($_.exception.message)"
            } #Catch
        } #foreach session
    } #if using Sessions
    else {
    #process computer names individually in case we have to test
    Foreach ($computer in $computername) {
        Write-Verbose "[PROCESS] Processing $($computer.toUpper())"
        if ($Test -AND (IsWsManAvailable -Computername $computer)) { 
           $OK = $True
          } 
        elseif ($Test -AND -Not (IsWsManAvailable -Computername $computer)){
            $OK = $False
            Write-Warning "[PROCESS] $($Computer.toUpper()) is not accessible via the WSMan protocol."
          }
        else {
            #no testing so assume OK to proceed
            $OK = $True
        }
            
        #get uptime if OK
        if ($OK) {
            Write-Verbose "[PROCESS] Getting uptime from $($computer.toUpper())"
            Try {
                $ErrorActionPreference = "Stop"
                [MyUptime]::New($computer)
            } #Try
            Catch {
               Write-Warning "[PROCESS] Failed to get CIM instance from $($computer.toupper())"
               Write-Warning "[PROCESS] $($_.exception.message)"
            } #Catch

        } #if OK

         
      } #foreach
    } #else
} #process

End {
    Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
} #end

} #end function

Function Get-MyTimeZone {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory, ValueFromPipeline )]
[ValidateNotNullorEmpty()]
[MyUptime[]]$ComputerObject
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {
    foreach ($item in $computerObject) {
        Write-Verbose "Processing $($item.Computername)"
        $obj = $item.GetTimezone()
        $obj.psobject.typenames.insert(0,"myTimeZone")
        $obj
    }

} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

}

Function Get-MyLocalTime {
[cmdletbinding()]
Param(
[Parameter(Position = 0, ValueFromPipeline, Mandatory)]
[ValidateNotNullorEmpty()]
[MyUptime[]]$ComputerObject
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {
    foreach ($item in $computerObject) {
        Write-Verbose "Processing $($item.Computername)"
        $obj = $item.GetLocalTime()
        $obj.psobject.typenames.insert(0,"myLocalTime")
        $obj
    }

} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

}

Function Update-MyUptime {
[cmdletbinding()]
Param(
[Parameter(Position = 0, ValueFromPipeline, Mandatory)]
[ValidateNotNullorEmpty()]
[MyUptime[]]$ComputerObject,
[switch]$Passthru
)

Begin {
    Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"  
} #begin

Process {
    foreach ($item in $computerObject) {
        Write-Verbose "Processing $($item.Computername)"
        $item.Refresh()
        
        if ($Passthru) {
            $item
        }
    }

} #process

End {
    Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
} #end

}
