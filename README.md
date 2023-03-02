<!-- <div style="text-align: center;"> -->
![alt text](https://github.com/acarreteroc99/MURO/blob/main/imgs/png/MURO_logo.png "MURO logo")
<!-- </div> -->

## What is MURO?

MURO is a tool aimed to increase microsegmentation in a local firewall level, protecting your endpoints from lateral movements, port scanning and other attacks. MURO is able to extract information from your AD, allowing the IT administration to set policies according to your network's architecture. 

## What functionalities does MURO include?

MURO allows to edit any computer's local firewall enrolled in an Actve Directory either through a GUI or script FW_Editor.ps1. Additionally, multiple devices can be manipulated by using a "Targets" template or define a standard configuration by deploying a "Profile". 

## Using MURO

### Regular usage

### Profiles

MURO allows users to create a set of rules for multiple devices. By creating "Profiles", which are rules structured in a JSON format, users can load them to MURO and edit multiple firewalls from different endpoints at once. 

| Flag | Type | Description | Example |
|---|---|---|---|
| -Profiles  | Array | Multiple profiles can be deployed at once  | .\MURO -Profiles "Basics.json","IT-Profile.json" |
| -Targets  | Array | Multiple targets can be imoprted from file | .\MURO -Targets "tmp_devices.json","wks.json" |
|   |   | | |
