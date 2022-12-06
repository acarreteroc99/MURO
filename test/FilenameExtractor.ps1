function WebInput-Parser([array] $info){

    $aux = $info.replace("/",",");
    $split1 = $aux.Split(";");

    foreach($el in $split1){
        $split2 += $el.Split(":")
    }

    return $split2;
}

function Filename-Extractor([array]$arrayInp,[string]$flagName){

    $FileName="N/A";

    for($pos=0; $pos -le $($arrayInp.Length-1); $pos++){

        if($arrayInp[$pos] -eq $flagName){
            $FileName=$arrayInp[$pos+1];
            $pos=$arrayInp.length;
        }
    }

   return $FileName;
}

$WebInput = "action:block";
$webInp = WebInput-Parser $WebInput;

$targFN = Filename-Extractor $webInp "Targets";

Write-Output $targFN;