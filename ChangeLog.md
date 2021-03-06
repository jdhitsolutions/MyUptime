# ChangeLog for MyUptime

## v4.2.1

+ file cleanup for the PowerShell Gallery
+ Updated `README.me`

## v4.2.0

+ Code cleanup
+ Updated license
+ help documentation updates
+ Corrected Pester tests

## v4.1.0

+ modified `Get-MyTimezone` and `Get-LocalTime` to default to local MyUptime object.
+ Updated version number.

## v4.0.1

+ Added new aliases: 'gtz','glt','umu'
+ Added new table view called Uptime (Issue #1)

## v4.0.0

+ Converted to a class-based tool requiring PowerShell 5.0
+ Converted object methods, GetTimeZone and GetLocalTime to functions
+ Added `Update-MyUptime`
+ Modified manifest
+ Created markdown help documents
+ Converted help to XML

## v3.1.3

+ Updated module manifest with v5 properties
+ increased version number

## v3.1.2

+ Moved comments in types.ps1xml to outside of tag to avoid errors in PowerShell 5

## v3.1.1

+ Added MIT license

## v3.1

+ Added a change log
+ Fixed a bug with error handling when using a CIMSession
+ Fixed a bug assigning type names when using a single CIMSession
