param (
    [switch]$Computers
)

$global:JSON_PATH = "../json"

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

    # Write-Host $str.substring(0, $str.Length-1)

    return $str.substring(0, $str.Length-1)
}

if($Computers -eq $True){
    
    $all_doms = @("icorp.local")
    $all_doms += Get_AllDomains("icorp.local")
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
}

# Get-ADComputer -Filter * -Properties * | Select -Property Name,DNSHostName,Enabled,LastLogonDate
