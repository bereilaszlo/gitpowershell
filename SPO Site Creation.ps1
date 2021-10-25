#Login

$credential = Get-Credential

Connect-MsolService -Credential $credential

#Commands to connect to SharePoint Online.

Connect-SPOService -Url https://bennettbizdemo-admin.sharepoint.com -credential $credential


#Example for SPO Collection Creation & Deletion

New-SPOSite -Url https://bennettbizdemo.sharepoint.com/sites/demosite3 -Owner o365admin@bennettbizdemo.onmicrosoft.com -StorageQuota 1024

Remove-SPOSite -Identity https://bennettbizdemo.sharepoint.com/sites/demosite3 -NoWait

Restore-SPODeletedSite -Identity https://bennettbizdemo.sharepoint.com/sites/demosite3
