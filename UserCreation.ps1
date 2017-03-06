<#
## User Creation ##############################################
written by Chris Renshaw
Created 3/6/2017

## Outline of script ##########################################

* Input First and Last Name of new user
    *checks AD for username in use and suggests next available

* chose their location and permissions
    *applies permissions and meta based on location selected

* displays selection prior to making changes
    *if no confirmation, script ends

* creates email if requested

#> #############################################################
#TAGS User,Creation,AD
#UNIVERSAL

Function UserCreation {

    clear

    #Clear and Set Variables
    #region
    $UserAcctCheck = @()
    $UserAcctError = @()
    $SecGrpAdd = @()
    $FName = @()
    $LName = @()
    $DisplayName = @()
    $ADUserName = @()
    $UserLogonExt = "@domainname.com"
    $DomainName = "domain.local"
    $UserLogonName = @()
    $Division = @()
    $SearchBase = @()
    $NewUserCompany = "YourCompanyName"
    $HomePage = "www.website.com"
    $SiteManagerUser = @()
    $SiteManagerName = @()
    $OfficePhone = @()
    $StreetAddress = @()
    $NewUserCity = @()
    $NewUserState = "AZ"
    $PostalCode = @()
    $NewUserCountry = "US"
    $EMRPermGroup = @()
    $SecGroupsDiv = @()
    $MailServer = "MailServerName as FQN (mail.domain.local, etc)"
    $PassTEMP = "Welcome2PoSH"

    #End Clear Variables
    #endregion


    #Acquire Authentication
    #region
    if ($UserCredential -eq $NULL) {
            $UserCredential = Get-Credential
        }

    #End Acquire Authentication
    #endregion

    Write-Host "New User Creation for Active Directory for $DomainName" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please fill out the following questions carefully and be sure to check for" -ForegroundColor Yellow
    Write-Host "any errors including spelling. Be careful with this script." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host ""

    #Establish and Acquire User Name
    #region

    $FName = Read-Host "First Name"
    $LName = Read-Host "Last Name"
    $DisplayName = $($FName+" "+$Lname)
    $ADUserName = $($FName.Substring(0,1)+$LName)

    #Check AD for availability
    Write-Host ""
    Write-Host "Checking AD for availability..." -ForegroundColor Yellow
    Write-Host ""
    try {
            $UserAcctCheck = Get-ADUser -Identity $ADUserName -ErrorAction Stop
        }
    catch {
            Write-Host "Proceeding with this username - $DomainName\$ADUserName" -ForegroundColor Green
        }

    if ($UserAcctCheck) {
        Write-Host "$ADUserName Username already exists" -ForegroundColor Red
        $ADUserName2 = @()
        $UserAcctCheck2 = @()
        $ADUserName2 = $($FName.Substring(0,2)+$LName)
        try {
            $UserAcctCheck2 = Get-ADUser -Identity $ADUserName2 -ErrorAction Stop
        }
        catch {
            Write-Host "Proceeding with this username instead - $DomainName\$ADUserName2" -ForegroundColor Green
            $ADUserName = $ADUserName2
        }
    
    }

    $UserLogonName = $($ADUserName+$UserLogonExt)

    #End Establish and Acquire User Name
    #endregion


    #Acquire OU 
    #region

    #Create menu to choose the OU
    Write-Host ""
    Write-Host ""
    Write-Host "Please select the user's location" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Green 
    Write-Host "1) Location Title 1"
    Write-Host "2) Location Title 2"
    Write-Host "3) Location Title 3"
    Write-Host ""

    #Division Selection Data
    switch ($SELECTION = Read-Host "Select on option") {
 
        1{
            $Division = "Location 1"
            $SearchBase = "(Division's Searchbase location)"
            $SiteManagerUser = "(username of manager to attach)"
            $OfficePhone = "602-555-1212"
            $StreetAddress = "123 Sesame Street"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "(Security Group)","(Distribution Group)"
        }

        2{
            $Division = "Location 2"
            $SearchBase = "(Division's Searchbase location)"
            $SiteManagerUser = "(username of manager to attach)"
            $OfficePhone = "602-555-1212"
            $StreetAddress = "123 Sesame Street"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "(Security Group 1)","(Security Group 2)","(Distribution Group 1)","(Distribution Group 2)","(Distribution Group 3)"
        }

 

        3{
            $Division = "Location 3"
            $SearchBase = "(Division's Searchbase location)"
            $SiteManagerUser = "(username of manager to attach)"
            $OfficePhone = "602-555-1212"
            $StreetAddress = "123 Sesame Street"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "(Security Group)","(Distribution Group)"
            Write-Host ""
            Write-Host "Please select the user's manager" -ForegroundColor Green
            Write-Host "================================" -ForegroundColor Green 
            Write-Host "1) George Lucas"
            Write-Host "2) Ada Lovelace"
            Write-Host "3) Ernest Cline"

            switch ($ManagerSELECTION = Read-Host "Select on option") {
 
                1{
                    $SiteManagerUser = "glucas"
                }
                2{
                    $SiteManagerUser = "alovelace"
                }
                3{
                    $SiteManagerUser = "ecline"
                    $SecGroupsDiv += "(Security Group 1)","(Security Group 2)","(Distribution Group 1)"
                }
            }


        }

    }

    #End Acquire OU
    #endregion


    #Acquire EMR Group - Assuming that your AD contains security groups for EMR access
    #region
    #Create menu to choose the OU
    Write-Host ""
    Write-Host ""
    Write-Host "Please select the user's EMR Permissions" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green 
    Write-Host "1) Value 1"
    Write-Host "2) Value 2"
    Write-Host "3) Value 3"
    Write-Host "4) No Permissions"

    switch ($SELECTION = Read-Host "Select on option") {
 
        1{
            $EMRPermGroup = "Value 1"
        }

        2{
            $EMRPermGroup = "Value 2"
        }

        3{
            $EMRPermGroup = "Value 3"
        }

        4{
            Write-Host ""
            Write-Host "No EMR permissions set. Proceeding." -ForegroundColor Yellow 
        }


    }

    #End Acquire Centricity Group
    #endregion


    #Email Inquiry
    #region
    Write-Host ""
    Write-Host "Will the user need an email address?" -ForegroundColor Yellow
    
    $EmailAnswer = Read-Host "Confirm"

    if ($EmailAnswer -eq "Y" -or $EmailAnswer -eq "Yes" -or $EmailAnswer -eq "y" -or $EmailAnswer -eq "yes" -or $EmailAnswer -eq "YES") {
        Write-Host "Email has been requested. It will be set as $UserLogonName." -ForegroundColor Yellow
        $EmailRequired = $TRUE
        Write-Host ""
    }

    else {
        Write-Host "No email will be created for this user at this time." -ForegroundColor Yellow
        $EmailRequired = $FALSE
        Write-Host ""
    }


    #End Email Inquiry
    #endregion


    #Select User Permissions
    #region
    Write-Host ""
    Write-Host "Setting Security Groups" -ForegroundColor Green
    Write-Host "=======================" -ForegroundColor Green
    Write-Host ""
    #Listing requested permissions
    Write-Host "Giving $DisplayName the following permission sets:" -ForegroundColor Green
    $ReadSecGroups = $SecGroupsDiv -split ","
    $ReadSecGroups += $EMRPermGroup 
    $ReadSecGroups
    Write-Host ""
    Write-Host "Is there any other groups that need to be added? (Y/N)" -ForegroundColor Green

    $AddlGroupsConfirm = @()
    $AddlGroupsConfirm = Read-Host "Confirm"

    if ($AddlGroupsConfirm -eq "Y" -or $AddlGroupsConfirm -eq "Yes" -or $AddlGroupsConfirm -eq "y" -or $AddlGroupsConfirm -eq "yes" -or $AddlGroupsConfirm -eq "YES") {
        $SecGrpAdd = @()

        Function SecGrpRequest {
            $AddlGrp2Add = @()
            Write-Host ""
            Write-Host "Please type the name of the security group that is needed." -ForegroundColor Green
            Write-Host ""

            $AddlGroupsRequested = Read-Host "Security Group Needed"
            $SecGrpChk = $NULL
            $SecGrpChk = (Get-ADGroup -Filter "name -like '*$AddlGroupsRequested*'").SamAccountName

            if ($SecGrpChk -eq $NULL) {
                Write-Host "No such group was found. Please add the additional group(s) manually." -ForegroundColor Red
            }

            else {
                Write-Host "Found the following options. Please choose one:" -ForegroundColor Green
                Write-Host ""
                $SecGrpMenu = @{}
                for ($i=1;$i -le $SecGrpChk.count; $i++) {
                    Write-Host "$i. $($SecGrpChk[$i-1])"
                    $SecGrpMenu.Add($i,($SecGrpChk[$i-1]))
                }
                [int]$SecGrpAns = Read-Host "Confirm"
                Write-Host ""
                $AddlGrp2Add = $SecGrpMenu.Item($SecGrpAns)

                $AddlGrp2Add
            }
    
        }

        $SecGrpAdd += SecGrpRequest

        $ContinuePerms = $NULL

        While ($ContinuePerms -eq $NULL) {
            Write-Host ""
            Write-Host "Would you like to add more Security Groups?" -ForegroundColor Green
            Write-Host ""
            $AddlGroupsConfirm2 = @()
            $AddlGroupsConfirm2 = Read-Host "Confirm"
            Write-Host ""

            if ($AddlGroupsConfirm2 -eq "Y" -or $AddlGroupsConfirm2 -eq "Yes" -or $AddlGroupsConfirm2 -eq "y" -or $AddlGroupsConfirm2 -eq "yes" -or $AddlGroupsConfirm2 -eq "YES") {
            $SecGrpAdd += SecGrpRequest
            }

            else {
            Write-Host ""
            Write-Host "You did not select any additional Security Groups." -ForegroundColor Green
            Write-Host "Proceeding with the following Security Groups:" -ForegroundColor Green
            Write-Host ""
            $SecGrpAdd
            $ContinuePerms = "1"
            }

        }

    }
    
    elseif ($AddlGroupsConfirm -eq "N" -or $AddlGroupsConfirm -eq "No" -or $AddlGroupsConfirm -eq "n" -or $AddlGroupsConfirm -eq "no" -or $AddlGroupsConfirm -eq "NO") {
    Write-Host ""
    Write-Host "Security Groups Added to selection. Proceeding." -ForegroundColor Green
    Write-Host ""

    }

    else {
        Write-Host ""
        Write-Host "You did not choose an applicable selection." -ForegroundColor Red
        Write-Host "You will need to manually apply the appropriate groups." -ForegroundColor Red
        Write-Host ""
    }

    #End Select User Permissions
    #endregion


    #Confirm Selection
    #region
    Write-Host "===============" -ForegroundColor Green
    Write-Host "Review of Setup" -ForegroundColor Green
    Write-Host "===============" -ForegroundColor Green
    Write-Host "You selected the following data. Please review carefully" -ForegroundColor Yellow
    Write-Host "and ensure the data is correct including spelled!" -ForegroundColor Yello
    Write-Host ""
    Write-Host "User's Name" -ForegroundColor Yellow
    Write-Host "$DisplayName"
    Write-Host ""
    Write-Host "User's UserName" -ForegroundColor Yellow
    Write-Host "$ADUserName"
    Write-Host ""
    Write-Host "User's Logon Name" -ForegroundColor Yellow
    Write-Host "$UserLogonName"
    Write-Host ""
    Write-Host "User OU to create user" -ForegroundColor Yellow
    Write-Host "$SearchBase"
    Write-Host ""
    Write-Host "User's Location" -ForegroundColor Yellow
    Write-Host "$Division"
    Write-Host ""
    Write-Host "User's Manager" -ForegroundColor Yellow
    $SiteManagerName = $(Get-ADUser $SiteManagerUser).Name
    Write-Host "$SiteManagerName"
    Write-Host ""
    Write-Host "User's Location" -ForegroundColor Yellow
    Write-Host "$StreetAddress"
    Write-Host "$NewUserCity, $NewUserState $PostalCode"
    Write-Host "$NewUserCountry"
    Write-Host ""
    Write-Host "User's Phone" -ForegroundColor Yellow
    Write-Host "$OfficePhone"
    $TotalSecGrp = $SecGroupsDiv+$EMRPermGroup+$SecGrpAdd
    Write-Host ""
    Write-Host "User's Email" -ForegroundColor Yellow
    if ($EmailRequired -eq $TRUE) {
        Write-Host "$UserLogonName"
    }
    else {
        Write-Host "None Requested" 
    }
    Write-Host ""
    Write-Host "User's Security Groups" -ForegroundColor Yellow
    $TotalSecGrp

    #Verify Correctness
    Write-Host ""
    Write-Host "Is the above listed information correct? (Y/N)"  -ForegroundColor Green
    Write-Host "Please note that if it is not, this script terminates."  -ForegroundColor Red
    $SelectionConfirmation = @()
    $SelectionConfirmation = Read-Host "Confirm"

    if ($SelectionConfirmation -eq "Y" -or $SelectionConfirmation -eq "Yes") {
        Write-Host ""
        Write-Host "You confirmed the above information is correct - proceeding to create and enable AD User." -ForegroundColor Green
        Write-Host ""
    }
    
    else {
        Write-Host ""
        Write-Host "You confirmed the above information is not correct - terminating script." -ForegroundColor Red
        break
    }

    #End Confirm Selection
    #endregion


    #Create User Account
    #region

    New-ADUser -Name $DisplayName -Path $SearchBase -GivenName $FName `
    -Surname $LName -SamAccountName $ADUserName -DisplayName $DisplayName `
    -UserPrincipalName $UserLogonName -City $NewUserCity -Company $NewUserCompany `
    -Department $Division -Manager $SiteManagerUser -Office $Division `
    -PostalCode $PostalCode -State $NewUserState -StreetAddress $StreetAddress `
    -HomePage $HomePage -Country $NewUserCountry -OfficePhone $OfficePhone 

    $CheckUserCreated = $NULL
    while ($CheckUserCreated -eq $NULL) {
    Write-Host ""
    Write-Host "Creating User, Please wait..." -ForegroundColor Yellow
    $CheckUserCreated = Get-ADUser $ADUserName 
    Start-Sleep -s 5
    Write-Host ""
    }

    Set-ADAccountPassword $ADUserName -NewPassword (ConvertTo-SecureString -AsPlainText "$PassTEMP" -Force)
    Enable-ADAccount $ADUserName
    Set-ADUser -Identity $ADUserName -ChangePasswordAtLogon $true

    Write-Host ""
    Write-Host "$($CheckUserCreated.Name) has been created. Proceeding with next steps." -ForegroundColor Green
    Write-Host ""

    #End Create User Name
    #endregion


    #Create User Email
    #region

    if ($EmailRequired -eq $TRUE) {
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$MailServer/PowerShell/ -Authentication Kerberos -Credential $UserCredential
        Import-PSSession $Session

        Enable-Mailbox -Identity $ADUserName
        #Set ADHIT w Full Access

        #Test mailbox
        $CheckMailboxCreated = $NULL
        while ($CheckMailboxCreated -eq $NULL) {
            Write-Host ""
            Write-Host "Checking Mailbox, Please wait..." -ForegroundColor Yellow
            $CheckMailboxCreated = Get-Mailbox -Identity $ADUserName 
            Start-Sleep -s 5
            Write-Host ""
            Write-Host "User's Mailbox Created Successfully" -ForegroundColor Green
            Write-Host ""
        }

        Remove-PSSession $Session
    
    }

    else {
        Write-Host ""
        Write-Host "Skipping E-Mail setup." -ForegroundColor Yellow
        Write-Host ""
    }
    #End Create User Email
    #endregion


    #Create User Permissions
    #region

    $TotalSecGrp | Add-ADGroupMember -Members $ADUserName
    Write-Host "User Security Groups Applied." -ForegroundColor Green


    #End Create User Permissions
    #endregion

    Write-Host ""
    Write-Host ""
    Write-Host "====================================================================" -ForegroundColor Green
    Write-Host "Script has Completed. User Successfully Created for $DisplayName." -ForegroundColor Green
    Write-Host "====================================================================" -ForegroundColor Green


}
