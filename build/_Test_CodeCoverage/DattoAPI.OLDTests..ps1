<#
    .SYNOPSIS
        Pester tests for the DattoAPI module manifest file.

    .DESCRIPTION
        Pester tests for the DattoAPI module manifest file.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\DattoAPI.Tests.ps1

        Runs a pester test against "DattoAPI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\DattoAPI.Tests.ps1 -Output Detailed

        Runs a pester test against "DattoAPI.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Huge thank you to LazyWinAdmin, Vexx32, & JeffBrown for their blog posts!

    .LINK
        https://vexx32.github.io/2020/07/08/Verify-Module-Help-Pester/
        https://lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
        https://jeffbrown.tech/getting-started-with-pester-testing-in-powershell/
        https://github.com/Celerium/Datto-PowerShellWrapper
#>

#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='DattoAPI'; ModuleVersion='2.0.0' }

#Region [ Discovery ]

    #IDK why I have to duplicate this, but it works.

        # Obtain name of this module by parsing name of test file (DattoAPI\Tests\DattoAPI.Tests.ps1)
        $ThisModule = $PSCommandPath -replace '\.Tests\.ps1$'
        $ThisModuleName = $ThisModule | Split-Path -Leaf

        # Obtain path of the module based on location of test file (DattoAPI\Tests\DattoAPI.Tests.ps1)
        $ThisModulePath = Split-Path (Split-Path -Parent $PSCommandPath) -Parent

        # Make sure one or multiple versions of the module are not loaded
        Get-Module -Name $ThisModuleName | Remove-Module

        # Manifest file path
        $ManifestFile = "$ThisModulePath\$ThisModuleName\$ThisModuleName.psd1"

        Set-Variable -Name TestThisModule -Value $ThisModule -Scope Global -Force
        Set-Variable -Name TestThisModuleName -Value $ThisModuleName -Scope Global -Force
        Set-Variable -Name TestThisModulePath -Value $ThisModulePath -Scope Global -Force
        Set-Variable -Name TestManifestFile -Value $ManifestFile -Scope Global -Force

    BeforeAll {

        $ThisModule = $PSCommandPath -replace '\.Tests\.ps1$'
        $ThisModuleName = $ThisModule | Split-Path -Leaf

        $ThisModulePath = (Split-Path (Split-Path -Parent $PSCommandPath) -Parent)
        $ManifestFile = "$ThisModulePath\$ThisModuleName\$ThisModuleName.psd1"

    }

#EndRegion [ Discovery ]

