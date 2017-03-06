#User Creation
#written by Chris Renshaw
#started on 1/17/2017
#TAGS User,Creation,AD
#UNIVERSAL

<#

Tasks to perform in this script:
Permissions to add (suggest to copy from another user from that OU?)

Once user is created ask if mailbox should be set up
- if so, set adhit with full access

Change New user form to ask for location and immediate supervisor

#>

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
    $UserLogonExt = "@arizonadigestivehealth.com"
    $UserLogonName = @()
    $Division = @()
    $SearchBase = @()
    $NewUserCompany = "Arizona Digestive Health"
    $HomePage = "www.arizonadigestivehealth.com"
    $SiteManagerUser = @()
    $SiteManagerName = @()
    $OfficePhone = @()
    $StreetAddress = @()
    $NewUserCity = @()
    $NewUserState = "AZ"
    $PostalCode = @()
    $NewUserCountry = "US"
    $CentPermGroup = @()
    $SecGroupsDiv = @()

    #End Clear Variables
    #endregion


    #Acquire Authentication
    #region
    if ($UserCredential -eq $NULL) {
            $UserCredential = Get-Credential
        }

    #End Acquire Authentication
    #endregion

    Write-Host "New User Creation for ADH.LOCAL" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please fill out the following questions carefully and be sure to check for" -ForegroundColor Yellow
    Write-Host "any errors including spelling. Be careful with this script." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Green
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
            Write-Host "Proceeding with this username - ADH\$ADUserName" -ForegroundColor Green
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
            Write-Host "Proceeding with this username instead - ADH\$ADUserName2" -ForegroundColor Green
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
    Write-Host "1) Division 10 Edwards"
    Write-Host "2) Division 11 Edwards"
    Write-Host "3) Division 20 Glendale"
    Write-Host "4) Division 29 19th Avenue"
    Write-Host "5) Division 30 East Mesa"
    Write-Host "6) Division 40 Coronado"
    Write-Host "7) Division 45 North Valley"
    Write-Host "8) Division 46 Bell Road"
    Write-Host "9) Division 50 Edwards"
    Write-Host "10) Division 60 Dobson"
    Write-Host "11) Division 61 Queen Creek"
    Write-Host "12) Division 70 Meline"
    Write-Host "13) Division 71 Shields"
    Write-Host "14) Division 72 Yalam"
    Write-Host "15) Division 73 Gelzeyd"
    Write-Host "16) Division 80 Gilbert"
    Write-Host "17) Division 81 Mesa Baseline"
    Write-Host "18) Division 90 Sun City"
    Write-Host "19) Division 91 Surprise"
    Write-Host "20) Division 92 Wickenburg"
    Write-Host "21) Division 93 Peoria"
    Write-Host "22) Corporate Office"
    Write-Host "23) Pathology Lab"
    Write-Host "24) Arizona Endo (AEC)"
    Write-Host "25) Desert Endo (DEC)"
    Write-Host "26) North Valley Endo (NVE)"
    Write-Host "27) Phoenix Endo (PEC)"
    Write-Host "28) Sun City Endo (SCE)"
    Write-Host "29) Scottsdale Endo (SEC)"
    Write-Host "30) Thunderbird Endo (TBE)"
    Write-Host ""

    #Division Selection Data
    switch ($SELECTION = Read-Host "Select on option") {
 
        1{
            $Division = "Division 10"
            $SearchBase = "OU=Division10,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "smedina"
            $OfficePhone = "602-254-6686"
            $StreetAddress = "1300 N. 12th St., Ste #603"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "ADHEmployees","Division10"
        }

        2{
            $Division = "Division 11"
            $SearchBase = "OU=Division11,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "dwithrow"
            $OfficePhone = "602-229-1900"
            $StreetAddress = "1300 N. 12th St., Ste #522"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "ADHEmployees","Division11"
        }

        3{
            $Division = "Division 20"
            $SearchBase = "OU=Division20,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "pmaldonado"
            $OfficePhone = "602-424-4050"
            $StreetAddress = "5823 W. Eugie Ave., Ste A"
            $NewUserCity = "Glendale"
            $PostalCode = "85304"
            $SecGroupsDiv = "ADHEmployees","Division20"
        }

        4{
            $Division = "Division 29"
            $SearchBase = "OU=Division20,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "pmaldonado"
            $OfficePhone = "623-972-2116"
            $StreetAddress = "9836 W. Yearling Rd., Ste #1300"
            $NewUserCity = "Peoria"
            $PostalCode = "85383"
            $SecGroupsDiv = "ADHEmployees","Division20"
        }

        5{
            $Division = "Division 30"
            $SearchBase = "OU=Division30,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "bharding"
            $OfficePhone = "480-985-1811"
            $StreetAddress = "6020 E. Arbor Ave., Ste #101"
            $NewUserCity = "Mesa"
            $PostalCode = "85304"
            $SecGroupsDiv = "ADHEmployees","Division30"
        }

        6{
            $Division = "Division 40"
            $SearchBase = "OU=Division40,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "llayer"
            $OfficePhone = "602-344-4141"
            $StreetAddress = "349 E. Coronado Rd."
            $NewUserCity = "Phoenix"
            $PostalCode = "85004"
            $SecGroupsDiv = "ADHEmployees","Division40","Division 40 Staff"
        }

        7{
            $Division = "Division 45"
            $SearchBase = "OU=Division45_46,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "klatham"
            $OfficePhone = "602-279-2064"
            $StreetAddress = "9250 N. 3rd St., Ste #2015"
            $NewUserCity = "AZ"
            $PostalCode = "85020"
            $SecGroupsDiv = "ADHEmployees","Division45","Division45 Group","NM Office (45)","Division 45 (NM Office)"
        }

        8{
            $Division = "Division 46"
            $SearchBase = "OU=Division45_46,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "klatham"
            $OfficePhone = "602-493-3030"
            $StreetAddress = "3815 E. Bell Rd., Ste 1250"
            $NewUserCity = "Phoenix"
            $PostalCode = "85032"
            $SecGroupsDiv = "ADHEmployees","Division45","Division45 Group","PV Office (46)","Division 46 (PV Office)"
        }

        9{
            $Division = "Division 50"
            $SearchBase = "OU=Division50,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "lwalker"
            $OfficePhone = "602-254-6366"
            $StreetAddress = "1300 N. 12th St., Ste #613"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "ADHEmployees","Division50"
        }

        10{
            $Division = "Division 60"
            $SearchBase = "OU=Division60,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "ahull"
            $OfficePhone = "480-461-1088"
            $StreetAddress = "1520 S. Dobson Rd., Ste #302"
            $NewUserCity = "Mesa"
            $PostalCode = "85202"
            $SecGroupsDiv = "ADHEmployees","Division60"
        }

        11{
            $Division = "Division 61"
            $SearchBase = "OU=Division60,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "ahull"
            $OfficePhone = "480-461-1088"
            $StreetAddress = "21321 E. Ocotillo Rd., Ste 114"
            $NewUserCity = "Queen Creek"
            $PostalCode = "85142"
            $SecGroupsDiv = "ADHEmployees","Division60"
        }

        12{
        #set other users to manager
            $Division = "Division 70"
            $SearchBase = "OU=Division70,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "sritter"
            $OfficePhone = "480-657-2992"
            $StreetAddress = "9767 N. 91st St., Ste #100"
            $NewUserCity = "Scottsdale"
            $PostalCode = "85258"
            $SecGroupsDiv = "ADHEmployees","Division70"
        }

        13{
            $Division = "Division 71"
            $SearchBase = "OU=Division71,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "bclemons"
            $OfficePhone = "480-767-3239"
            $StreetAddress = "10290 N. 92nd St., Ste #101"
            $NewUserCity = "Scottsdale"
            $PostalCode = "85258"
            $SecGroupsDiv = "ADHEmployees","Division71"
        }

        14{
            $Division = "Division 72"
            $SearchBase = "OU=Division72,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "mbulfair"
            $OfficePhone = "480-614-2219"
            $StreetAddress = "10290 N. 92nd St., Ste #204"
            $NewUserCity = "Scottsdale"
            $PostalCode = "85258"
            $SecGroupsDiv = "ADHEmployees","Division72"
        }

        15{
        #set other users to manager
            $Division = "Division 73"
            $SearchBase = "OU=Division73,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "jgelzeyd"
            $OfficePhone = "480-767-7297"
            $StreetAddress = "8415 N. Pima Rd., Ste #275"
            $NewUserCity = "Scottsdale"
            $PostalCode = "85258"
            $SecGroupsDiv = "ADHEmployees","Division73"
        }

        16{
            $Division = "Division 80"
            $SearchBase = "OU=Division80,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "mfandel"
            $OfficePhone = "480-926-2321"
            $StreetAddress = "201 W. Guadalupe St., Ste #209"
            $NewUserCity = "Gilbert"
            $PostalCode = "85233"
            $SecGroupsDiv = "ADHEmployees","Division80"
        }

        17{
            $Division = "Division 81"
            $SearchBase = "OU=Division81,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "asanchez"
            $OfficePhone = "480-545-6751"
            $StreetAddress = "3048 E. Baseline Rd., Ste #105"
            $NewUserCity = "Mesa"
            $PostalCode = "85204"
            $SecGroupsDiv = "ADHEmployees","Division81"
        }

        18{
            $Division = "Division 90"
            $SearchBase = "OU=Division90_91,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "wwinn"
            $OfficePhone = "623-972-2116"
            $StreetAddress = "13640 N. 99th Ave., Ste #600"
            $NewUserCity = "Sun City"
            $PostalCode = "85351"
            $SecGroupsDiv = "ADHEmployees","Division90","90Employees"
        }

        19{
            $Division = "Division 91"
            $SearchBase = "OU=Division90_91,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "wwinn"
            $OfficePhone = "623.584.1176"
            $StreetAddress = "14869 W. Bell Rd., Ste #100"
            $NewUserCity = "Surprise"
            $PostalCode = "85374"
            $SecGroupsDiv = "ADHEmployees","Division90","90Employees"
        }

        20{
            $Division = "Division 92"
            $SearchBase = "OU=Division90_91,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "wwinn"
            $OfficePhone = "928-668-1838"
            $StreetAddress = "520 Rose Lane, Suite B"
            $NewUserCity = "Wickenburg"
            $PostalCode = "85390"
            $SecGroupsDiv = "ADHEmployees","Division90","90Employees"
        }

        21{
            $Division = "Division 93"
            $SearchBase = "OU=Division90_91,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "wwinn"
            $OfficePhone = "623-972-2116"
            $StreetAddress = "9836 W. Yearling Rd., Ste 1300"
            $NewUserCity = "Peoria"
            $PostalCode = "85383"
            $SecGroupsDiv = "ADHEmployees","Division90","90Employees"
        }

        22{
            $Division = "Corporate Office"
            $SearchBase = "OU=Corporate,OU=ADH User Accounts,DC=adh,DC=local"
            $OfficePhone = "602-264-9100"
            $StreetAddress = "3020 E. Camelback Rd., Ste #301"
            $NewUserCity = "Phoenix"
            $PostalCode = "85016"
            $SecGroupsDiv = "ADHEmployees","Corporate"
            #HOMEFOLDER
            Write-Host ""
            Write-Host "Please select the user's manager" -ForegroundColor Green
            Write-Host "================================" -ForegroundColor Green 
            Write-Host "1) Nancy McManus"
            Write-Host "2) Danielle Withrow"
            Write-Host "3) Marlea Standley"
            Write-Host "4) Dan Swartz"

            switch ($ManagerSELECTION = Read-Host "Select on option") {
 
                1{
                    $SiteManagerUser = "nmcmanus"
                }
                2{
                    $SiteManagerUser = "dwithrow"
                }
                3{
                    $SiteManagerUser = "mstandley"
                    $SecGroupsDiv += "ADH - Unrestricted Terminal Server Access","Billing - ADH Billers","Billing - Central Billers","Corporate - Billing Team"
                }
                4{
                    $SiteManagerUser = "dswartz"
                    $SecGroupsDiv += "Accounts","ADH Interface Outages","Alerts","Helpdesk","IT Department","IT Emergency","Remote Desktop Users","Vendormail","ADH IT Outage"
                }
            }


        }

        23{
            $Division = "PathLab"
            $SearchBase = "OU=PathLab,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "klahti"
            $OfficePhone = "602-687-7468"
            $StreetAddress = "1300 N 12th St., Ste #300"
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
            $SecGroupsDiv = "ADHEmployees","PathLab"
        }

        24{
            $Division = "AEC"
            $SearchBase = "OU=AEC,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "mvelasquez"
            $OfficePhone = "602-716-9655"
            $StreetAddress = "1410 East McDowell Rd."
            $NewUserCity = "Phoenix"
            $PostalCode = "85006"
        }

        25{
            $Division = "DEC"
            $SearchBase = "OU=DEC,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "rellertson"
            $OfficePhone = "480-969-0405"
            $StreetAddress = "610 E. Baseline Rd."
            $NewUserCity = "Tempe"
            $PostalCode = "85283"
        }

        26{
            $Division = "NVE"
            $SearchBase = "OU=NVE,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "lmckellar"
            $OfficePhone = "602-482-1001"
            $StreetAddress = "15255 N. 40th St., Ste #8-157"
            $NewUserCity = "Phoenix"
            $PostalCode = "85032"
            $SecGroupsDiv = "NVE-Endo"
        }

        27{
            $Division = "PEC"
            $SearchBase = "OU=PEC,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "ehillebrand"
            $OfficePhone = "602-266-5678"
            $StreetAddress = "349 E. Coronado Avenue"
            $NewUserCity = "Phoenix"
            $PostalCode = "85004"
        }

        28{
            $Division = "SCEC"
            $SearchBase = "OU=SCEC,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "dzink"
            $OfficePhone = "623-972-5083"
            $StreetAddress = "13640 N. 99th Ave., Ste #700"
            $NewUserCity = "Sun City"
            $PostalCode = "85351"
        }

        29{
            $Division = "SEC"
            $SearchBase = "OU=SEC,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = ""
            $OfficePhone = "480-657-0889"
            $StreetAddress = "9787 N. 91st St., Ste #103"
            $NewUserCity = "Scottsdale"
            $PostalCode = "85258"
        }

        30{
            $Division = "TBE"
            $SearchBase = "OU=TBE,OU=Endoscopy Centers,OU=ADH User Accounts,DC=adh,DC=local"
            $SiteManagerUser = "mmangen"
            $OfficePhone = "602-439-1717"
            $StreetAddress = "5823 W. Eugie Ave., Ste B"
            $NewUserCity = "Glendale"
            $PostalCode = "85304"
        }

    }

    #End Acquire OU
    #endregion


    #Acquire Centricity Group
    #region
    #Create menu to choose the OU
    Write-Host ""
    Write-Host ""
    Write-Host "Please select the user's Centricity Permissions" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green 
    Write-Host "1) Centricity - ADH Admin"
    Write-Host "2) Centricity - Billing"
    Write-Host "3) Centricity - Billing plus EDI"
    Write-Host "4) Centricity - Corp Billing limited admin"
    Write-Host "5) Centricity - Div Admin"
    Write-Host "6) Centricity - Div Front Office I"
    Write-Host "7) Centricity - Div Front Office II (Carge & Copay)"
    Write-Host "8) Centricity - Div Schedule Admin"
    Write-Host "9) Centricity - Endo Staff"
    Write-Host "10) No Centricity Permissions"

    switch ($SELECTION = Read-Host "Select on option") {
 
        1{
            $CentPermGroup = "Centricity_ADH_Admin"
        }

        2{
            $CentPermGroup = "Centricity_Billing"
        }

        3{
            $CentPermGroup = "Centricity_Billing_plus_EDI"
        }

        4{
            $CentPermGroup = "Centricity_Corp_Billing_limited_admin"
        }

        5{
            $CentPermGroup = "Centricity_Div_Admin"
        }

        6{
            $CentPermGroup = "Centricity_Div_FrontOffice"
        }

        7{
            $CentPermGroup = "Centricity_Div_FrontOffice_plus_Carge&Copay"
        }

        8{
            $CentPermGroup = "Centricity_Div_Schedule_Admin"
        }

        9{
            $CentPermGroup = "Centricity_Endo_Staff"
        }

        10{
            Write-Host ""
            Write-Host "No Centricity permissions set. Proceeding." -ForegroundColor Yellow 
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
    $ReadSecGroups += $CentPermGroup 
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
    Write-Host "ADH\$ADUserName"
    Write-Host ""
    Write-Host "User's Logon Name" -ForegroundColor Yellow
    Write-Host "$UserLogonName"
    Write-Host ""
    Write-Host "User OU to create user" -ForegroundColor Yellow
    Write-Host "$SearchBase"
    Write-Host ""
    Write-Host "User's Division" -ForegroundColor Yellow
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
    $TotalSecGrp = $SecGroupsDiv+$CentPermGroup+$SecGrpAdd
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

    Set-ADAccountPassword $ADUserName -NewPassword (ConvertTo-SecureString -AsPlainText "Welcome2ADH" -Force)
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
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://adh-mail.adh.local/PowerShell/ -Authentication Kerberos -Credential $UserCredential
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
