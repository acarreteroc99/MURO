
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

    [String]$WebInput,
    [String]$Mode
)

$USR = "ICORP\MURO_SS";
$SECRET = ConvertTo-SecureString -String "Domaincontroller123!" -AsPlainText -Force;
$CREDS = [pscredential]::new($USR,$SECRET);

$PROFTEMPL_PATH = "../json/Profiles/Templates";
$PROFTARGT_PATH = "../json/Profiles/Targets";
$MODULES_PATH = "./Modules";
$LOGS_PATH = "../logs";

$MODE = "";
$TARGETS_LIST = "";

# Set-Variable PROFTEMPL_PATH -option Constant -value "../jsonProfiles/Templates";
# Set-Variable PROFTARGT_PATH -option Constant -value "../json/Profiles/Targets";
# Set-Variable MODULES_PATH -option Constant -value "./Modules";
# Set-Variable LOGS_PATH -option Constant -value "../logs";

. "$MODULES_PATH/ModuleProfiles.ps1"
. "$MODULES_PATH/ModuleTargets.ps1"

# Read-Fields (function) here

# Implement-Targets (function) here

# Implement-Profiles (function) here

function WebInput-Parser([array] $info){

    $aux = $info.replace("/",",");
    $split1 = $aux.Split(";");

    foreach($el in $split1){
        $split2 += $el.Split(":")
    }

    return $split2;
}

function Word-Extractor([array]$arrayInp,[string]$flagName){

    $FileName="";

    for($pos=0; $pos -lt $($arrayInp.Length); $pos+=2){

        if($arrayInp[$pos] -eq $flagName){
            $FileName=$arrayInp[$($pos+1)];
            $pos=$arrayInp.length;
        }
    }

   # Write-Output "This is the position outside the if" $posFN;
   # Write-Output "This is the name of the file" $arrayInp[$posFN];

   return $FileName;
}

