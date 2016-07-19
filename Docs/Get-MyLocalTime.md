---
external help file: MyUptime-help.xml
online version: 
schema: 2.0.0
---

# Get-MyLocalTime
## SYNOPSIS
Get local time information

## SYNTAX

```
Get-MyLocalTime [-ComputerObject] <MyUptime[]>
```

## DESCRIPTION
This command uses computer objects created with Get-MyUptime to retrieve local time information.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> $c = Get-MyUptime -computername chi-dc04,chi-p50,chi-hvr2
PS C:\> $c | get-mylocaltime

Computername LocalDateTime        
------------ -------------        
CHI-DC04     7/19/2016 12:37:27 PM
CHI-P50      7/19/2016 12:37:27 PM
CHI-HVR2     7/19/2016 12:37:27 PM
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

### MyLocalTime

## NOTES
Last Updated: July 19, 2016
Version     : 4.0

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS
[Get-MyUptime]()
[Get-MyTimeZone]()
