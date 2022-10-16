
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

    [Array]$Profiles,
    [Array]$Targets
)

$PROFTEMPL_PATH = "../json/Profiles/Templates";
$PROFTARGT_PATH = "../json/Profiles/Targets";

function Read-Fields($rules){

    $list_commands = @();
    # $command = "Set-NetFirewallRule ";
    $command = "";

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
        $command = "";
        # $command = "Set-NetFirewallRule ";
    }

    return $list_commands;

}

function Implement-Targets($targets){

    $inboundApps = @();             # Appearances for each group
    $inboundGroups = @();           # Groups extracted from JSON
    $inboundRecipients = @();       # Recipients for each group

    $outboundApps = @();             # Appearances for each group
    $outboundGroups = @();           # Groups extracted from JSON
    $outboundRecipients = @();       # Recipients for each group


    # Checking whether a JSON with targets has been submitted
    if($targets.Length -ne 0){
        foreach($tgt in $targets){
            if($targets.Length -ne 0){
                $templContent = $(Get-Content "$PROFTARGT_PATH/$tgt" | Out-String | ConvertFrom-Json);

                foreach($el in $templContent.Inbound){
                    $inboundApps += $el.recipients.Length;
                    $inboundGroups += $el.title;
                    $inboundRecipients += $el.recipients;
                }

                foreach($el in $templContent.Outbound){
                    $outboundApps += $el.recipients.Length;
                    $outboundGroups += $el.title;
                    $outboundRecipients += $el.recipients;
                }
            }
        }
    }
    else{
        Write-Output "Hello user: targets have not been selected";
    }

    return @($inboundApps, $inboundGroups, $inboundRecipients, $outboundApps, $outboundGroups, $outboundRecipients);
}

function Implement-Profiles($profiles){

    foreach($prof in $profiles){
        if($prof.Length -ne 0){
            $templContent = $(Get-Content "$PROFTEMPL_PATH/$prof" | Out-String | ConvertFrom-Json);
            
            $inboundRules += Read-Fields($templContent.Inbound);
            $outboundRules += Read-Fields($templContent.Outbound);
        }
    }

    return @($inboundRules, $outboundRules);

}

function Input-Parser($input){

    $inputSplit = $input.Split(";");

}

function Rule-Generator(){

}

function main{

    if($Profiles.Length -gt 0){
        $rules = Implement-Profiles($Profiles);
    }
    if($Targets.Length -gt 0){
        $targets = Implement-Targets($Targets);
    }

    Write-Output $rules[0];
    Write-Output $rules[1];
}

# 'main' function is invoked. Create to keep the script clean. 
main;

<# TO BE IMPLEMENTED

1. To which endpoints do profiles apply to? Can be defined either by:
    1.1 Standard flags defined in console
    1.2 Load from JSON file

#>


