# =============================================================================
#                           AD Enumeration script
#   --------------------------------------------------------------------------
#   | Goal   | To extract all valuable information from an specified domain.
#   |-------------------------------------------------------------------------
#   | Input  | Active Directory domain
#   |-------------------------------------------------------------------------
#   | Output | computers.json
#   |        |----------------------------------------------------------------
#   |        | domains.json
#   |        |----------------------------------------------------------------
#   |        | forest.json
#   |        |----------------------------------------------------------------
#   |        | groups.json
#   |        |----------------------------------------------------------------
#   |        | OUs.json
#   |        |----------------------------------------------------------------
#   |        | users.json
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

function buildSearchBaseStr($dom){
    $str = ""
    $num = ($dom.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).count
    $dom = $dom.split(".")
    
    ForEach($part in $dom){
        $str = $str+"DC="+$part+","
    }

    return $str.substring(0, $str.Length-1)
}

Clear-Content "$JSON_PATH/computers.json"
Clear-Content "$JSON_PATH/domains.json"
Clear-Content "$JSON_PATH/forest.json"
Clear-Content "$JSON_PATH/groups.json"
Clear-Content "$JSON_PATH/OUs.json"
Clear-Content "$JSON_PATH/users.json"

# Computer extraction
If($Computers -eq $True){
    $all_doms = @($ADDomain)
    $all_doms += Get_AllDomains($all_doms[0])
    $tmp = @()

    ForEach($child in $all_doms){
        $sb_str = buildSearchBaseStr($child)
        Get-ADComputer -Filter * -SearchBase "$sb_str" -Server "$child" -Properties * `
        | Select -Property Name,DNSHostName,Enabled,ObjectClass,OperatingSystem `
        | ConvertTo-Json -Compress `
        | Add-Content "$JSON_PATH/computers.json"
    }

    $aux = (Get-Content "$JSON_PATH/computers.json") | Out-String
    "$aux".replace("]"+$([Environment]::NewLine)+"[",",") | ConvertFrom-Json | ConvertTo-Json | Set-Content "$JSON_PATH/computers.json"

    # Extract Domain and insert in Json
}

# Domains extraction
If($Domains -eq $True){ 
    $all_doms = @($ADDomain)
    $all_doms += Get_AllDomains($all_doms[0])
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
   
    $all_doms = @($ADDomain)
    $all_doms += Get_AllDomains($all_doms[0])
    $tmp = @()

    ForEach($child in $all_doms){
        $sb_str = buildSearchBaseStr($child)
        Get-ADUser -Filter * -SearchBase "$sb_str" -Server "$child" -Properties * `
        | Select -Property Name,SAMAccountName,UserPrincipalName `
        | ConvertTo-Json -Compress `
        | Add-Content "$JSON_PATH/users.json"
    }

    $aux = (Get-Content "$JSON_PATH/users.json") | Out-String
    "$aux".replace("]"+$([Environment]::NewLine)+"[",",") | ConvertFrom-Json | ConvertTo-Json | Set-Content "$JSON_PATH/users.json"
}

