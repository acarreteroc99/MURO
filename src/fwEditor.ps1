
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
    [Array]$Targets,

    [String]$WebInput
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

function WebInput-Parser($info){

    $aux = $info.replace("/",",");
    $split1 = $aux.Split(";");

    foreach($el in $split1){
        $split2 += $el.Split(":")
    }

    return $split2;

}

function Rule-Generator(){

}

function main{

    if($WebInput.Length -gt 0){
        $webIn = WebInput-Parser($WebInput);
    }
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

<# NEXT STEPS   

1. Input from website may contain arrays (string which have a ',' between two names). This must be converted into arrays by using the .Split function:
    $results[5].Split(",");
2. "Rule-Generator" function must be finished. All inforation gathered from Progile, Targets and User's input must be combined to create a set of rules
that will be executed in the remote computers by using the "Invoke-Expression" command from powershell. 
3. The main "flow" of the program shall be reviewed *(main function)
4. Integrate the "fwEditor.ps1" with the "AD_Enumerator,ps1" to finally create the tool
5. Maybe, transform the tool into a more modular tool to make it easier for people to do extra things. 

#>


