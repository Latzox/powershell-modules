# Public PowerShell Modules

This repository contains a collection of PowerShell modules that provide various functionalities such as logging operations, downloading files, and more. Each function in these modules is designed to make it easier to handle common tasks while adhering to PowerShell best practices.

## Installation

### Cloning the Repository
To use the functions from this repository, you can either clone the entire repository or download individual scripts.

Clone the repository using Git:

```bash
git clone https://github.com/Latzox/powershell-modules.git
```

Once cloned, navigate to the source folder where the modules or functions are located and import them as needed.

```
Import-Module .\functions\Write-Log.ps1
```

### Installing via Invoke-RestMethod

If you prefer a quick and lightweight installation without cloning the repository, you can download and execute the scripts directly from the GitHub repository using the following method.

Download and execute the script:

```PowerShell
$Uri = 'https://github.com/Latzox/powershell-modules/blob/main/functions/Write-Log.ps1'

Invoke-RestMethod -Uri $Uri | Out-File -FilePath "$env:TEMP\Write-Log.ps1"

. "$env:TEMP\Write-Log.ps1"
```

This method allows you to load the functions into your current PowerShell session. Once loaded, you can use the functions immediately.

```PowerShell
Write-Log -Message "This is a test log" -LogLevel "Info"
```

## Documentation
Each module in this repository includes detailed documentation with parameters, examples, and additional notes. You can find the documentation for each function inside its respective folder in the /src directory.

To view help for any function in your PowerShell session:

```PowerShell
Get-Help Write-Log -Full
Get-Help Invoke-FileDownload -Full
```

## Contributing
We welcome contributions to this repository! If you'd like to add new modules, improve existing ones, or fix bugs, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Add or modify the relevant module in the src folders.
4. Write Pester tests for your code.
5. Submit a pull request to the dev branch.

## Testing
Automated tests for each module are included using Pester. To run the tests for a module, navigate to its directory and run:

```PowerShell
Invoke-Pester -Path ./tests
```
If you're adding new modules or functions, make sure to include corresponding tests.

## Contact
If you have any questions, issues, or suggestions regarding the modules in this repository, feel free to open an issue or contact the maintainer via GitHub.