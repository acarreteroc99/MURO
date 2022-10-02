

<#

$sent = "This`nis`na`ntest"

$aux = $sent.replace("`nis`na", "`nare not")

Write-Host $aux

#>

Param(

    [Array]$Computers
)

Write-Output $Computers.GetType()

$counter=0

Write-Output "THIS IS THE BEST COMPUTER EVER, COMPUTER $($Computers[1])"

foreach($wks in $Computers){
    Write-Output "Computer number $counter is $wks"
    $counter = $counter + 1;
}