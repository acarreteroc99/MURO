Param(
    [String] $Info
)

function Input-Parser($input){

    $inputSplit = $input.Split(";");

    Write-Output $inputSplit.GetType();

    return $inputSplit;

}

$results = Input-Parser($Info);

Write-Output $results[0];


# ---- String to be used as input for testing ----
# 'action:block;port:3389;computers:WKS-WIN-ADMIN01/WKS-WIN-USR02;profile:Basics.json;targets:tmp_devices.json'