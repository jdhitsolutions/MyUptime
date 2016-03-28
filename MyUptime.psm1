#requires -version 4.0


#region Definitions

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

<#
.Synopsis
Get computer uptime.
.Description
This command will query the Win32_OperatingSystem class using Get-CimInstance and write an uptime object to the pipeline. You must run this with credentials that have administrator rights on the remote computer.

This PowerShell function is designed to make it easy to get uptime information for one or more remote computers. The command uses the CIM cmdlets so any remote computer must be running at least PowerShell 3.0 with remoting enabled. You can use computer names or existing CIM sessions. If you use a computer name you can also test to see if it is PowerShell v3 compatible.

The command includes custom format and type extensions with predefined table and list views. The function writes a custom object to the pipeline which includes several custom methods so that you can get additional time-related information. See examples.

The uptime information is calculated via a set of script properties. When you run the command and save the results to a variable, you will get updated information every time you look at the variable.
.Parameter Computername
The name of the computer to query. This parameter has an alias of CN and Name. The computer must be running PowerShell 3.0 or later with remoting enabled to support the CIM cmdlets.
.Parameter Test
Use Test-WSMan to verify computer can be reached and is running v3 or later of the Windows Management Framework stack.

.Example
PS C:\> get-myuptime chi-dc01,chi-fp02 

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-DC01         8/15/2015 11:36:23 AM      44     5       2      57
CHI-FP02         9/2/2015 2:06:22 PM        26     2      32      58

Formatted results for multiple computers. You can also pipe computer names into this command.

.Example
PS C:\> Get-myuptime | format-list

Computername : WIN81-ENT-01
LastReboot   : 9/21/2015 8:33:20 AM
Uptime       : 7.08:05:38

Get uptime for the local computer and use the custom list formatting view.
.Example
PS C:\> $c = "chi-dc01","chi-core01","chi-dc02","chi-hvr2","chi-dc04"
PS C:\> $c | get-myuptime -test | Sort LastRebootTime -Descending

WARNING: CHI-DC02 is not accessible via the WSMan protocol.

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-HVR2         9/22/2015 11:32:33 AM       6     5       1      40
CHI-CORE01       9/22/2015 11:18:45 AM       6     5      15      25
CHI-DC01         8/15/2015 11:36:23 AM      44     4      57      46
CHI-DC04         7/19/2015 12:15:26 AM      71    16      18      47

.Example
PS C:\> "chi-dc01","chi-core01","chi-hvr2","chi-dc04" | Get-myuptime | where Days -le 7

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-CORE01       9/22/2015 11:18:45 AM       6     5      37       7
CHI-HVR2         9/22/2015 11:32:33 AM       6     5      23      19

Get uptime for a list of computers and filter out those that have been running for longer than 7 days.

The first command creates an array of computer names. The second command gets uptime but tests each computer first.
.Example
PS C:\> get-myuptime "chi-dc01","chi-core01","chi-dc04" | Sort Uptime | Select Computername,Uptime

Computername                                                       Uptime
------------                                                       ------
CHI-DC01                                                           44.05:17:05.7159454
CHI-CORE01                                                         6.05:34:43.7282138
CHI-DC04                                                           71.16:38:02.2606952

Get uptime for a set of servers, sort on the uptime and display computername and uptime.

.Example
PS C:\> get-myuptime chi-dc01,chi-dc04,chi-core01 | tee -variable n

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-DC01         8/15/2015 11:36:23 AM      44     5      41      45
CHI-DC04         7/19/2015 12:15:26 AM      71    17       2      42
CHI-CORE01       9/22/2015 11:18:45 AM       6     5      59      23

Get uptime for a list of computers and also save results to a variable $N.

PS C:\> $n.gettimezone()

