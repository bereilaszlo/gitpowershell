import-csv "C:\ADUsers\" | ForEach-Object {add-ADGroupMember -Identity $_.groupname -Members $_.username} 
