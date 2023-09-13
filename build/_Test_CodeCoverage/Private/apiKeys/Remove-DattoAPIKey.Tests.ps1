<#
    .SYNOPSIS
        Pester tests for the DattoAPI apiKeys functions

    .DESCRIPTION
        Pester tests for the DattoAPI apiKeys functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Remove-DattoAPIKey.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\apiKeys\Remove-DattoAPIKey.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N\A

    .OUTPUTS
        N\A

    .NOTES
        N\A

    .LINK
        https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.5.0' }

#Region     [ Parameters ]

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [String]$moduleName = 'DattoAPI',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"

        switch ($buildTarget){
            'built'     { $modulePath = "$rootPath\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = "$rootPath\$moduleName" }
        }

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }
        Import-Module -Name "$modulePath\$moduleName.psd1" -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($moduleError){
            $moduleError
            exit 1
        }

    }

    AfterAll{

        Remove-DattoAPIKey -WarningAction SilentlyContinue

        if (Get-Module -Name $moduleName){
            Remove-Module -Name $moduleName -Force
        }

    }


#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]

Describe "Testing [ $commandName ] function with [ $pester_TestName ]" {

    Context "[ $commandName ] testing function" {

        It "Running [ $commandName ] should remove all apiKey variables" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-DattoAPIKey
            $Datto_Public_Key | Should -BeNullOrEmpty
            $Datto_Secret_Key | Should -BeNullOrEmpty
        }

        It "If the [ Datto_Public_Key ] is already empty a warning should be thrown" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-Variable -Name "Datto_Public_Key" -Scope global -Force

            Remove-DattoAPIKey -WarningAction SilentlyContinue -WarningVariable apiKeyWarning
            $apiKeyWarning | Should -Be "The Datto API [ public ] key is not set. Nothing to remove"
        }

        It "If the [ Datto_Secret_Key ] is already empty a warning should be thrown" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-Variable -Name "Datto_Secret_Key" -Scope global -Force

            Remove-DattoAPIKey -WarningAction SilentlyContinue -WarningVariable apiKeyWarning
            $apiKeyWarning | Should -Be "The Datto API [ secret ] key is not set. Nothing to remove"
        }

        It "If the apiKeys are already gone two warnings should be thrown" {
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"
            Remove-DattoAPIKey

            Remove-DattoAPIKey -WarningAction SilentlyContinue -WarningVariable apiKeyWarning
            $apiKeyWarning.Count | Should -Be '2'
        }

    }

}