function Rule-Generator($webInp, $profFN, $targFN){

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] 'Rule-Generator' function has been entered" >> "$LOGS_PATH/fwEditor.log";

    $rules = @();

    # ============   WEBINPUT   ==============
    # $webCommand = "Set-NetFirewallRule ";
    # $webCommand = "Invoke-Command -ComputerName $TARGETS_LIST -Credential $CREDS -ScriptBlock { Set-NetFirewallRule ";
    $webCommand = " -Credential $CREDS -ScriptBlock { $MODE-NetFirewallRule ";

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Creation of the rule defined by the user through the GUI has started" >> "$LOGS_PATH/fwEditor.log";

    for($pos=0; $pos -le $webInp.length-1; $pos+=2){

        Switch($webInp[$pos]){
            "cust_targets" {$TARGETS_LIST += $webInp[$pos+1] + ","}

            "action" {$webCommand += "-Action " + $webInp[$pos+1] + " "}
            "dir" {$webCommand += "-Direction " + $webInp[$pos+1] + " "}
            "enabled" {$webCommand += "-Enabled " + $webInp[$pos+1] + " "}
            "localaddr" {$webCommand += "-LocalAddress " + $webInp[$pos+1] + " "}
            "name" {$webCommand += "-Name " + $webInp[$pos+1] + " "}
            "dispname" {$webCommand += "-DisplayName " + $webInp[$pos+1] + " "}
            "newname" {$webCommand += "-NewDisplayName " + $webInp[$pos+1] + " "}
            "port" {$webCommand += "-LocalPort " + $webInp[$pos+1] + " "}
            "protocol" {$webCommand += "-Protocol " + $webInp[$pos+1] + " "}
            "remaddr" {$webCommand += "-RemoteAddress " + $webInp[$pos+1] + " "}
        }

        if($webInp[$pos] -eq "dir"){
            Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Rule's direction is being extracted" >> "$LOGS_PATH/fwEditor.log";
            $dir = $webInp[$pos+1];
        }
    }

    # =============   TARGETS   ===============  
    # If a 'target' file has been defined, its content extraction will get started

    if($targFN.Length -ne 0){
        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Calling ModuleTargets.ps1" >> "$LOGS_PATH/fwEditor.log";
        $targetsInfo = Implement-Targets $targFN;
        $targetList = @();

        if($dir -eq "inbound"){
            Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Extracting inbound targets" >> "$LOGS_PATH/fwEditor.log";
            $numEl = $targetsInfo[0];
            $title = $targetsInfo[1];
            $recipients = $targetsInfo[2];
        }
        else {
            Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Extracting outbound targets" >> "$LOGS_PATH/fwEditor.log";
            $numEl = $targetsInfo[3];
            $title = $targetsInfo[4];
            $recipients = $targetsInfo[5];
        }

        $ctr=0;
        $acc=0;

        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Flags are being added to the targets according to the specified group" >> "$LOGS_PATH/fwEditor.log";
        foreach($el in $title){
            for($i=0; $i -le $numEl[$ctr]; $i++){

                $TARGETS_LIST += $recipients[$acc + $i] + ",";
                
                <#
                Switch($el){
                    "IPs" {$targetList += "-RemoteAddress " + $recipients[$acc + $i] + " "}
                    "Computers" {$targetList += "" + $recipients[$acc + $i] + " "}                # Test whether writing the name of a computer within the AD is resolved
                    # "Groups" {$command += "- " + $el + " "}               # Test whether writing the name of a Group belonging to the AD is resolved
                    # "OUs" {$command += "-Protocol " + $el + " "}          # Test whether writing the name of an OU belonging to the AD is resolved
                }
                #>
            }

            $ctr += 1;
            $acc += $numEl[$ctr];
        }

        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Rule coming from the website/GUI is being merged with specified targets" >> "$LOGS_PATH/fwEditor.log";
        <#
        foreach($el in $targetList){
            $rules += $webCommand + $el + ";";
        }
        #>
    }

    $TARGETS_LIST = $TARGETS_LIST.TrimEnd(",");

    $rules += "Invoke-Command -ComputerName $TARGETS_LIST" + $webCommand + "; }";

    <#
    else {
        $rules += $webCommand + ";";
    }
    #>

    # MERGE WITH SPECIFIED TARGETS WAS MADE HERE

    # ============   PROFILES   ================
    # If a profile has been defined, then rules will be "concatenated" to the one defined by the user
    if($profFN.Length -ne 0){
        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Calling ModuleProfiles.ps1" >> "$LOGS_PATH/fwEditor.log";

        $profileRules = Implement-Profiles $profFN;
        $listOfProfRules = @();

        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Creating rule from profiles' contents" >> "$LOGS_PATH/fwEditor.log";
        foreach($aux in $profileRules){
            foreach($rule in $aux){
                # $aux2 = "Set-NetFirewallRule " + $rule;
                $aux2 = "Invoke-Command -ComputerName $TARGETS_LIST -Credential $CREDS -ScriptBlock { $MODE-NetFirewallRule " + $rule + ";}";
                $listOfProfRules += $aux2;
            }
        }

        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Merging rules created from profiles with targets extracted previously" >> "$LOGS_PATH/fwEditor.log";

        foreach($target in $targetList){
            foreach($profRule in $listOfProfRules){
                $rules += $profRule + $target + " ;";
            }
        }
    }

    <#
    else {
        foreach($target in $targetList){
            $rules += $target + " ;";
        }
    }
    #>

    # MERGE WITH RULES FROM PROFILE WAS MADE HERE

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Exiting 'Rule-Generator' function" >> "$LOGS_PATH/fwEditor.log";
    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Results are being returned to caller... " >> "$LOGS_PATH/fwEditor.log";

    return $rules;
}

function main{

    if($WebInput.Length -gt 0){
        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Calling 'WebInput-Parser' function" >> "$LOGS_PATH/fwEditor.log";
        $webInp = WebInput-Parser $WebInput;
    }
    <#
    if($Profiles.Length -gt 0){
        $profInp = Implement-Profiles($Profiles);
    }
    if($Targets.Length -gt 0){
        $targInp = Implement-Targets($Targets);
    }
    #>

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Extracting filenames from Profiles and Targets files (if specified)" >> "$LOGS_PATH/fwEditor.log";
    $profFN = Word-Extractor $webInp "profiles";
    $targFN = Word-Extractor $webInp "targets";
    $MODE = Word-Extractor $webInp "mode";
    $MODE = $MODE.Substring(0,1).ToUpper()+$MODE.Substring(1).ToLower();

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Calling 'Rule-Generator' function..." >> "$LOGS_PATH/fwEditor.log";
    $new_rules = Rule-Generator $webInp $profFN $targFN;

    foreach($rule in $new_rules){
        Invoke-Expression $rule;
        Write-Output $rule;
    }
}

# 'main' function is invoked. Create to keep the script clean.
Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Calling function 'main" >> "$LOGS_PATH/fwEditor.log"; 
main;

<#
======================   NEXT STEPS   ======================
PENDING
1. Figure out how to introduce $CREDS in command without them turning into "System.Management.Automation.PSCredential"

COMPLETED
2. Check why network 13.13.13.0 is unable to arrive to net 12.12.12.0
3. Adequate "Profiles" option for web input - OK: solved as in "Targets"
4. Solve issue with "Targets" and "cust_targets" - OK: solved with new flag cust_targets
5. Include options to edit existing rule or create a new one - OK: solved by using variable $MODE
#>

