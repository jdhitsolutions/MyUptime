---
external help file: MyUptime-help.xml
online version: 
schema: 2.0.0
---

# Get-MyTimeZone
## SYNOPSIS
Get time zone information
## SYNTAX

```
Get-MyTimeZone [-ComputerObject] <MyUptime[]>
```

## DESCRIPTION
This command uses computer objects created with Get-MyUptime to retrieve time zone information.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> $c = Get-MyUptime -computername chi-dc04,chi-p50,chi-hvr2
PS C:\> $c | get-mytimezone

Computername Caption                                CurrentTimeZone
------------ -------                                ---------------
CHI-DC04     (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-P50      (UTC-05:00) Eastern Time (US & Canada)            -240
CHI-HVR2     (UTC-05:00) Eastern Time (US & Canada)            -240
```

## PARAMETERS

### -ComputerObject
A computer object created with Get-MyUptime

```yaml
Type: MyUptime[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: 
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

### MyUptime[]


## OUTPUTS

### MyTimeZone

## NOTES
Last Updated: July 19, 2016
Version     : 4.0

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Get-MyUptime]()
[Get-MyLocalTime]()