PSComputerName                    Caption                                           CurrentTimeZone
--------------                    -------                                           ---------------
CHI-DC01                          (UTC-05:00) Eastern Time (US ...                             -240
CHI-DC04                          (UTC-05:00) Eastern Time (US ...                             -240
CHI-CORE01                        (UTC-06:00) Central Time (US ...                             -300

Invoke the GetTimeZone() method on the custom object.

PS C:\> $n.getlocaltime()

PSComputerName                                    LocalDateTime
--------------                                    -------------
CHI-DC01                                          9/29/2015 8:41:57 AM
CHI-DC04                                          9/29/2015 8:41:30 AM
CHI-CORE01                                        9/29/2015 8:41:30 AM

Invoke the GetLocalTime() method on the custom object.

PS C:\> $sess = New-CimSession -computername "chi-dc01","chi-core01","chi-dc04","Chi-web02"

Create a collection of CIM sessions.

PS C:\> get-myuptime -CimSession $sess -OutVariable t

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-DC01         8/15/2015 11:36:23 AM      44    22      38      52
CHI-WEB02        6/14/2015 12:40:56 PM     106    21      34      19
CHI-DC04         7/19/2015 12:15:26 AM      72     9      59      49
CHI-CORE01       9/22/2015 11:18:45 AM       6    22      56      30

Get uptime via the CIM sessions.

PS C:\> $t.gettimezone() | format-table -AutoSize

Computername Caption                                CurrentTimeZone
------------ -------                                ---------------
CHI-DC01     (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-WEB02    (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-DC04     (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-CORE01   (UTC-06:00) Central Time (US & Canada)            -300

Get time zone information using the existing CIM sessions.

.Example
PS C:\> $c = gmu -Computername chi-core01

Get uptime for CHI-CORE01 using the Get-MyUptime alias and save results to variable $c.

PS C:\> $c

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-CORE01       9/22/2015 11:38:45 AM       7     0       1      39

Current results.

PS C:\> restart-computer $c.computername -force -Wait

Restart the computer.

PS C:\> $c.refresh()

Refresh the object.

PS C:\> $c

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-CORE01       9/29/2015 11:43:03 AM       0     0       2       9

New results.
.Notes
Last Updated: October 5, 2015
Version     : 3.1

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.Link
Get-Ciminstance
Test-WSMan

.Link
https://www.petri.com/how-to-create-a-powershell-module

.Inputs
[string[]]
[Microsoft.Management.Infrastructure.CimSession[]]

.Outputs
[My.Uptime]
#>

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
         Try {
                $obj = Get-CimInstance -classname Win32_OperatingSystem -cimsession $cimSession -ErrorAction Stop |
                Select-Object -property CSName,LastBootUpTime,@{Name="CimSession";Expression={$True}}

                #insert a new type name for the object for each
                #use the new ForEach if $obj is an array
                if ($obj -is [array]) {
                    ($obj).foreach({$_.psobject.Typenames.Insert(0,'My.Uptime')})
                }
                else {
                    $obj.psobject.Typenames.Insert(0,'My.Uptime')
                }

                #write the object to the pipeline
                $obj
            } #Try
            Catch {
               Write-Warning "[PROCESS] Failed to get CIM instance from $($cimsession.computername.toupper())"
               Write-Warning "[PROCESS] $($_.exception.message)"
            } #Catch

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
                $obj = Get-CimInstance -classname Win32_OperatingSystem -ComputerName $computer -ErrorAction Stop  | 
                Select-Object -property CSName,LastBootUpTime,@{Name="CimSession";Expression={$False}}

                #insert a new type name for the object
                $obj.psobject.Typenames.Insert(0,'My.Uptime')

                #write the object to the pipeline
                $obj
            } #Try
            Catch {
               Write-Warning "[PROCESS] Failed to get CIM instance from $($computer.toupper())"
               Write-Warning "[PROCESS] $($_.exception.message)"
            } #Catch

        } #if OK

         #reset variable so it doesn't accidentally get re-used, especially when using the ISE
         #ignore any errors if the variable doesn't exit
         Write-Verbose "[PROCESS] Removing obj variable"
         Remove-Variable -Name obj -ErrorAction SilentlyContinue
      
      } #foreach
    } #else
} #process

End {
    Write-Verbose "[END    ] Ending $($MyInvocation.Mycommand)"
} #end

} #end function

#endregion

#region Module options

#define a custom alias
Set-Alias -Name gmu -Value Get-MyUptime

#export function from module
Export-ModuleMember -Function Get-MyUptime -Alias *

#endregion
