# MyUptime

This PowerShell module is designed to make it easy to get uptime information for one or more remote computers. The command uses the CIM cmdlets so any remote computer must be running at least PowerShell 3.0 with remoting enabled.

You can use computer names or existing CIM sessions. If you use a computer name you can also test to see if it is PowerShell v3 compatible.

The current version of the module is based on a class definition which will require PowerShell v5 on the computer running the commands. The module includes a custom format file with predefined table and list views.

This module has been published to the PowerShell Gallery.

```powershell
Install-Module myUptime
```

Because the commands in this module use the CIM cmdlets, the module is not compatible with PowerShell Core.

_last updated 23 October 2018_