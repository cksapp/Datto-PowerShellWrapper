---
external help file: DattoAPI-help.xml
grand_parent: SaaS
Module Name: DattoAPI
online version: https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSeat.html
parent: GET
schema: 2.0.0
title: Get-DattoSeat
---

# Get-DattoSeat

## SYNOPSIS
Get Datto SaaS protection seats for a given customer

## SYNTAX

```powershell
Get-DattoSeat -saasCustomerId <Int32> [-seatType <String[]>] [<CommonParameters>]
```

## DESCRIPTION
The Get-DattoSeat cmdlet gets Datto SaaS protection seats
for a given customer

## EXAMPLES

### EXAMPLE 1
```powershell
Get-DattoSeat -saasCustomerId "123456"
```

Gets the Datto SaaS protection seats from the define customer id

### EXAMPLE 2
```powershell
Get-DattoSeat -saasCustomerId "123456" -seatType "User"
```

Gets the Datto SaaS protection seats from the define customer id filtered to 'User' seats

### EXAMPLE 3
```powershell
Get-DattoSeat -saasCustomerId "123456" -seatType "User", "SharedMailbox"
```

Gets the Datto SaaS protection seats from the define customer id filtered to 'User' & 'SharedMailbox' seats

## PARAMETERS

### -saasCustomerId
Defines the id of the Datto SaaS organization

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -seatType
Defines the seat type to get

This is a case-sensitive value

Example:
    Office365: 'User', 'SharedMailbox', 'Site', 'TeamSite', 'Team'
    Google:    'User', 'SharedDrive'

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSeat.html](https://celerium.github.io/Datto-PowerShellWrapper/site/SaaS/Get-DattoSeat.html)

