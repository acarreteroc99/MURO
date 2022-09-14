<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="../css/stylesheet.css" type="text/css" />
    </head>
    <body>
        <?php
        include_once __DIR__.'/controller/controller_main.php';
        ?>

        <h1 id="pageTitle"> MURO Dashboard </h1>
        <section>
            <div id="elements">
                <input id="ruleBar" type="text" placeholder="Set rule..." style="grid-area: rule-box"></br>
                <h2 style="grid-area: wks-title" class="el-item-title"> Workstations </h2>  
                <div style="grid-area: wks-box" class="elements-item">
                    <table id="wks-table" > 
                        <thead>
                            <th> Id </th>
                            <th> OS </th>
                        </thead>
                        <tbody>

                        </tbody>
                    </table> 
                </div>
                <h2 style="grid-area: users-title" class="el-item-title"> Users </h2> 
                <div style="grid-area: users-box" class="elements-item"> </div>
                <h2 style="grid-area: groups-title" class="el-item-title"> Groups </h2> 
                <div style="grid-area: groups-box" class="elements-item"> </div>
                <h2 style="grid-area: ous-title" class="el-item-title"> Organizatinal Unit </h2> 
                <div style="grid-area: ous-box" class="elements-item"> </div>
                <h2 style="grid-area: domains-title" class="el-item-title"> Domains </h2> 
                <div style="grid-area: domains-box" class="elements-item"> </div>
                <h2 style="grid-area: forests-title" class="el-item-title"> Forests </h2> 
                <div style="grid-area: forests-box" class="elements-item"> </div>
            </div>
        </section>
    </body>
</html>