---
external help file: MyUptime-help.xml
Module Name: MyUptime
online version:
schema: 2.0.0
---

# Get-MyLocalTime

## SYNOPSIS

Get local time information.

## SYNTAX

```yaml
Get-MyLocalTime [[-ComputerObject] <MyUptime[]>] [<CommonParameters>]
```

## DESCRIPTION

This command uses computer objects created with Get-MyUptime to retrieve local time information.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> $c = Get-MyUptime -computername chi-dc04,chi-p50,chi-hvr2
PS C:\> $c | get-mylocaltime

Computername LocalDateTime
------------ -------------
CHI-DC04     7/19/2018 12:37:27 PM
CHI-P50      7/19/2018 12:37:27 PM
CHI-HVR2     7/19/2018 12:37:27 PM
```

## PARAMETERS

### -ComputerObject

A computer object created with Get-MyUptime

```yaml
Type: MyUptime[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### MyUptime[]

## OUTPUTS

### MyLocalTime

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-MyUptime]()

[Get-MyTimeZone]()
