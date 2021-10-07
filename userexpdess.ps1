$OUpath = 'ou=Univet departments,dc=corona,dc=local' 
$ExportPath = 'c:\teszt\user_20200401.csv' 
Get-ADUser -Properties Title, Department, Enabled -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,Title,Department,Enabled | Export-Csv -NoType $ExportPath -Encoding UTF8