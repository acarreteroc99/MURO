
$PROFTEMPL_PATH = "../json/Profiles/Templates";
function Read-Fields($rules){

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] 'Read-Fields' function entered" >> "$LOGS_PATH/ModuleProfiles.log";

    $list_commands = @();
    $command = "";

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Converting JSON objects into rules..." >> "$LOGS_PATH/ModuleProfiles.log";

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
    }

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Exiting 'Read-Fields' function" >> "$LOGS_PATH/ModuleProfiles.log";

    return $list_commands;
}

function Implement-Profiles{
    param(
        [Array] $profiles
    )

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Getting selected profile files..." >> "$LOGS_PATH/ModuleProfiles.log";

    foreach($prof in $profiles){
        if($prof.Length -ne 0){
            Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Getting content from $PROFTEMPL_PATH/$prof" >> "$LOGS_PATH/ModuleProfiles.log";
            $templContent = $(Get-Content "$PROFTEMPL_PATH/$prof" | Out-String | ConvertFrom-Json);
            
            $inboundRules += Read-Fields($templContent.Inbound);
            $outboundRules += Read-Fields($templContent.Outbound);
        }
    }

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Exiting 'ModuleProfiles.ps1'" >> "$LOGS_PATH/ModuleProfiles.log";
    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Returning results to caller..." >> "$LOGS_PATH/ModuleProfiles.log";

    return @($inboundRules, $outboundRules);

}

# Export-ModuleMember -Function Implement-Profiles