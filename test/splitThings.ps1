
# ---- String to be used as input for testing ----
# "action:block;port:3389;computers:WKS-WIN-ADMIN01/WKS-WIN-USR02;profile:Basics.json;targets:tmp_devices.json"

Param(
    [String] $Info
)

function Input-Parser($in){

    $aux = $in.replace("/",",");
    $split1 = $aux.Split(";");

    foreach($el in $split1){
        $split2 += $el.Split(":")
    }

    return $split2;
}

$results = Input-Parser($Info);

foreach($el in $results){
    # Write-Output $el;
}

$results[5].Split(",");
