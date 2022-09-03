# =============================================================================
#                           AD Enumeration script
#   --------------------------------------------------------------------------
#   | Goal   | To extract all valuable information from an specified domain.
#   |-------------------------------------------------------------------------
#   | Input  | Active Directory domain
#   |-------------------------------------------------------------------------
#   | Output | <domain>_computers.json
#   |        |----------------------------------------------------------------
#   |        | <domain>_domains.json
#   |        |----------------------------------------------------------------
#   |        | <domain>_GPOs.json
#   |        |----------------------------------------------------------------
#   |        | <domain>_groups.json
#   |        |----------------------------------------------------------------
#   |        | <domain>_OUs.json
#   |        |----------------------------------------------------------------
#   |        | <domain>_users.json
#   |        |----------------------------------------------------------------
#   --------------------------------------------------------------------------
# ===============================================================================

# Parameter definition
Param(
    [Parameter(Mandatory)]
    $ADDomain,

    [switch]$All,
    [switch]$Computers,
    [switch]$Domains,
    [switch]$GPOs,
    [switch]$Groups, 
    [switch]$OUs,
    [switch]$Users
)

If($All -eq $True){
    $Computers = $True
    $Domains = $True
    $GPOs = $True
    $Groups = $True
    $OUs = $True
    $Users = $True 
}

# Importing Modules
Import-Module ActiveDirectory

function extractDomain($str){
    $pos = $str.IndexOf('.') + 1
    $dom = (($str)).substring($pos)

    return $dom
}

# Computer extraction
If($Computers -eq $True){
    Get-ADComputer -Filter * -Properties * `
    | Select -Property Name,DNSHostName,Enabled,LastLogonDate `
    | ConvertTo-Json

    # Call function extractDomain(str) to extract the domain from the properties
}

# To search in multiple domains, do: Get-ADComputer -Filter * -SearchBase "DC=MyOtherDomain,DC=com" -Server "MyOtherDomain.com" 

# Domains extraction
If($Domains -eq $True){
    
}

# GPO extraction
If($GPOs -eq $True){
    
}

# Groups extraction
If($Groups -eq $True){
    
}

# OUs extraction
If($OUs -eq $True){
    
}

# Users extraction
If($Users -eq $True){
    
}

