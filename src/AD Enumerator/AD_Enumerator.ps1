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
    [switch]$Forest,
    [switch]$Groups, 
    [switch]$OUs,
    [switch]$Users
)

If($All -eq $True){
    $Computers = $True
    $Domains = $True
    $Forest= $True
    $Groups = $True
    $OUs = $True
    $Users = $True 
}

# Importing Modules
Import-Module ActiveDirectory

$global:JSON_PATH = "../../json"

function extractDomain($str){
    $pos = $str.IndexOf('.') + 1
    $dom = (($str)).substring($pos)

    return $dom
}

function Get_AllDomains($rootDom){
    $dom = @()
    $tmp = Get-ADDomain -Identity "$rootDom" | Select ChildDomains

    while($tmp -ne $null){
        $dom += $tmp.ChildDomains

        ForEach($aux in $tmp){
            $aux2 = $aux.ChildDomains
            If($aux -ne $null){
                $tmp2 += Get-ADDomain -Identity "$aux2" | Select ChildDomains
            }
        }
        $tmp = $tmp2.ChildDomains
    }

    return $dom
}

# Computer extraction
If($Computers -eq $True){
    Get-ADComputer -Filter * -Properties * `
    | Select -Property Name,DNSHostName,Enabled,ObjectClass,OperatingSystem `
    | ConvertTo-Json `
    | Out-File "$JSON_PATH/computers.json"

    # Extract Domain and insert in Json
    # To search in multiple domains, do: Get-ADComputer -Filter * -SearchBase "DC=MyOtherDomain,DC=com" -Server "MyOtherDomain.com" 
}

# Domains extraction
If($Domains -eq $True){ 
    $all_doms = @($ADDomain)
    $all_doms += Get_AllDomains($ADDomain)
    ConvertTo-Json -InputObject $all_doms `
    | Out-File "$JSON_PATH/domains.json"
}


# Forest extraction
If($Forest -eq $True){
    Get-ADForest `
    | Select Domains,Name,RootDomain,Sites `
    | ConvertTo-Json `
    | Out-File "$JSON_PATH/forest.json"
}


# Groups extraction
If($Groups -eq $True){
    Get-ADGroup -Filter * `
    | Select Name,DistinguishedName,GroupScope `
    | ConvertTo-Json `
    | Out-File "$JSON_PATH/groups.json"

    # Extract domain and insert in Json
}

# OUs extraction
If($OUs -eq $True){
    Get-ADOrganizationalUnit -Filter * `
    | Select City,Country,Name `
    | ConvertTo-Json `
    | Out-File "$JSON_PATH/OUs.json"
}

# Users extraction
If($Users -eq $True){
    Get-ADUser -Filter * `
    | Select Name,SAMAccoutnName,UserPrincipalName `
    | ConvertTo-Json `
    | Out-File "$JSON_PATH/users.json"

    # To search in multiple domains, do: Get-ADUser -Filter * -SearchBase "DC=MyOtherDomain,DC=com" -Server "MyOtherDomain.com"
}

