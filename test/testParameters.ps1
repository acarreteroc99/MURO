param (
    [switch]$Domain
)

if($Domain -eq $True){
    
    # $dom = New-Object System.Collections.ArrayList
    $dom = @()
    $tmp = Get-ADDomain -Identity "icorp.local" | Select ChildDomains

    while($tmp -ne $null){
        $dom += $tmp.ChildDomains

        ForEach($aux in $tmp){
            $aux2 = $aux.ChildDomains
            If($aux -ne $null){
                Write-Host $aux2
                $tmp2 += Get-ADDomain -Identity "$aux2" | Select ChildDomains
            }
        }
        $tmp = $tmp2.ChildDomains
    }

    ForEach($domi in $dom){
        Write-Host $domi
    }

}

# Get-ADComputer -Filter * -Properties * | Select -Property Name,DNSHostName,Enabled,LastLogonDate
