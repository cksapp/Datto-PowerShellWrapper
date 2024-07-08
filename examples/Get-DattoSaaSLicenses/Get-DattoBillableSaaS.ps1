<#PSScriptInfo

.VERSION 0.0.0.1-alpha

.GUID a7975ad4-2fe0-470e-b6ea-fbc4a137b408

.AUTHOR Kent Sapp (@cksapp)

.COMPANYNAME 

.COPYRIGHT 

.TAGS 

.LICENSEURI https://github.com/Celerium/Datto-PowerShellWrapper/blob/main/LICENSE

.PROJECTURI https://github.com/Celerium/Datto-PowerShellWrapper

.ICONURI https://raw.githubusercontent.com/Celerium/Datto-PowerShellWrapper/main/.github/images/Celerium_PoSHGallery_DattoAPI.png

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


.PRIVATEDATA


#>
<#

.DESCRIPTION
Script to get billable seats for Datto SaaS Protection clients

#>

param (
    [Parameter(Mandatory = $true, HelpMessage = "Enter Datto public API Key")]
    [string]$DattoPublicAPIKey,

    [Parameter(Mandatory = $true, HelpMessage = "Enter Datto private API Key")]
    [securestring]$DattoPrivateAPIKey
)

function Get-DattoSaaSBillable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter Datto public API Key")]
        [string]$DattoPublicAPIKey,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter Datto private API Key")]
        [securestring]$DattoPrivateAPIKey
    )

    begin {

        # Pass the InformationAction parameter if bound, default to 'Continue'
        if ($PSBoundParameters.ContainsKey('InformationAction')) {
            $InformationPreference = $PSBoundParameters['InformationAction']
        } else {
            $InformationPreference = 'Continue'
        }

        # Function to retrieve seats with retry mechanism
        function Get-SeatsWithRetry {
            param (
                [string]$SaasCustomerId,
                [int]$MaxRetries = 3,
                [int]$RetryDelaySeconds = 1
            )
    
            $retryCount = 0
            $seats = $null
    
            while ($retryCount -lt $MaxRetries) {
                $seats = Get-DattoSeat -SaasCustomerId $SaasCustomerId
        
                if ($seats) {
                    break
                }
        
                Write-Information "No data returned for SaaS Customer ID: $SaasCustomerId. Retrying..."
                Start-Sleep -Seconds $RetryDelaySeconds
                $retryCount++
            }
    
            return $seats
        }

        # Set your API key
        Set-DattoAPIKey -Api_Key_Public $DattoPublicAPIKey -Api_Key_Secret ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($DattoPrivateAPIKey)))

        # Test the API key
        try {
            $response = Test-DattoAPIKey -ErrorAction Stop
            if ($response.StatusCode -ne 200) {
                Write-Error "$($response.Message)" -ErrorAction Stop
            }
        }
        catch {
            throw $_
        }
        
        # Create an ArrayList to store the results
        $results = New-Object System.Collections.ArrayList
    }
    
    process {
        # Get all Domains and process each domain using ForEach-Object
        Get-DattoDomain | Where-Object ({ $_.seatsUsed -ne 0 }) | ForEach-Object {
            # Get seats for the current customer
            Write-Information "Processing billable seats for SaaS Customer ID: $($_.saasCustomerId) @ $(Get-Date -Format "MM/dd/yyyy; HH:mm:ss")"
            $seats = Get-SeatsWithRetry -SaasCustomerId $_.saasCustomerId
    
            # Check if seats data is available
            if ($seats) {
                # Calculate the counts for Active, Paused, and Archived seats
                $activeSeatsCount   = $(,($seats.Where({ $_.seatState -eq "Active" -and $_.billable -eq "1" }))).Count
                $pausedSeatsCount   = $(,($seats.Where({ $_.seatState -eq "Paused" -and $_.billable -eq "1" }))).Count
                $archivedSeatsCount = $(,($seats.Where({ $_.seatState -eq "Archived" -and $_.billable -eq "1" }))).Count
        
                # Create a custom object to store the information
                $resultObject = [PSCustomObject]@{
                    DomainName            = $_.domain
                    CustomerName          = $_.saasCustomerName
                    CustomerID            = $_.saasCustomerId
                    ActiveSeats           = $activeSeatsCount
                    PausedSeats           = $pausedSeatsCount
                    ArchivedSeats         = $archivedSeatsCount
                    TotalBillableSeats    = $activeSeatsCount + $pausedSeatsCount + $archivedSeatsCount
                    NumberOfBillableUsers = $(,($seats.Where({ $_.billable -eq "1" }))).Count
                }
        
                # Add the custom object to the ArrayList
                $results.Add($resultObject) | Out-Null
            } else {
                Write-Warning "No data available for SaaS Customer ID: $($_.saasCustomerId) after retrying."
            }
        }

        $results

    }
    
    end {}
}

try {
    # Try to import the DattoAPI module
    Import-Module DattoAPI -Force -ErrorAction Stop
} catch {
    Write-Verbose "Failed to import DattoAPI module. Attempting to install..."
    
    try {
        # Try to install the DattoAPI module
        Install-Module -Name DattoAPI -Scope CurrentUser -Force -ErrorAction Stop
    } catch {
        # Throw an error and stop the script if the module cannot be imported
        throw "Failed to import or install the DattoAPI module. Please install it manually and try again."
    }
}

$results = Get-DattoSaaSBillable -DattoPublicAPIKey $DattoPublicAPIKey -DattoPrivateAPIKey $DattoPrivateAPIKey
$results | Format-Table -AutoSize