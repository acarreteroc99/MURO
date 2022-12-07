
$PROFTARGT_PATH_MT = "../json/Profiles/Targets";
$LOGS_PATH_MT = "../logs/Modules";

function Implement-Targets{
    param(
        [Array] $targets
    )

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Starting execution of file 'ModuleTarget.ps1'" >> "$LOGS_PATH_MT/ModuleTargets.log";

    $inboundApps = @();             # Appearances for each group
    $inboundGroups = @();           # Groups extracted from JSON
    $inboundRecipients = @();       # Recipients for each group

    $outboundApps = @();             # Appearances for each group
    $outboundGroups = @();           # Groups extracted from JSON
    $outboundRecipients = @();       # Recipients for each group


    # Checking whether a JSON with targets has been submitted
    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Checking whether 'Targets' option has been submitted" >> "$LOGS_PATH_MT/ModuleTargets.log";
    if($targets.Length -ne 0){
        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Getting content from the selected target files" >> "$LOGS_PATH_MT/ModuleTargets.log";
        # For each file within the sent array, extract its content
        foreach($tgt in $targets){
            if($tgt.Length -ne 0){
                $templContent = $(Get-Content "$PROFTARGT_PATH_MT/$tgt" | Out-String | ConvertFrom-Json);

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
        Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] No targets file has been selected. Printing error message" >> "$LOGS_PATH_MT/ModuleTargets.log";
        Write-Output "Target files (JSON) have ot been selected";
    }

    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Exiting 'ModuleTarget.ps1'" >> "$LOGS_PATH_MT/ModuleTargets.log";
    Write-Output "[$((Get-Date -Format d).ToString()) $((Get-Date -Format t).ToString())] Returning results to caller..." >> "$LOGS_PATH_MT/ModuleTargets.log";
    
    return @($inboundApps, $inboundGroups, $inboundRecipients, $outboundApps, $outboundGroups, $outboundRecipients);
}

# Export-ModuleMember -Function Import-Targets