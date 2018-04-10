param($Username,$Password,$Name)
$Secstr = New-Object -TypeName System.Security.SecureString
$Password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
$LiveCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $Username, $Secstr
Import-Module MSOnline

If ($Name -like "*Azure DE*")
{
	Login-AzureRmAccount -EnvironmentName AzureGermanCloud -Credential $LiveCred
}
Else 
{
	Login-AzureRmAccount -Credential $LiveCred
}

