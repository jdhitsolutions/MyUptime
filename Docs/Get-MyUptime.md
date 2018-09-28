---
external help file: MyUptime-help.xml
Module Name: MyUptime
online version:
schema: 2.0.0
---

# Get-MyUptime

## SYNOPSIS

Get computer uptime.

## SYNTAX

### Name (Default)

```yaml
Get-MyUptime [[-Computername] <String[]>] [-Test] [<CommonParameters>]
```

### Session

```yaml
Get-MyUptime [-CimSession <CimSession[]>] [<CommonParameters>]
```

## DESCRIPTION

This command will query the Win32_OperatingSystem class using Get-CimInstance and write an uptime object to the pipeline.
You must run this with credentials that have administrator rights on the remote computer.

This PowerShell function is designed to make it easy to get uptime information for one or more remote computers.
The command uses the CIM cmdlets so any remote computer must be running at least PowerShell 3.0 with remoting enabled.
You can use computer names or existing CIM sessions. If you use a computer name you can also test to see if it is PowerShell v3 compatible.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> get-myuptime chi-dc01,chi-fp02

Computername       LastRebootTime            Days Hours Minutes Seconds
------------       --------------            ---- ----- ------- -------
CHI-DC01           7/18/2018 3:17:48 PM         0    21       8      39
CHI-FP02           6/15/2018 12:49:26 PM       33    23      37       2
```

Formatted results for multiple computers.
You can also pipe computer names into this command.

### EXAMPLE 2

```powershell
PS C:\> Get-myuptime | format-list

Computername : WIN81-ENT-01
LastReboot   : 7/15/2018 8:28:24 AM
Uptime       : 4.03:58:24.7545765
```

Get uptime for the local computer and use the custom list formatting view.

### EXAMPLE 3

```powershell
PS C:\> $c = "chi-dc01","chi-core01","chi-dc02","chi-hvr2","chi-dc04"
PS C:\> $c | get-myuptime -test | Sort LastRebootTime -Descending

WARNING: CHI-DC02 is not accessible via the WSMan protocol.

Computername       LastRebootTime            Days Hours Minutes Seconds
------------       --------------            ---- ----- ------- -------
CHI-DC01           7/18/2018 3:17:48 PM         0    21      10       0
CHI-HVR2           7/18/2018 3:15:04 PM         0    21      12      47
CHI-CORE01         7/18/2018 3:14:57 PM         0    21      12      51
CHI-DC04           7/5/2018 4:20:18 PM         13    20       7      34
```

Query a list of computers, testing for WSMan and sort on the LastRebootTime

### EXAMPLE 4

```powershell
PS C:\> "chi-dc01","chi-core01","chi-hvr2","chi-dc04" | Get-myuptime | where Days -le 7

Computername       LastRebootTime            Days Hours Minutes Seconds
------------       --------------            ---- ----- ------- -------
CHI-DC01           7/18/2018 3:17:48 PM         0    21      11      36
CHI-CORE01         7/18/2018 3:14:57 PM         0    21      14      27
CHI-HVR2           7/18/2018 3:15:04 PM         0    21      14      21
```

Get uptime for a list of computers and filter out those that have been running for longer than 7 days.

The first command creates an array of computer names. The second command gets uptime but tests each computer first.

### EXAMPLE 5

```powershell
PS C:\> get-myuptime "chi-dc01","chi-core01","chi-dc04" | Sort Uptime | Select Computername,Uptime

Computername Uptime
------------ ------
CHI-DC01     21:12:33.4281159
CHI-CORE01   21:15:24.2350091
CHI-DC04     13.20:10:03.9522704
```

Get uptime for a set of servers, sort on the uptime and display computername and uptime.

### EXAMPLE 6

```powershell
PS C:\> $cs = New-CimSession chi-dc01,chi-dc04,chi-core01 
PS C:\> $cs | Get-MyUptime | Select Computername,Uptime

Computername Uptime
------------ ------
CHI-DC01     21:14:29.2166176
CHI-CORE01   21:17:20.0236754
CHI-DC04     13.20:11:59.7334703
```

Get uptime for a list of computers via CIM Sessions.

## PARAMETERS

### -Computername

The name of the computer to query. This parameter has an alias of CN and Name. The computer must be running PowerShell 3.0 or later with remoting enabled to support the CIM cmdlets.

```yaml
Type: String[]
Parameter Sets: Name
Aliases: cn, name

Required: False
Position: 1
Default value: $env:Computername
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Test

Use Test-WSMan to verify computer can be reached and is running v3 or later of the Windows Management Framework stack.

```yaml
Type: SwitchParameter
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CimSession

```yaml
Type: CimSession[]
Parameter Sets: Session
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [string[]]

### [Microsoft.Management.Infrastructure.CimSession[]]

## OUTPUTS

### [MyUptime]

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Update-MyUptime]()

[Get-Ciminstance]()

[Test-WSMan]()

[https://www.petri.com/how-to-create-a-powershell-module](https://www.petri.com/how-to-create-a-powershell-module)

