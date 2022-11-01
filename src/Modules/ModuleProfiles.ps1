
$PROFTEMPL_PATH = "../json/Profiles/Templates";
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

function Implement-Profiles{
    param(
        [Array] $profiles
    )

    foreach($prof in $profiles){
        if($prof.Length -ne 0){
            $templContent = $(Get-Content "$PROFTEMPL_PATH/$prof" | Out-String | ConvertFrom-Json);
            
            $inboundRules += Read-Fields($templContent.Inbound);
            $outboundRules += Read-Fields($templContent.Outbound);
        }
    }

    return @($inboundRules, $outboundRules);

}

# Export-ModuleMember -Function Implement-Profiles