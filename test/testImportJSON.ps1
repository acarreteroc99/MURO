
Param(

    # [Switch]$LoadProf,
    [Array]$Profiles
    # [Array] $Targets
)

$PROFTARGT_PATH = "../json/Profiles/Targets";
$PROFTEMPL_PATH = "../json/Profiles/Templates";

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

# =====================================================================
#                   COMMAND CREATION FROM JSON - TESTS
# =====================================================================

function Select-Fields($rules){

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
        # $command = "Set-NetFirewallRule ";
        $command = "";
    }

    return $list_commands;

}

function Implement-Profile($names){

    foreach($prof in $names){
        $content = $(Get-Content "$PROFTEMPL_PATH/$prof" | Out-String | ConvertFrom-Json)
        
        $inboundRules += Select-Fields($content.Inbound)
        $outboundRules += Select-Fields($content.Outbound)

        # Run command depending on fields selected
        foreach($rule in $inboundRules){
            # Invoke-Expression $rule;
        }
    }

    return @($inboundRules, $outboundRules);

}

$rules = Implement-Profile($Profiles);

Write-Output $rules[0];
Write-Output $rules[1];


# =====================================================================
#                   TARGET EXTRACTION - TESTS
# =====================================================================
<#
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
        Write-Output $targets.Length;
        Write-Output "Hello user: targets have not been selected";
    }

    return @($inboundApps, $inboundGroups, $inboundRecipients, $outboundApps, $outboundGroups, $outboundRecipients);
}

$targets = Implement-Targets($Targets);

Write-Output $targets[4];
# Write-Output $targets[0].title[0];
# Write-Output $targets[0].recipients[0];
# Write-Output $targets[1];
#>






