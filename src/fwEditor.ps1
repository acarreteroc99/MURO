
# =============================================================================
#                         Local FW Editor script
#
# Script that, given an input, modifies the local firewall of the specified assets: 
# computers, groups, OUs...
#
#
# =============================================================================

# Posible input: workstations, users, groups, OUs, Domains, Forests

# ----- FLAGS -----

Param(

    [Array]$Computers,
    [Array]$Domains,
    [Array]$Forest,
    [Array]$Groups, 
    [Array]$OUs,
    [Array]$Users,

    [Switch]$LoadProf,
    [Array]$Profile
)

$PROFILES_PATH = "../json/Profiles"

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

        foreach($rule in $outboundRules){
            Invoke-Expression $rule;
        }
    }

    return @($inboundRules, $outboundRules);

}

$rules = Implement-Profile($Profiles);

Write-Output $rules[0];

 

