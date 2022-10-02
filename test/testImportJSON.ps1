
Param(

    [Switch]$LoadProf,
    [Array]$Profiles
)

$PROFILES_PATH = "../json/Profiles"

<#
function Implement-Module($name){

    $content = $(Get-Content "$PROFILES_PATH/$name" | Out-String | ConvertFrom-Json)

    return $content;
}

$content = Implement-Module($Profiles)

foreach($ruleType in $content.Inbound){
    Write-Output $ruleType.title
}

#>

function Select-Fields($rules){

    $list_commands = @();
    $command = "Set-NetFirewallRule ";

    foreach($el in $rules){
        $aux = $el.PSObject.Properties.Name; 

        foreach($flag in $aux){

            Switch($flag){
                "action" {$command +="-Action " + $el."$flag" + " "}
                "port" {$command = $command + "-LocalPort " + $el."$flag" + " "}
                "protocol" {$command = $command + "-Protocol " + $el."$flag" + " "}
            }
        }

        $list_commands += $command
        $command = "Set-NetFirewallRule ";
    }

    return $list_commands;

}

function Implement-Profile($names){

    foreach($prof in $names){
        $content = $(Get-Content "$PROFILES_PATH/$names" | Out-String | ConvertFrom-Json)
        
        $inboundRules += Select-Fields($content.Inbound)
        $outboundRules += Select-Fields($content.Outbound)

        # Run command depending on fields selected
        foreach($rule in $inboundRules){
            Invoke-Expression $rule;
        }
    }

    return @($inboundRules, $outboundRules);

}

$rules = Implement-Profile($Profiles);

# Write-Output $rules.GetType();

Write-Output $rules[0];
# Write-Output $rules[1];

# Write-Output $content.Inbound.PSObject.Properties.Value.Name
# Write-Output $($content.Inbound[0].PSObject.Properties.Name)[1]

#foreach($obj in $content.Inbound){
 #   Write-Output $obj.PSObject.Properties.Name
#}