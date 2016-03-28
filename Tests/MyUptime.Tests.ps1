#requires -version 5.0

Import-Module MyUptime

#Pester tests
InModuleScope MyUptime {
Describe "Get-MyUptime" {
    
    It "Should run without error by default" {
        {Get-MyUptime} | Should Not Throw
    }
    It "Should write a Warning with a bad computername" {
        $test = Get-MyUptime -Computername "FOO" -WarningAction SilentlyContinue -WarningVariable w
        $w | should be $True
    }
    It "Should get a MyUptime object with no parameters" {
      $a = Get-MyUptime
      $a.psobject.TypeNames[0] | Should be 'My.Uptime'
    }

    #mock and test an internal function to make sure it is called
    Mock IsWSManAvailable { $True }
    It "Should run IsWSManAvailable once" {
      $test = Get-MyUptime -Test
      Assert-MockCalled -CommandName IsWSManAvailable -Times 1
    }

    Context "Test output object" {
        $result = Get-MyUptime -Computername $env:COMPUTERNAME
        It "Computername property should match $env:COMPUTERNAME" {
           $result.computername | Should be $env:COMPUTERNAME   
        }
        It "LastRebootTime should be a [DateTime]" {
            $result.lastRebootTime.GetType().Name | Should Be "DateTime"
        }
        It "Uptime should be a [String]" {
            $result.Uptime.GetType().Name | Should Be "String"
        }
    }
    Context "Test parameter input" {
        $in = $env:COMPUTERNAME,$env:COMPUTERNAME,$env:COMPUTERNAME
        
        It "Should have 3 results from 3 Computername values" {
            $result = Get-MyUptime -Computername $in
            $result.count | Should Be 3
        }
        It "Should have 3 results from 3 PIPED Computername values" {
            $result = $in | Get-MyUptime
            $result.count | Should Be 3
        }

        $cs = New-CimSession -ComputerName $in
        It "Should have 3 results from CIMSessions" {
            $result =  Get-MyUptime -CimSession $cs
            $result.count | Should Be 3
        }
        It "Should have 3 results from PIPED  CIMSessions" {
            $result = $cs | Get-MyUptime
            $result.count | Should Be 3
        }
    }
    Context "Custom methods"  {
      $result = Get-MyUptime
      It "GetLocalTime() should return a DateTime value without error" {
        $result.GetLocalTime().LocalDateTime.GetType().Name | Should Be "DateTime"
        {(Get-MyUptime).GetLocalTime()} | Should Not Throw
      }
      It "GetTimeZone() should return Timezone information without error" {
       $test = $result.GetTimeZone()
       $test.Caption | Should be $True
       $test.CurrentTimeZone | Should be $True
       {(Get-MyUptime).GetTimeZone()} | Should Not Throw
      }
    }
} #Describe

} #moduleScope

