Import-Module ActiveDirectory
$userou = 'OU=Students,DC=corona,DC=local'
$users = Get-ADUser -SearchBase $userou -Filter * -Properties pwdlastset
foreach ($user in $users) {
Set-ADUser -Identity $user.samaccountname -Replace @{pwdlastset="0"}
}

Start-Sleep -s 120

Import-Module ActiveDirectory
$userou = 'OU=Students,DC=corona,DC=local'
$users = Get-ADUser -SearchBase $userou -Filter * -Properties pwdlastset
foreach ($user in $users) {
Set-ADUser -Identity $user.samaccountname -Replace @{pwdlastset="-1"}
}