Describe "[ $ThisModuleName ] testing the module manifest file" {

#Region     [Discovery]

    $ModuleInformation = Import-module -Name $ManifestFile -PassThru

    # Generate command list for generating Context / TestCases
    $Module = Get-Module -Name $ThisModuleName
    $ModuleFiles = $ThisModulePath+'\'+$ThisModuleName | Get-ChildItem -File -Recurse | Select-Object *

#EndRegion  [Discovery]

    ForEach ($ManifestFileElement in $Module) {

        Context "[ $ThisModuleName ] Manifest File Elements" {

        #Region Discovery

        $Elements = @{ Elements = $Module | Select-Object -Property * }

        #EndRegion Discovery

            It "[ $ThisModuleName ] manifest RootModule is not empty" -TestCases $Elements {
                $Elements.RootModule | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest RootModule has valid data" -TestCases $Elements {
                    $Elements.RootModule | Should -Be 'DattoAPI.psm1'
                }

            It "[ $ThisModuleName ] manifest ModuleVersion is not empty" -TestCases $Elements {
                $Elements.Version | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest ModuleVersion has valid data" -TestCases $Elements {
                    $Elements.Version | Should -BeGreaterOrEqual '2.0.0'
                }

            It "[ $ThisModuleName ] manifest GUID is not empty" -TestCases $Elements {
                $Elements.GUID | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest GUID has valid data" -TestCases $Elements {
                    $Elements.GUID | Should -Be 'd536355d-2a81-444f-9e08-9eeeda6db819'
                }

            It "[ $ThisModuleName ] manifest Author is not empty" -TestCases $Elements {
                $Elements.Author | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest Author has valid data" -TestCases $Elements {
                    $Elements.Author | Should -Be 'David Schulte'
                }

            It "[ $ThisModuleName ] manifest CompanyName is not empty" -TestCases $Elements {
                $Elements.CompanyName | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest CompanyName has valid data" -TestCases $Elements {
                    $Elements.CompanyName | Should -Be 'Celerium'
                }

            It "[ $ThisModuleName ] manifest Copyright is not empty" -TestCases $Elements {
                $Elements.Copyright | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest Copyright has valid data" -TestCases $Elements {
                    $Elements.Copyright | Should -Be 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/LICENSE'
                }

            It "[ $ThisModuleName ] manifest Description is not empty" -TestCases $Elements {
                $Elements.Description | Should -Not -BeNullOrEmpty
            }

            It "[ $ThisModuleName ] manifest PowerShellVersion is not empty" -TestCases $Elements {
                $Elements.PowerShellVersion | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest PowerShellVersion has valid data" -TestCases $Elements {
                    $Elements.PowerShellVersion | Should -BeGreaterOrEqual '5.0'
                }

            It "[ $ThisModuleName ] manifest NestedModules is not empty" -TestCases $Elements {
                $Elements.NestedModules | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest NestedModules has valid data" -TestCases $Elements {
                    ($Elements.NestedModules.Name).Count | Should -Be 16
                }

            It "[ $ThisModuleName ] manifest FunctionsToExport is not empty" -TestCases $Elements {
                $Elements.ExportedCommands | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest FunctionsToExport has valid data" -TestCases $Elements {
                    ($Elements.ExportedCommands).Count | Should -Be 26
                }

            It "[ $ThisModuleName ] manifest CmdletsToExport is empty" -TestCases $Elements {
                ($Elements.ExportedCmdlets).Count |  Should -Be 0
            }

            It "[ $ThisModuleName ] manifest VariablesToExport is empty" -TestCases $Elements {
                ($null -ne ($Elements | Select-Object ExportedVariables) -and (($Elements).ExportedVariables).Count -eq 0) | Should -Be $true
            }

            It "[ $ThisModuleName ] manifest AliasesToExport is empty" -TestCases $Elements {
                ($Elements.ExportedAliases).Count |  Should -Be 0
            }

            It "[ $ThisModuleName ] manifest Tags is not empty" -TestCases $Elements {
                $Elements.PrivateData.PSData.Tags | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest Tags has valid data" -TestCases $Elements {
                    $Elements.PrivateData.PSData.Tags | Should -Contain 'Datto'
                    $Elements.PrivateData.PSData.Tags | Should -Contain 'Celerium'
                    ($Elements.PrivateData.PSData.Tags).Count | Should -BeGreaterOrEqual 9
                }

            It "[ $ThisModuleName ] manifest LicenseUri is not empty" -TestCases $Elements {
                $Elements.LicenseUri | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest LicenseUri has valid data" -TestCases $Elements {
                    $Elements.LicenseUri | Should -Be 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/LICENSE'
                }

            It "[ $ThisModuleName ] manifest ProjectUri is not empty" -TestCases $Elements {
                $Elements.ProjectUri  | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest ProjectUri has valid data" -TestCases $Elements {
                    $Elements.ProjectUri  | Should -Be 'https://github.com/Celerium/Datto-PowerShellWrapper'
                }

            It "[ $ThisModuleName ] manifest IconUri is not empty" -TestCases $Elements {
                $Elements.IconUri  | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest IconUri has valid data" -TestCases $Elements {
                    $Elements.IconUri  | Should -Be 'https://raw.githubusercontent.com/Celerium/Datto-PowerShellWrapper/main/.github/Celerium-Datto.png'
                }

            It "[ $ThisModuleName ] manifest ReleaseNotes is not empty" -TestCases $Elements {
                $Elements.ReleaseNotes  | Should -Not -BeNullOrEmpty
            }

                It "[ $ThisModuleName ] manifest ReleaseNotes has valid data" -TestCases $Elements {
                    $Elements.ReleaseNotes  | Should -Be 'https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/README.md'
                }

            It "[ $ThisModuleName ] manifest HelpInfoUri is not empty" -TestCases $Elements {
                $Elements.HelpInfoUri | Should -BeNullOrEmpty
            }

            <#
                It "[ $ThisModuleName ] manifest HelpInfoUri has valid data" -TestCases $Elements {
                    ($Elements.HelpInfoUri -like "*Datto-PowerShellWrapper*") | Should -Be $true
                    ($Elements.HelpInfoUri -like "*integrations/xml*") | Should -Be $true
                }
            #>
        }
    }

    Context "[ $ThisModuleName ] Testing Manifest & Script Modules" {

        It "[ $ThisModuleName ] manifest & script modules are stored in the correct location" {
            $($ThisModulePath+"\"+$ThisModuleName.psd1) | Should -Exist
            $($ThisModulePath+"\"+$ThisModuleName.psm1) | Should -Exist
        }

        It "[ $ThisModuleName ] has functions in the Private directory" {
            "$ThisModulePath\$ThisModuleName\Private\*.ps1" | Should -Exist
        }

        It "[ $ThisModuleName ] has functions in the Public directory" {
            "$ThisModulePath\$ThisModuleName\Public\*.ps1" | Should -Exist
        }

        It "[ $ThisModuleName ] has tests in the Tests directory" {
            "$ThisModulePath\Tests\*Tests.ps1" | Should -Exist
        }

        It "[ $($ThisModuleName+".psd1")] Should pass Test-ModuleManifest" {
            $TestResults = $ManifestFile | Test-ModuleManifest -ErrorAction SilentlyContinue
            $? | Should -Be $true
        }

        It "[ $($ThisModuleName+".psd1")] Should import PowerShell $ThisModuleName successfully" {
            $TestResults = $ThisModulePath+'\'+$ThisModuleName | Import-Module
            $? | Should -Be $true
        }

        #Both $File need to exist for assertion or the value goes null...IDK why
        Context "[ $ThisModuleName ] Tests directory contains only tests" {

            ForEach ($File in $($ModuleFiles | Where-Object {$_.Directory -like "*Tests*"})) {

                #Region Discovery

                    $File = @{ File = $File }

                #EndRegion Discovery

                    It "[ $ThisModuleName ] Pester test files: $($File.File.Name)" -TestCases $File {
                        $File = @{ File = $File }
                        $PesterTestFile = $File.File.Name -replace '\.Tests\.ps1$'
                        "$($File.File.Directory)\$PesterTestFile.Tests.ps1" | Should -Exist
                    }
            }
        }
    }

    Context "[ $ThisModuleName ] Testing for PowerShell file types" {
        #Region Discovery

        $Files = @{ Files = $ModuleFiles | Select-Object -Property * }

        #EndRegion Discovery

            It "[ $ThisModuleName ] contains only PowerShell files" -TestCases $Files {
                ($Files | Group-Object Extension).Name.Count | Should -Be 3
            }
    }

    #Both $File need to exist for assertion or the value goes null...IDK why
    Context "[ $ThisModuleName ] Testing for valid PowerShell code" {

        ForEach ($File in $ModuleFiles) {

            #Region Discovery

                $File = @{ File = $File }

            #EndRegion Discovery

                It "[ $ThisModuleName ] valid PowerShell code for: $($File.File.Name)" -TestCases $File {
                    $File = @{ File = $File }
                    $psFile = Get-Content -Path $($File.File.FullName) -ErrorAction Stop
                    $errors = $null
                    $null = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$errors)
                    $errors.Count | Should -Be 0
                }
        }
    }
}