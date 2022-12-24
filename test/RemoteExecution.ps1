$USR = "ICORP\MURO_SS";
$SECRET = ConvertTo-SecureString -String "Domaincontroller123!" -AsPlainText -Force;
$CREDS = [pscredential]::new($USR,$SECRET);
## $CREDS = new-object -typename System.Management.Automation.PSCredential -argumentlist $USR, $SECRET

Invoke-Command -ComputerName 12.12.12.129 -Credential $CREDS -ScriptBlock { New-Item C:\Users\MURO_SS\Desktop\WinRM_TEST2.txt }