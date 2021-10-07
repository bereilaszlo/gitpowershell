<#
Requirement(s): 

1) The target machine executing this script needs to be able to Import-Module ActiveDirectory. 
   This module is available under Control Panel > Turn Windows features on or off > Remote Server Admin Tools > 
   Role Admin Tools > AD DS and AD LDS Tools > Active Directory Module for Windows PowerShell.

2) If you do not have this option available under 'Turn Windows features on or off' menu, then you might have to install
   it from Microsoft - https://www.microsoft.com/en-us/download/confirmation.aspx?id=7887 first.

Purpose:	           

This script will allow you to check a domain account against active directory to determine the following details:

   				   User
				   FullName
				   PasswordNeverExpires
				   PasswordLastSet
				   LockedOut
				   Enabled
				   RemainingDays
				   PasswordExpiresIn

Execution:

Navigate to script location and execute script with domain username as an argument.

				    User                 : Knguyen
				    FullName             : Khoa Nguyen
				    PasswordNeverExpires : False
				    PasswordLastSet      : 12/11/2017 09:58:39
				    LockedOut            : False
				    Enabled              : True
				    RemainingDays        : 3/11/2018
				    PasswordExpiresIn    : 88 Days
#>

#This requires that a domain username is passed into the script during execution, without it, the catch error exception will run.
param (
[Parameter(Mandatory=$true)]
[string] $UserName
)

#Imports the necessary AD module for PowerShell
Import-Module ActiveDirectory

#Attempt to perform the below steps against the provided $UserName
Try
{
	$Fullname = (Get-ADUser -Identity $UserName -Properties Name).Name
	$PasswordExpired = (Get-ADUser -Identity $UserName -Properties PasswordExpired).PasswordExpired
	$PasswordNeverExpires = (Get-ADUser -Identity $UserName -Properties PasswordNeverExpires).PasswordNeverExpires
	$PasswordLastSet = (Get-ADUser -Identity $UserName -Properties PasswordLastSet).PasswordLastSet
	$LockedOut = (Get-ADUser -Identity $UserName -Properties LockedOut).LockedOut
	$Enabled = (Get-ADUser -Identity $UserName -Properties Enabled).Enabled
	
	$RemainingDays = (Get-ADUser $UserName -properties "msDS-UserPasswordExpiryTimeComputed" | select-object @{Name = "RemainingDays" ; e={[datetime]::FromFileTime($_.'msDS-UserPasswordExpiryTimeComputed')}}).RemainingDays.ToString()
	$RemainingDays = $RemainingDays.Split(" ")[0]
	$Modified = (Get-ADUser -Identity $UserName -Properties Modified).Modified
	$Modified = $Modified.ToString().Split(" ")[0]
	$CalculateDays = (New-TimeSpan -Start $Modified -End $RemainingDays | Select Days).Days
	
	Write-Host "`n"
	Write-Host "User                 : $UserName"
	Write-Host "FullName             : $Fullname"	
	Write-Host "PasswordNeverExpires : $PasswordNeverExpires"
	Write-Host "PasswordLastSet      : $PasswordLastSet"
	Write-Host "LockedOut            : $LockedOut"
	Write-Host "Enabled              : $Enabled"
	Write-Host "RemainingDays        : $RemainingDays"
	Write-Host "PasswordExpiresIn    : $CalculateDays Days`n"
	
}


Catch
{
	Write-Host "`n"
	Write-Host "User provided does not exist!" -ForegroundColor Red
	Write-Host "`n"

}