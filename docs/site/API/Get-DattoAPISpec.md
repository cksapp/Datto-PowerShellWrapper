---
external help file: DattoAPI-help.xml
grand_parent: API
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/API/Get-DattoAPISpec.html
parent: GET
schema: 2.0.0
title: Get-DattoAPISpec
---

# Get-DattoAPISpec

## SYNOPSIS
Retrieves the OpenAPI (Swagger) specification for the Datto API.

## SYNTAX

### json (Default)
```powershell
Get-DattoAPISpec [<CommonParameters>]
```

### yml
```powershell
Get-DattoAPISpec [-raw] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoAPISpec cmdlet retrieves the OpenAPI (Swagger) specification
for the Datto API.
This specification provides a detailed description of
the API endpoints, request and response formats, and other relevant
information.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoAPISpec
```

Retrieves the OpenAPI specification in JSON format.

### EXAMPLE 2
```powershell
Get-DattoAPISpec -Raw
```

Retrieves the OpenAPI specification in raw YAML format.

## PARAMETERS

### -raw
If specified, retrieves the raw OpenAPI specification in YAML format.

```yaml
Type: SwitchParameter
Parameter Sets: yml
Aliases: yaml, yml

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Endpoint does not require authentication.

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/OpenAPI/Get-DattoAPISpec.html](https://celerium.github.io/Datto-PowerShellWrapper/site/OpenAPI/Get-DattoAPISpec.html)

