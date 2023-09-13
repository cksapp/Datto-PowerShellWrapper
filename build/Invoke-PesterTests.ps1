<#
    .NOTES
        Copyright 1990-2024 Celerium

        NAME: Invoke-PesterTests.ps1
        Type: PowerShell

            AUTHOR:  David Schulte
            DATE:    2023-04-1
            EMAIL:   celerium@Celerium.org
            Updated:
            Date:

        TODO:

    .SYNOPSIS
        Invoke Pester tests against all functions in a module

    .DESCRIPTION
        Invoke Pester tests against all functions in a module

    .PARAMETER moduleName
        The name of the local module to import

        Default value: DattoAPI

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER ExcludeTag
        Tags associated to test to skip

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .PARAMETER Output
        How detailed should the pester output be

        Default value: Normal

        Allowed values:
            'Detailed', 'Diagnostic', 'Minimal', 'None', 'Normal'


    .EXAMPLE
        .\Invoke-PesterTests -moduleName DattoAPI -Version 1.2.3

        Runs various pester tests against all functions in the module
        and outputs the results to the console.

        An XML of the tests is also output to the build directory

    .INPUTS
        N\A

    .OUTPUTS
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

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$moduleName = 'DattoAPI',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$version,

    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeTag = 'PLACEHOLDER',

    [Parameter(Mandatory=$false)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget = 'notBuilt',

    [Parameter(Mandatory=$false)]
    [ValidateSet('Detailed', 'Diagnostic', 'Minimal', 'None', 'Normal')]
    [string]$output = 'Normal'
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

try {

    $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\build')) )"

    switch ($buildTarget){
        'built'     { $modulePath = "$rootPath\build\$moduleName\$version" }
        'notBuilt'  { $modulePath = "$rootPath\$moduleName" }
    }

    $testPath = "$rootPath\Tests"

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Prerequisites ]

#Region     [ Pester Configuration ]

$pester_Container = New-PesterContainer -Path $testPath -Data @{ 'moduleName' = $moduleName; 'Version' = $Version; 'buildTarget' = $buildTarget }

$pester_Options = @{

    Run = @{
        Container = $pester_Container
        PassThru = $true
    }

    Filter = @{
        ExcludeTag = $ExcludeTag
    }

    TestResult = @{
        Enabled = $true
        OutputFormat = 'NUnitXml'
        OutputPath = ".\build\$($moduleName)_Results.xml"
        OutputEncoding = 'UTF8'
    }

    Should = @{
        ErrorAction = 'Continue'
    }

    Output = @{
        Verbosity = $output
    }

}

    $pester_Configuration = New-PesterConfiguration -Hashtable $pester_Options

#EndRegion  [ Pester Configuration ]

#Region     [ Pester Invoke ]

$pester_Results = Invoke-Pester -Configuration $pester_Configuration
    Set-Variable -Name Invoke_PesterResults -Value $pester_Results -Scope Global -Force

#EndRegion  [ Pester Invoke ]
