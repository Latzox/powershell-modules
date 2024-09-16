. "..\functions\Write-Log.ps1"

Describe 'Write-Log' {

    BeforeEach {
        # Mocking a global variable $LogFile to simulate logging to a file.
        $global:LogFile = "$PSScriptRoot\testlog.txt"
        if (Test-Path $global:LogFile) {
            Remove-Item $global:LogFile
        }
    }

    It 'Accepts only valid LogLevel values' {
        { Write-Log -Message "Test" -LogLevel Critical } | Should -Throw
    }

    It 'Does not throw an error when mandatory parameters are provided' {
        { Write-Log -Message "Test message" -LogLevel "Info" } | Should -Not -Throw
    }

    Context 'Log Level Behavior' {
        It 'Logs message with Info log level without error' {
            { Write-Log -Message "Info message" -LogLevel "Info" } | Should -Not -Throw
        }

        It 'Logs message with Error log level in red' {
            Mock Write-Host
            Write-Log -Message "Error message" -LogLevel "Error"
            Assert-MockCalled -Exactly 1 -CommandName Write-Host -ParameterFilter { $ForegroundColor -eq "DarkRed" }
        }

        It 'Logs message with Warning log level in yellow' {
            Mock Write-Host
            Write-Log -Message "Warning message" -LogLevel "Warning"
            Assert-MockCalled -Exactly 1 -CommandName Write-Host -ParameterFilter { $ForegroundColor -eq "DarkYellow" }
        }

        It 'Logs message with Success log level in green' {
            Mock Write-Host
            Write-Log -Message "Success message" -LogLevel "Success"
            Assert-MockCalled -Exactly 1 -CommandName Write-Host -ParameterFilter { $ForegroundColor -eq "DarkGreen" }
        }
    }

    Context 'Log File Behavior' {
        It 'Writes log entry to the file when LogFile is defined' {
            Write-Log -Message "Test log entry" -LogLevel "Info" -LogFile $global:LogFile
            $logFileContent = Get-Content -Path $global:LogFile
            $logFileContent | Should -Match "\[Info\] Test log entry"
        }

        It 'Does not write to the log file if LogFile is not defined' {
            $global:LogFile = $null
            Write-Log -Message "This should not be logged"
            if ($global:LogFile -ne $null) {
                Test-Path $global:LogFile | Should -Be $false
            } else {
                $logPath = "$PSScriptRoot\testlog.txt"
                Test-Path $logPath | Should -Be $false
            }
        }
    }

    AfterEach {
        if (Test-Path $global:LogFile) {
            Remove-Item $global:LogFile
        }
    }

}