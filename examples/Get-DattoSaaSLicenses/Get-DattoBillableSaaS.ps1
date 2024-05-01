# Import the DattoAPI module
Import-Module DattoAPI

# Set your API key
Set-DattoAPIKey -Api_Key_Public (Read-Host "Enter Datto public API Key") -Api_Key_Secret ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Read-Host "Enter Datto private API Key" -AsSecureString))))

# Create an ArrayList to store the results
$results = New-Object System.Collections.ArrayList

# Function to retrieve seats with retry mechanism
function Get-SeatsWithRetry {
    param (
        [string]$SaasCustomerId,
        [int]$MaxRetries = 3,
        [int]$RetryDelaySeconds = 5
    )
    
    $retryCount = 0
    $seats = $null
    
    while ($retryCount -lt $MaxRetries) {
        $seats = Get-DattoSeat -SaasCustomerId $SaasCustomerId
        
        if ($seats) {
            break
        }
        
        Write-Host "No data returned for SaaS Customer ID: $SaasCustomerId. Retrying..."
        Start-Sleep -Seconds $RetryDelaySeconds
        $retryCount++
    }
    
    return $seats
}

# Get all Domains and process each domain using ForEach-Object
Get-DattoDomain | Where-Object ({ $_.seatsUsed -ne 0 }) | ForEach-Object {
    # Get seats for the current customer
    Write-Host "Processing billable seats for SaaS Customer ID: $($_.saasCustomerId) @ $(Get-Date -Format "MM/dd/yyyy; HH:mm:ss")"
    $seats = Get-SeatsWithRetry -SaasCustomerId $_.saasCustomerId
    
    # Check if seats data is available
    if ($seats) {
        # Calculate the counts for Active, Paused, and Archived seats
        $activeSeatsCount = $($seats.Where({ $_.seatState -eq "Active" -and $_.billable -eq "1" })).Count
        $pausedSeatsCount = $($seats.Where({ $_.seatState -eq "Paused" -and $_.billable -eq "1" })).Count
        $archivedSeatsCount = $($seats.Where({ $_.seatState -eq "Archived" -and $_.billable -eq "1" })).Count
        
        # Create a custom object to store the information
        $resultObject = [PSCustomObject]@{
            DomainName            = $_.domain
            CustomerName          = $_.saasCustomerName
            CustomerID            = $_.saasCustomerId
            ActiveSeats           = $activeSeatsCount
            PausedSeats           = $pausedSeatsCount
            ArchivedSeats         = $archivedSeatsCount
            TotalBillableSeats    = $activeSeatsCount + $pausedSeatsCount + $archivedSeatsCount
            NumberOfBillableUsers = $($seats.Where({ $_.billable -eq "1" })).Count
        }
        
        # Add the custom object to the ArrayList
        $results.Add($resultObject) | Out-Null
    } else {
        Write-Host "No data available for SaaS Customer ID: $($_.saasCustomerId) after retrying."
    }
}

# Output the results
$results | Format-Table