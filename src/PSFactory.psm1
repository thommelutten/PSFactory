function New-PSFactoryModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [switch]$IncludePester
    )

    # Define the module path
    $modulePath = Join-Path -Path (Get-Location) -ChildPath $Name

    # Create the module directory if it does not exist
    if (-not (Test-Path -Path $modulePath)) {
        New-Item -Path $modulePath -ItemType Directory | Out-Null
    }

    # Create the module file
    $moduleFile = Join-Path -Path $modulePath -ChildPath "$Name.psm1"
    if (-not (Test-Path -Path $moduleFile)) {
        New-Item -Path $moduleFile -ItemType File | Out-Null
    }

    if ($IncludePester) {
        # Create a test file if IncludePester is specified
        $testFile = Join-Path -Path $modulePath -ChildPath "$Name.Tests.ps1"
        if (-not (Test-Path -Path $testFile)) {
            $testContent = @"
# Pester test file for $moduleName

Describe '$moduleName' {
    BeforeAll {
        Import-Module -Name (Join-Path -Path (Get-Location) -ChildPath "$moduleName.psm1")
    }
        
    It 'should be equal to true' {
        $true | Should -Be $true
    }
}
"@
            Set-Content -Path $testFile -Value $testContent
        }
    }

    # Output the module path for confirmation
    Write-Output "Module created at: $modulePath"
}

# Export the function for use in other scripts
Export-ModuleMember -Function New-PSFactoryModule