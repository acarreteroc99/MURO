
<?php
function readJSON(filename){
    $file = fopen($filename, "r");
    $data = fread($file, filesize($filename));
    fclose($file);

    return $data
}
?>