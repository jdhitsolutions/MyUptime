# MyUptime

This PowerShell module is designed to make it easy to get uptime information 
for one or more remote computers. The command uses the CIM cmdlets so any 
remote computer must be running at least PowerShell 3.0 with remoting enabled.
You can use computer names or existing CIM sessions. If you use a computer 
name you can also test to see if it is PowerShell v3 compatible.

The current version of the module is based on a class definition which will
require PowerShell v5 on the computer running the commands. The module 
includes a custom format file with predefined table and list views. 

****************************************************************
 DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED THOROUGHLY IN A 
 LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF YOU DO NOT UNDERSTAND WHAT THIS 
 SCRIPT DOES OR HOW IT WORKS, DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             
****************************************************************