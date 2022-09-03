param (
    [switch]$Computers
)

if($Computers -eq $True){
    
    <#
    Get-ADComputer -Filter * -Properties * `
    | Select -Property Name,DNSHostName,Enabled,LastLogonDate `
    | ConvertTo-Json
    #>

    $DN = Get-ADComputer -Identity "WKS-WIN-ADMIN01" -Properties * | Select -Property DNSHostName
    # $dom = $DN.DNSHostName | Select-String -Pattern '.*' 
    # $values = (($DN.DistinguishedName)).split(",")
    $begin = $DN.DNSHostName.IndexOf('.') + 1
    Write-Host (($DN.DNSHostName)).substring($begin)
}

# Get-ADComputer -Filter * -Properties * | Select -Property Name,DNSHostName,Enabled,LastLogonDate
