#This ps1 is used to remove multiple users from QMC based on the condition. Useful especially when accidently sync unneccessry large amount of users/attributes into QMC. 
#Note, This only applies to the newly synchronized users meaning the user has not accessed Qlik Sense and created any app/objects yet. 

#Connect to Qlik Sense server

Connect-Qlik <QLIK SENSE SERVER LOCALHOST OR FQDN>

#Set the filter to fetch the users from QMC.  Firstly verify the filter and user amount to make sure it is correct result. Here 9999-xx-xx xx:xx:xx is the example

(Get-QlikUser -filter "createdDate gt '9999-03-20 10:48:00' " | measure).count

#Remove Qlik Sense User

(Get-QlikUser -filter "createdDate gt '9999-03-20 10:48:00' " -full).id | ForEach-Object { Remove-QlikUser -id $_ }
