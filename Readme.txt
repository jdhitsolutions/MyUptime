MyUptime

This PowerShell module is designed to make it easy to get uptime information for one or more remote computers. The 
command uses the CIM cmdlets so any remote computer must be running at least PowerShell 3.0 with remoting enabled.
You can use computer names or existing CIM sessions. If you use a computer name you can also test to see if it is
PowerShell v3 compatible.

The module includes custom format and type extensions with predefined table and list views. The Get-MyUptime function
writes a custom object to the pipeline which includes several custom methods so that you can get additional time-
related information. See examples.

The uptime information is calculated via a set of script properties. When you run the command and save the results
to a variable, you will get updated information every time you look at the variable.
