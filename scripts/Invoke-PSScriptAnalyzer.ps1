# This script invokes PSSccriptAnalyzer for linting of PowerShell files.

# If PSScriptAnalyzer is not installed, save the module in a PSModules folder

if(-Not (Test-Path .\PSModules\PSScriptAnalyzer)) {
    $modulePath = Join-Path -Path (Get-Location) -ChildPath 'PSModules'

    # Create the PSModules directory if it does not exist
    if (-not (Test-Path -Path $modulePath)) {
        New-Item -Path $modulePath -ItemType Directory | Out-Null
    }

    # Save the PSScriptAnalyzer module to the PSModules directory
    Save-Module -Name PSScriptAnalyzer -Path $modulePath
}

# Import the PSScriptAnalyzer module
Import-Module -Name .\PSModules\PSScriptAnalyzer -Force
# Run PSScriptAnalyzer
Get-ChildItem -Path @("./src", "./scripts") -Recurse | Invoke-ScriptAnalyzer -Fix