#Remove External User

$credential = get-credential

Connect-msolservice -credential $credential

Connect-sposervice -url https://bennettbizdemo-admin.sharepoint.com -credential $credential

get-spoexternaluser -position 0 -pagesize 30 | select Displayname,email | format-table

$user = Get-SPOExternalUser -Filter sbfortesting@outlook.com

Remove-SPOExternalUser -UniqueIDs @($user.UniqueId)

