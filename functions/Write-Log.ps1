function Write-Log {
    <#
    .SYNOPSIS
    Writes a log entry to a log file and optionally outputs it to the console.

    .DESCRIPTION
    This function logs messages with a specified log level (Info, Warning, Error, Success) to a log file and displays the log on the console with color-coded output depending on the log level.

    .PARAMETER Message
    The log message to be written.

    .PARAMETER LogLevel
    The severity level of the log message. Can be 'Info', 'Warning', 'Error', or 'Success'. Defaults to 'Info'.

    .INPUTS
    None. You must provide values for the parameters explicitly.

    .OUTPUTS
    None. This function does not return output; it writes to a file or displays messages in the console.

    .EXAMPLE
    Write-Log -Message "Operation completed successfully" -LogLevel "Success"
    Logs a success message to the log file and displays it in green.

    .EXAMPLE
    Write-Log -Message "An error occurred" -LogLevel "Error"
    Logs an error message to the log file and displays it in red.

    .NOTES
    Author: Marco Platzer
    Version: 1.0
    Date: 13-09-2024

    .LINK
    https://github.com/Latzox/powershell-modules

    #>

    [CmdletBinding()]
    Param (
        # The log message to be written
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        # Log level: Info, Warning, Error, Success
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$LogLevel = "Info"
    )

    Begin {
        # Initialization, setting up the timestamp
        $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $LogEntry = "$Timestamp [$LogLevel] $Message"
        Write-Verbose "Log entry created: $LogEntry"
    }

    Process {
        try {
            # Attempt to write to log file if $LogFile is defined
            if ($LogFile) {
                Write-Verbose "Writing log entry to file: $LogFile"
                Add-Content -Path $LogFile -Value $LogEntry
            }

            # Output to console with color based on LogLevel
            switch ($LogLevel) {
                "Error" {
                    Write-Host $LogEntry -ForegroundColor DarkRed
                }
                "Warning" {
                    Write-Host $LogEntry -ForegroundColor DarkYellow
                }
                "Success" {
                    Write-Host $LogEntry -ForegroundColor DarkGreen
                }
                default {
                    Write-Host $LogEntry
                }
            }
        }
        catch {
            Write-Error "Error writing to log file: $_"
        }
    }

    End {
        Write-Verbose "Log function completed."
    }
}
