
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
                "dir" {$command += "-Direction " + $el."$flag" + " "}
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

function Filename-Extractor($arrayInp, $flagName){

    $posFN=0;

    for($pos=0; $pos -le $arrayInp.length-1; $pos++){
        if($arrayInp[$pos] -eq $flagName){
            $posFN=$pos+1;
            $pos=$arrayInp.length;
        }
    }

   return $arrayInp[$posFN];
}

function Rule-Generator($webInp, $profFN, $targFN){

    $rules = @();

    # =============   TARGETS   ===============
    # If targets have been defined, the rule will apply to all of them
    if($targFN.Length -ne 0){
        $targetsInfo = Implement-Targets($targFN);
        $targetList = @();

        if($dir -eq "inbound"){
            $aux = $targetInfo[2];
        }
        else {
            $aux = $targetInfo[4];
        }

        foreach($el in $aux){
            Switch($el){
                "IPs" {$targetList += "-RemoteAddress " + $el + " "}
                "Computers" {$targetList += "" + $el + " "}                # Test whether writing the name of a computer within the AD is resolved
                # "Groups" {$command += "- " + $el + " "}               # Test whether writing the name of a Group belonging to the AD is resolved
                # "OUs" {$command += "-Protocol " + $el + " "}          # Test whether writing the name of an OU belonging to the AD is resolved
            }
        }
    }

    # ============   WEBINPUT   ==============
    $webCommand = "Set-NetFirewallRule ";

    # First, the "standard" defined by the user is created
    for($pos=0; $pos -le $arrayInp.length-1; $pos+=2){

        Switch($webInp[$pos]){
            "action" {$webCommand += "-Action " + $webInp[$pos+1] + " "}
            "dir" {$webCommand += "-Direction " + $webInp[$pos+1] + " "}
            "port" {$webCommand += "-LocalPort " + $webInp[$pos+1] + " "}
            "protocol" {$webCommand += "-Protocol " + $webInp[$pos+1] + " "}
        }

        if($webInp[$pos] -eq "dir"){
            $dir = $webInp[$pos+1];
        }
    }

    # Merging rule coming from web with targets
    foreach($el in $targetList){
        $rules += $webCommand + $el + ";";
    }

    # ============   PROFILES   ================
    # If a profile has been defined, then rules will be "concatenated" to the one defined by the user
    if($profFN.Length -ne 0){
        $profileRules = Implement-Profiles($profFN);
        $listOfProfRules = @();

        foreach($aux in $profileRules){
            foreach($rule in $aux){
                $aux2 = "Set-NetFirewallRule " + $rule + ";";
                $listOfProfRules += $aux2;
            }
        }
    }

    foreach($target in $targetList){
        foreach($profRule in $listOfProfRules){
            $rules += $profRule + $target;
        }
    }

    return $rules;
}

function main{

    if($WebInput.Length -gt 0){
        $webInp = WebInput-Parser($WebInput);
    }
    <#
    if($Profiles.Length -gt 0){
        $profInp = Implement-Profiles($Profiles);
    }
    if($Targets.Length -gt 0){
        $targInp = Implement-Targets($Targets);
    }
    #>

    $profFN = Filename-Extractor($webInp, "Profiles");
    $targFN = Filename-Extractor($webInp, "Targets");

    $new_rules = Rule-Generator($webInp, $profFN, $targFN);

    # Write-Output $rules[0];
    # Write-Output $rules[1];
}

# 'main' function is invoked. Create to keep the script clean. 
main;

<# NEXT STEPS   

2. "Rule-Generator" function must be finished. All information gathered from Profile, Targets and User's input must be combined to create a set of rules
that will be executed in the remote computers by using the "Invoke-Expression" command from powershell. 
3. The main "flow" of the program shall be reviewed (main function)
4. Integrate the "fwEditor.ps1" with the "AD_Enumerator.ps1" to finally create the tool
    4.1 NOTE: It makes more sense to integrate the AD_Enumerator.ps1 with the GUI, and then the GUI with the "FWEditor.ps1"
5. Maybe, transform the tool into a more modular tool to make it easier for people to do extra things. 
    5.1 This means to separate each feature into different files, and then have a sole, main file that calls functions from each
    file. 
#>


