function Get-DattoAPISpec {
<#
    .SYNOPSIS
        Retrieves the OpenAPI (Swagger) specification for the Datto API.

    .DESCRIPTION
        The Get-DattoAPISpec cmdlet retrieves the OpenAPI (Swagger) specification
        for the Datto API. This specification provides a detailed description of
        the API endpoints, request and response formats, and other relevant
        information.

    .PARAMETER Raw
        If specified, retrieves the raw OpenAPI specification in YAML format.

    .EXAMPLE
        Get-DattoAPISpec

        Retrieves the OpenAPI specification in JSON format.

    .EXAMPLE
        Get-DattoAPISpec -Raw

        Retrieves the OpenAPI specification in raw YAML format.

    .NOTES
        Endpoint does not require authentication.

    .LINK
        https://celerium.github.io/Datto-PowerShellWrapper/site/OpenAPI/Get-DattoAPISpec.html

#>
    [CmdletBinding(DefaultParameterSetName = 'json')]
    [Alias('Get-DattoOpenAPI', 'Get-DattoSwagger')]
    param (
        [parameter(Mandatory = $false, ParameterSetName = 'yml')]
        [Alias('yaml', 'yml')]
        [switch]$raw
    )

    begin {

        $resource_uri = "/api/spec"

        if ($raw) {
            $resource_uri += '/raw'
        }
    }

    process {

        Write-Verbose "Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        Set-Variable -Name 'Datto_apiSpecParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-DattoRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -WarningAction SilentlyContinue

    }

    end {}
}