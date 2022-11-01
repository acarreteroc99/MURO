
$PROFTARGT_PATH = "../json/Profiles/Targets";
function Implement-Targets{
    param(
        [Array] $targets
    )

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

# Export-ModuleMember -Function Import-Targets