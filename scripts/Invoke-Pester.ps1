# This script invokes pester tests for the PSFactory module.

# If Pester 5 is not installed, save the module in a PSModules folder
# and install it from the PowerShell Gallery.

if((-Not (Test-Path .\PSModules\Pester) -and (-Not (Get-Module -Name Pester -ListAvailable | Where-Object { $_.Version -ge [version]'5.0.0' })))) {
    $modulePath = Join-Path -Path (Get-Location) -ChildPath 'PSModules'
    
    # Create the PSModules directory if it does not exist
    if (-not (Test-Path -Path $modulePath)) {
        New-Item -Path $modulePath -ItemType Directory | Out-Null
    }

    # Save the Pester module to the PSModules directory
    Save-Module -Name Pester -Path $modulePath
}

# Import the Pester module
Import-Module -Name .\PSModules\Pester -Force
# Run the Pester tests
Invoke-Pester -Path (Join-Path -Path (Get-Location) -ChildPath 'src/PSFactory.Tests.ps1')