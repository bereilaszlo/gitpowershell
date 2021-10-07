# Import required modules
Import-Module ActiveDirectory

echo "`nBe kell lépnünk az Azureba, add meg az azonosító/jelszavad!"

#Belépünk Azureba
Connect-MsolService

# Start the loop and force-set exit variable
$exit = ""
while($exit -ne "q") {
    $lname = Read-Host -Prompt "`nCsaládnév?"
	$fname = Read-Host -Prompt "`nKeresztnév?"
	$username = Read-Host -Prompt "`nAzonosító? (3 betű, 4 szám)"
    $emailaddress = Read-Host -Prompt "`nEmail-cím?"
	

    # Do not allow blank names
    if($fname -ne "" -and $lname -ne "") {
        
        # Create variables based on input
        $fullname = "$lname $fname" # Combining first and last name for the user name
        $OUpath = "OU=Univet departments,DC=univet,DC=local" # Change 'DC=itflee' to reflect whatever your domain is

        # Create the user account
        # New-ADUser -name $fullname -GivenName $fname -Surname $lname -SamAccountName $username -Path $OUpath -AccountPassword (ConvertTo-SecureString -AsPlainText "Ate2017!" -Force) -ChangePasswordAtLogon $False -Enabled $True

	    New-ADUser -SamAccountName "$username" -Name "$fullname" -DisplayName "$fullname" -GivenName $fname -Surname $lname -UserPrincipalName ("{0}@{1}" -f $username,"univet.hu") -Path $OUpath -AccountPassword (ConvertTo-SecureString -AsPlainText "Ate2017!" -Force) -PasswordNeverExpires $True -EmailAddress $emailaddress  -OtherAttributes @{'proxyAddresses'="SMTP:$emailaddress"} -Company "Állatorvostudományi Egyetem" -Enabled $True

		
        # Notify account creation
        echo "`nA felhasználót létrehoztam a helyi AD-ben következő névvel: $fullname"
		
		#Kérdezzük meg az átmozgatást
		$mozg = {
			$siker = Read-Host -Prompt "`nMozgasd át a felhasználót az AD-ben az egységébe! Sikerült? A válasz után 1 percet várunk... (I/N)"
		
				if($siker -eq "I") {
			
				Start-ADSyncSyncCycle -PolicyType Delta
			
			                    }else{
				echo "`nIgyekezz! Nem tudsz dönteni?."
				
			Start-Sleep -s 5
		&$mozg
                                      }	
	             }
		&$mozg	
		
        #Várakozás 1 percig
		
		#echo "`nMost várunk 1 percet, hogy a szinkron végigfusson. Ugye van neted?"
		Start-Sleep -s 60
		
        #Kérdezzük meg az O365 licensz?
		
		$licensz = {
			$siker2 = Read-Host -Prompt "Felkerült felhőbe a felhasználó? Készíthetjük a licenszet? (I/N)"
			
				if($siker2 -eq "I") {
			
				Set-MsolUser -UserPrincipalName ("{0}@{1}" -f $username,"univet.hu") -UsageLocation "HU"
				Set-MsolUserLicense -UserPrincipalName ("{0}@{1}" -f $username,"univet.hu") -AddLicenses "allatorvosiegyetem:STANDARDWOFFPACK_IW_FACULTY"
			
			                    }else{
				echo "Igyekezz! Nem tudsz dönteni?."
			Start-Sleep -s 5
		&$licensz
									}
					}
		&$licensz
		
        # Continue creating accounts?
        $exit = Read-Host -Prompt "`nNyomj 'enter'-t új felhasználóhoz, vagy 'q' a kilépéshez."
    }else{
        echo "Kérlek valós adatokat adj meg, üresen nem jó."
    }
	}