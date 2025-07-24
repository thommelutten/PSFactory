Describe 'New-PSFactoryModule' {
    BeforeAll {
        Import-Module -Name (Join-Path -Path (Get-Location) -ChildPath 'src/PSFactory.psm1') -Force
    }

    It 'should create a directory with a module file' {
        # Arrange
        $moduleName = 'TestModule'
        $modulePath = Join-Path -Path (Get-Location) -ChildPath $moduleName
        $moduleFile = Join-Path -Path $modulePath -ChildPath "$moduleName.psm1"

        # Act
        New-PSFactoryModule -Name $moduleName

        # Assert
        $modulePath | Should -Exist
        $moduleFile | Should -Exist

        # Clean up
        Remove-Item -Path $modulePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    It 'should create a directory with a module file and test file when -IncludePester is specified' {
        # Arrange
        $moduleName = 'TestModuleWithPester'
        $modulePath = Join-Path -Path (Get-Location) -ChildPath $moduleName
        $moduleFile = Join-Path -Path $modulePath -ChildPath "$moduleName.psm1"
        $testFile = Join-Path -Path $modulePath -ChildPath "$moduleName.Tests.ps1"

        $testFileContent = @"
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
        # Act
        New-PSFactoryModule -Name $moduleName -IncludePester

        # Assert
        $modulePath | Should -Exist
        $moduleFile | Should -Exist
        $testFile | Should -Exist
        $testFile | Should -FileContentMatchMultiline $testFileContent

        # Clean up
        Remove-Item -Path $modulePath -Recurse -Force -ErrorAction SilentlyContinue
    }
}