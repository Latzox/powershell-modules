function Invoke-FileDownload {
    <#
    .SYNOPSIS
    Downloads a file from a given URL and saves it to a specified output location, or returns it as a byte array.

    .DESCRIPTION
    This function retrieves a file from any source URL and saves it to a specified location on the local file system, or it can return the file content as a byte array. 
    The function ensures secure communication by enforcing TLS 1.2 and provides options for timeout, progress reporting, and retry logic for better handling of network failures.

    .PARAMETER Url
    The URL of the file to be downloaded. This should be a valid and accessible URL.

    .PARAMETER OutputPath
    The full path (including file name) where the downloaded file will be saved. This should include the file extension. 
    If not specified, the function will return the content as a byte array.

    .PARAMETER Timeout
    The number of seconds to wait before timing out the download. Default is 30 seconds.

    .PARAMETER RetryCount
    The number of times to retry the download in case of failure. Default is 3.

    .PARAMETER ShowProgress
    Switch to display download progress on the console.

    .INPUTS
    None. You must pass the URL explicitly as a parameter.

    .OUTPUTS
    If `OutputPath` is provided, no output is returned (file is saved). If `OutputPath` is not specified, the function returns the file content as a byte array.

    .EXAMPLE
    Invoke-FileDownload -Url "https://example.com/file.zip" -OutputPath "C:\Downloads\file.zip" -ShowProgress
    Downloads the file from the given URL with progress reporting and saves it to the specified output path.

    .EXAMPLE
    $fileContent = Invoke-FileDownload -Url "https://example.com/image.jpg"
    Downloads the image from the given URL and returns it as a byte array.

    .NOTES
    Ensure that the output path has sufficient write permissions. Use this function with valid URLs to avoid errors during download.
    Author: Marco Platzer
    Version: 2.0
    Date: 13-09-2024
    
    .LINK
    https://github.com/Latzox/powershell-modules
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$OutputPath,

        [Parameter(Mandatory = $false)]
        [int]$Timeout = 30,

        [Parameter(Mandatory = $false)]
        [int]$RetryCount = 3,

        [Parameter(Mandatory = $false)]
        [switch]$ShowProgress
    )

    Begin {
        Write-Verbose "Starting function execution..."
        
        # Enforce TLS 1.2 for secure network communication
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    }

    Process {
        $attempts = 0
        $success = $false

        while ($attempts -lt $RetryCount -and -not $success) {
            try {
                $attempts++
                Write-Verbose "Attempt $attempts of $RetryCount to download the file."

                # Download file with web client
                $wc = New-Object System.Net.WebClient
                $wc.DownloadFileCompleted = {
                    Write-Verbose "File download completed."
                }

                if ($Timeout) {
                    $wc.Timeout = $Timeout * 1000  # Convert seconds to milliseconds
                }

                if ($ShowProgress) {
                    $wc.DownloadProgressChanged = {
                        Write-Progress -Activity "Downloading" -Status "$($_.ProgressPercentage)% Complete" -PercentComplete $_.ProgressPercentage
                    }
                }

                if ($OutputPath) {
                    # Ensure the directory exists
                    $directory = [System.IO.Path]::GetDirectoryName($OutputPath)
                    if (-not (Test-Path -Path $directory)) {
                        Write-Verbose "Creating directory: $directory"
                        New-Item -ItemType Directory -Path $directory -Force
                    }

                    # Download the file to the specified path
                    $wc.DownloadFile($Url, $OutputPath)
                    Write-Verbose "File downloaded successfully to $OutputPath."
                } else {
                    # Return file as byte array
                    Write-Verbose "Downloading file content as byte array."
                    $fileContent = $wc.DownloadData($Url)
                    $success = $true
                    return $fileContent
                }

                $success = $true  # If we reach this point, the download was successful
            }
            catch {
                Write-Warning "An error occurred during the download attempt ${attempts}: $_"
                if ($attempts -ge $RetryCount) {
                    Write-Error "Max retry attempts reached. Download failed."
                } else {
                    Start-Sleep -Seconds 2  # Wait before retrying
                }
            }
        }
    }

    End {
        Write-Verbose "Function execution completed."
    }
}
