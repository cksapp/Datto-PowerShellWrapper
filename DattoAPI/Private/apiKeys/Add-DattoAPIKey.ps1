function Add-DattoAPIKey {
<#
    .SYNOPSIS
        Sets the API public & secret keys used to authenticate API calls.

    .DESCRIPTION
        The Add-DattoAPIKey cmdlet sets the API public & secret keys which are used to
        authenticate all API calls made to Datto.

        Once the API public & secret keys are defined, the secret key is encrypted using SecureString.

        The Datto API public & secret keys are generated via the Datto portal at Admin > Integrations

    .PARAMETER Api_Key_Public
        Defines your API public key.

    .PARAMETER Api_Key_Secret
        Defines your API secret key.

    .EXAMPLE
        Add-DattoAPIKey

        Prompts to enter in the API public key and secret key.

    .EXAMPLE
        Add-DattoAPIKey -Api_Key_Public '12345'

        The Datto API will use the string entered into the [ -Api_Key_Public ] parameter as the
        public key & will then prompt to enter in the secret key.

    .EXAMPLE
        ConvertTo-SecureString '12345' -AsPlainText | Add-DattoAPIKey

        The Datto API will use the secure string entered as the secret key & will prompt to enter in the public key.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/Internal/Add-DattoAPIKey.html
#>

    [cmdletbinding()]
    [Alias('Set-DattoAPIKey')]
    Param (
        [Parameter(Mandatory = $true, HelpMessage = "Please enter your API public key")]
        [ValidateNotNullOrEmpty()]
        [string]$Api_Key_Public,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [securestring]$Api_Key_Secret
    )

    begin {}

    process {

        Set-Variable -Name "Datto_Public_Key" -Value $Api_Key_Public -Option ReadOnly -Scope global -Force
        Set-Variable -Name "Datto_Secret_Key" -Value $Api_Key_Secret -Option ReadOnly -Scope global -Force

    }

    end {}
}
