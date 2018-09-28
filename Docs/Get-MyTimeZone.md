---
external help file: MyUptime-help.xml
Module Name: MyUptime
online version:
schema: 2.0.0
---

# Get-MyTimeZone

## SYNOPSIS

Get time zone information.

## SYNTAX

```yaml
Get-MyTimeZone [[-ComputerObject] <MyUptime[]>] [<CommonParameters>]
```

## DESCRIPTION

This command uses computer objects created with Get-MyUptime to retrieve time zone information.

## EXAMPLES

### EXAMPLE 1

```powershell
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

### MyTimeZone

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-MyUptime]()

[Get-MyLocalTime]()
