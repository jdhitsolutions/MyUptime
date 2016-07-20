# MyUptime
## about_MyUptime

# SHORT DESCRIPTION
The commands in this module are intended to make it easier to get uptime data
from your servers. The commands rely on WSMan and the Get-Ciminstance cmdlet to
get information from the Win32_OperatingSystem class.

# LONG DESCRIPTION
You can run these commands from any computer running PowerShell 5.0. The remote
computer must be running at least PowerShell 3.0 and be able to respond to the
Test-WSMan cmdlet. The default behavior is to use a computer name, but you can
also use a pre-defined CimSession.

The commands in this module will write a custom object to the pipeline. The
main command will create an uptime object. You can use this object to pipe to
other commands to get time zone and local time information.

## EXAMPLES
Get a quick check on a single server:
```
PS C:\> Get-MyUptime chi-core01

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-CORE01       7/18/2016 3:33:12 PM        1    18      51      29
```
Get uptime from multiple servers using the custom table view:
```
PS C:\> Get-MyUptime chi-core01,chi-p50,chi-fp02 | format-table -view uptime

Computername     LastRebootTime                        Uptime
------------     --------------                        ------
CHI-CORE01       7/18/2016 3:33:12 PM      1.18:52:39.6824738
CHI-P50          7/20/2016 9:59:29 AM        00:26:22.7829936
CHI-FP02         6/15/2016 1:07:42 PM     34.21:18:09.9342691
```
Using CIM Sessions:
```
PS C:\> $cs = New-CimSession chi-core01,chi-p50,chi-fp02,chi-dc04
PS C:\> $cs | Get-MyUptime -outvariable up| Sort Uptime -Descending

Computername     LastRebootTime           Days Hours Minutes Seconds
------------     --------------           ---- ----- ------- -------
CHI-FP02         6/15/2016 1:07:42 PM       34    21      20      37
CHI-DC04         7/5/2016 4:36:59 PM        14    17      51      20
CHI-CORE01       7/18/2016 3:33:12 PM        1    18      55       8
CHI-P50          7/20/2016 9:59:29 AM        0     0      28      51
```
The preceding example also saved the output to a variable which can be used
later to get time zone and local time information.
```
PS C:\> $up | Get-MyTimeZone

Computername Caption                                CurrentTimeZone
------------ -------                                ---------------
CHI-P50      (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-DC04     (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-FP02     (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-CORE01   (UTC-06:00) Central Time (US & Canada)            -300

PS C:\> $up | Get-MyLocalTime

Computername LocalDateTime
------------ -------------
CHI-P50      7/20/2016 10:28:42 AM
CHI-DC04     7/20/2016 10:28:42 AM
CHI-FP02     7/20/2016 10:28:42 AM
CHI-CORE01   7/20/2016 10:28:42 AM
```
Finally, when using a variable, you may want to refresh it to get current
data. 
```
PS C:\> $up | select computername,uptime

Computername Uptime
------------ ------
CHI-P50      00:29:35.8185060
CHI-DC04     14.17:52:05.4841613
CHI-FP02     34.21:21:22.5264640
CHI-CORE01   1.18:55:53.2479797

PS C:\> $up | Update-MyUptime
PS C:\> $up | select computername,uptime

Computername Uptime
------------ ------
CHI-P50      00:34:15.2782411
CHI-DC04     14.17:56:44.9794037
CHI-FP02     34.21:26:02.0493251
CHI-CORE01   1.19:00:32.8009587
```

# TROUBLESHOOTING NOTE
There are no known issues at this time. Please report any issues or suggestions
on the project's GitHub page.

# SEE ALSO

Get-CimInstance
https://www.petri.com/how-to-create-a-powershell-module
https://github.com/jdhitsolutions/MyUptime

# KEYWORDS

- uptime
- time

