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

        Set-Variable -Name PSCommandPath123 -Value $PSCommandPath -Scope Global -Force

        $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\Tests')) )"

        Set-Variable -Name rootPath123 -Value $rootPath -Scope Global -Force

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

        Remove-DattoBaseUri -WarningAction SilentlyContinue
        Remove-DattoAPIKey -WarningAction SilentlyContinue

        Foreach ($script in $import_Scripts){
            if (Get-Module -Name $script.BaseName){
                Remove-Module -Name $script.BaseName -Force
            }
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

        It "[ Test-DattoAPIKey ] with a bad API key should fail to authenticate" {
            Add-DattoBaseUri
            Add-DattoAPIKey -Api_Key_Public '12345' -Api_Key_Secret "DattoApiKey"

            $Value = Test-DattoAPIKey 3>$null
            $Value.Message | Should -BeLike '*(401) Unauthorized*'
        }

    }

}