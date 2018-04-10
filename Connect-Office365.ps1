
param($Username,$Password,$Name)
$Secstr = New-Object -TypeName System.Security.SecureString
$Password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
$LiveCred = new-object -typename System.Management.Automation.PSCredential -argumentlist $Username, $Secstr
If ($Name -like "*Office 365 DE*")
{
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office.de/powershell-liveid/ -Credential $LiveCred -Authentication Basic -AllowRedirection
}
Else 
{
	$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $LiveCred -Authentication Basic -AllowRedirection
}

$NAME 
Import-PSSession $Session

#Remove-PSSession $Session