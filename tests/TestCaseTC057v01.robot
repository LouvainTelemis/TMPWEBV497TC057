*** Settings ***

Library    RequestsLibrary
Library    Collections
Library    OperatingSystem
Library    SeleniumLibrary
Library    DateTime
Library    BuiltIn



*** Variables ***

${MyRepositoryName}    TMPWEBV497TC341
# You must create the folder "MyFolderWorkspace" manually in the computer of Jenkins master, in case you test the script with the computer of Jenkins master
${MyFolderWorkspace}    C:/000/jenkins/workspace

${MyHostname}    demo5757
${MyPortNumber}    10000
#  Do not use the brackets to define the variable of bearer token
${bearerToken}    Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJJbnN0YWxsZXIiLCJuYW1lIjoiSW5zdGFsbGVyIiwiaXNzIjoiVGVsZW1pcyIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjoxODYxOTIwMDAwfQ.pynnZ69Qx50wuz0Gh4lx-FHZznrcQkbMm0o-PLhb3S0

${MyBrowser1}    chrome
${MyBrowser2}    firefox
${MyBrowser3}    edge

${TmpWebAdministratorLogin}    telemis_webadmin
${TmpWebAdministratorPassword}    KEYCLOAKTastouk!

${TmpWebAnthonyLogin}    anthony
${TmpWebAnthonyPassword}    Videogames2024

# NOT USEFUL ${MyFolderResults}    results
${MyLogFile}    MyLogFile.log
${MyFolderCertificate}    security
${MyDicomPath}    C:/VER497TMP1/telemis/dicom

${MyEntityName1}    audit
${MyEntityPort1}    9940
${MyEntityName2}    dicomgate
${MyEntityPort2}    9920
${MyEntityName3}    hl7gate
${MyEntityPort3}    9930
${MyEntityName4}    patient
${MyEntityPort4}    9990
${MyEntityName5}    registry
${MyEntityPort5}    9960
${MyEntityName6}    repository
${MyEntityPort6}    9970
${MyEntityName7}    user
${MyEntityPort7}    9950
${MyEntityName8}    worklist
${MyEntityPort8}    9980

${VersionSiteManager}    4.1.2-228



*** Keywords ***

Remove The Previous Results
    [Documentation]    Delete the previous results and log files
    # Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/geckodriver*
    # Delete the previous screenshots
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/*.png
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/${MyLogFile}
    ${Time} =    Get Current Date
    Create file  ${MyFolderWorkspace}/${MyRepositoryName}/results/${MyLogFile}    ${Time}${SPACE}Start the tests \n
    # Remove DICOM files from dicomPath of TMAA
    Remove Files    ${MyDicomPath}/*.dcm


Check That Watchdog Is Running
    [Documentation]    Check that Watchdog is running
    create session    mysession    https://${MyHostname}:${MyPortNumber}/watchdog/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Watchdog
    [Documentation]    Check the version number of Watchdog
    create session    mysession    https://${MyHostname}:${MyPortNumber}/watchdog/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Watchdog ${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s
    # Should Contain    ${response.text}    ${VersionSiteManager}


Check That Site Manager Is Running
    [Documentation]    Check that Site Manager is running
    create session    mysession    https://${MyHostname}:${MyPortNumber}/site/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Site Manager
    [Documentation]    Check the version number of Site Manager
    create session    mysession    https://${MyHostname}:${MyPortNumber}/site/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Site Manager ${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

    ${response} =    GET On Session    mysession    /identity    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    sitemanager
    Sleep    3s


Check That Telemis Entity Is Running
    [Documentation]    Check that Telemis Entity is running
    [Arguments]    ${MyEntityPort}
    create session    mysession    https://${MyHostname}:${MyEntityPort}/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /ping    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    3s


Check Version Of Telemis Entity
    [Documentation]    Check the version number of entity
    [Arguments]    ${MyEntityName}    ${MyEntityPort}
    create session    mysession    https://${MyHostname}:${MyEntityPort}/api/admin

    ${headers}    create dictionary    Authorization=${bearerToken}

    ${response} =    GET On Session    mysession    /version    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    ${Time} =    Get Current Date
    Append To File    ${MyLogFile}    ${Time}${SPACE}Version number of Telemis-${MyEntityName}${SPACE}${response.text} \n

    Should Be Equal As Strings    ${response.status_code}    200
    Sleep    2s

    ${response} =    GET On Session    mysession    /identity    headers=${headers}    verify=${MyFolderWorkspace}/${MyRepositoryName}/tests/${MyFolderCertificate}/telemis_ca.cer
    log    ${response.status_code}
    log    ${response.content}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    ${MyEntityName}
    Sleep    3s


Take My Screenshot
    ${MyCurrentDateTime} =    Get Current Date    result_format=%Y%m%d%H%M%S
    Log    ${MyCurrentDateTime}
    # Keyword of SeleniumLibrary, you do not need to use the library Screenshot
    Capture Page Screenshot    selenium-screenshot-${MyCurrentDateTime}.png
    Sleep    2s


Open My Site Manager
    Open Browser    https://${MyHostname}:10000/site    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Wait Until Element Is Visible    id=kc-login    timeout=15s
    Maximize Browser Window
    Sleep    2s
    Input Text    id=username    local_admin    clear=True
    Input Text    id=password    KEYCLOAKTastouk!    clear=True
    Sleep    2s
    Click Button    id=kc-login
    # Locator of Selenium IDE
    Wait Until Element Is Visible    xpath=//strong[contains(.,'Site Manager')]    timeout=15s
    Element Should Be Visible    xpath=//strong[contains(.,'Site Manager')]
    Sleep    2s


Log Out My User Session Of Site Manager
    Click Link    link:Sign out
    Wait Until Element Is Visible    id=kc-login    timeout=15s
    Element Should Be Visible    id=kc-login
    Sleep    2s


My User Opens Internet Browser And Connects To My TMP Web
    [Documentation]    The user opens Internet browser and then connects to the website of TMP Web
    [Arguments]    ${MyUserLogin}    ${MyUserPassword}
    Open Browser    https://${MyHostname}.telemiscloud.com/tmpweb/patients.app    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Wait Until Page Contains    TM-Publisher web    timeout=15s
    Maximize Browser Window
    Wait Until Element Is Visible    id=username    timeout=15s
    Wait Until Element Is Visible    id=password    timeout=15s
    Input Text    id=username    ${MyUserLogin}    clear=True
    Input Text    id=password    ${MyUserPassword}    clear=True
    Sleep    2s
    Click Button    id=kc-login
    Wait Until Page Contains    Telemis Media Publisher Web    timeout=15s
    Sleep    3s


Log Out My User Session Of TMP Web
    Click Link    link=Logout
    Wait Until Element Is Visible    xpath=//*[@id="doctor-button"]    timeout=15s
    Sleep    2s



*** Test Cases ***

Test01
    [Documentation]    Reset the test results
    [Tags]    TC001
    Remove Files    ${MyFolderWorkspace}/${MyRepositoryName}/results/*.png


Test02
    [Documentation]    Open URL with Chrome
    [Tags]    TC002
    Open Browser    https://${MyHostname}.telemiscloud.com/tmpweb/patients.app    Chrome    options=add_argument("--disable-infobars");add_argument("--lang\=en");binary_location=r"C:\\000\\chromeWin64ForTests\\chrome.exe"
    Wait Until Page Contains    TM-Publisher web    timeout=15s
    Wait Until Element Is Visible    id=kc-current-locale-link    timeout=15s
    Wait Until Element Is Visible    id=kc-registration    timeout=15s
    Maximize Browser Window


Test03
    [Documentation]    Select the language
    [Tags]    TC003
    ${c} =    Get Element Count    id=kc-current-locale-link
    Run Keyword If    ${c}>0    Click Element    id=kc-current-locale-link
    Sleep    2s
    # The keyword Select From List By Index/Label/Value does not work with the combo box of this web page
    Wait Until Element Is Visible    link=English    timeout=9s
    Element Should Be Visible    link=English
    Sleep    1s
    Click Element    link=English
    Mouse Over    id=kc-login


Test04
    [Documentation]    Click the link Sign up
    [Tags]    TC004
    Element Should Be Visible    id=kc-registration
    Click Element    id=kc-registration
    Wait Until Page Contains    Medical number    timeout=15s
    Sleep    2s


Test05
    [Documentation]    Fill out the form of Sign up
    [Tags]    TC005
    Wait Until Element Is Visible    id=username    timeout=15s
    Wait Until Page Contains    Login    timeout=15s
    Input Text    id=username    anthony    clear=True
    Sleep    1s
    Textfield Value Should Be    id=username    anthony

    Wait Until Element Is Visible    id=firstName    timeout=15s
    Wait Until Page Contains    First name    timeout=15s
    Input Text    id=firstName    Anthony    clear=True
    Sleep    1s
    Textfield Value Should Be    id=firstName    Anthony

    Wait Until Element Is Visible    id=lastName    timeout=15s
    Wait Until Page Contains    Last name    timeout=15s
    Input Text    id=lastName    Smith    clear=True
    Sleep    1s
    Textfield Value Should Be    id=lastName    Smith

    Wait Until Element Is Visible    id=password    timeout=15s
    Wait Until Page Contains    Password    timeout=15s
    Input Text    id=password    Videogames2024    clear=True
    Sleep    1s
    Textfield Value Should Be    id=password    Videogames2024

    Wait Until Element Is Visible    id=password-confirm    timeout=15s
    Wait Until Page Contains    Confirm password    timeout=15s
    Input Text    id=password-confirm    Videogames2024    clear=True
    Sleep    1s
    Textfield Value Should Be    id=password-confirm    Videogames2024

    Wait Until Element Is Visible    id=email    timeout=15s
    Wait Until Page Contains    Email    timeout=15s
    Input Text    id=email    anthony@hospital8.com    clear=True
    Sleep    1s
    Textfield Value Should Be    id=email    anthony@hospital8.com

    Wait Until Element Is Visible    id=user.attributes.phone    timeout=15s
    Wait Until Page Contains    Phone    timeout=15s
    Input Text    id=user.attributes.phone    020123456    clear=True
    Sleep    1s
    Textfield Value Should Be    id=user.attributes.phone    020123456

    Wait Until Element Is Visible    id=user.attributes.phone.professional    timeout=15s
    Wait Until Page Contains    Professionnal phone    timeout=15s
    Input Text    id=user.attributes.phone.professional    020456789    clear=True
    Sleep    1s
    Textfield Value Should Be    id=user.attributes.phone.professional    020456789

    Wait Until Element Is Visible    id=user.attributes.phone.mobile    timeout=15s
    Wait Until Page Contains    Mobile phone    timeout=15s
    Input Text    id=user.attributes.phone.mobile    0477123456    clear=True
    Sleep    1s
    Textfield Value Should Be    id=user.attributes.phone.mobile    0477123456

    Wait Until Element Is Visible    id=user.attributes.address    timeout=15s
    Wait Until Page Contains    Address    timeout=15s
    Input Text    id=user.attributes.address    4 rue Athena 1348 Louvain    clear=True
    Sleep    1s
    Textfield Value Should Be    id=user.attributes.address    4 rue Athena 1348 Louvain

    Wait Until Element Is Visible    id=user.attributes.medical.number    timeout=15s
    Wait Until Page Contains    Medical number    timeout=15s
    Sleep    1s

    Take My Screenshot


Test06
    [Documentation]    Click the button SIGN UP
    [Tags]    TC006
    Click element    id=logo
    Press Keys    None    PAGE_DOWN
    Sleep    2s
    Wait Until Element Is Visible    css=.button    timeout=15s
    Page Should Contain Button    css=.button    timeout=15s
    Click Button    css=.button
    # The application can not open the next page, the bug has not been solved yet
    Wait Until Page Contains    502 Bad Gateway    timeout=15s
    Sleep    2s
    # Quit the error page
    Go To    https://${MyHostname}:8444/auth/
    Wait Until Page Contains    Centrally manage all aspects of the Keycloak server    timeout=15s
    Sleep    1s
    # Log out the current user session. If not, the administrator can not connect to TMP Web.
    Go To    https://${MyHostname}.telemiscloud.com/tmpweb/logout
    Wait Until Page Contains    TM-Publisher web    timeout=15s
    Wait Until Element Is Visible    xpath=//*[@id="doctor-button"]    timeout=15s
    Sleep    2s
    Close All Browsers
    Sleep    2s


Test07
    [Documentation]    Administrator connects to the website of TMP Web
    [Tags]    TC007
    My User Opens Internet Browser And Connects To My TMP Web    ${TmpWebAdministratorLogin}    ${TmpWebAdministratorPassword}


Test08
    [Documentation]    Administrator checks and validate the new user account
    [Tags]    TC008
    # You have to synchronize two servers (TMP Web and Keycloak) before accessing the list of user accounts. If not, you get the error message (500 Internal Server Error), the bug has not been fixed yet
    Go To    https://${MyHostname}.telemiscloud.com/tmpweb/keycloak_synchro.app
    Wait Until Page Contains    Keycloak synchronization    timeout=15s
    Sleep    3s
    Click Element    link=Back
    Wait Until Page Contains    Manage users    timeout=15s
    Sleep    2s
    Page Should Contain Link    link=anthony    None    TRACE
    Take My Screenshot
    Click Link    link=anthony
    Wait Until Page Contains    Personal details    timeout=15s
    Wait Until Page Contains    Delete user    timeout=15s
    Sleep    3s
    Take My Screenshot
    Close All Browsers


Test09
    [Documentation]    The limited user account connects to the website for the very first time
    [Tags]    TC009
    My User Opens Internet Browser And Connects To My TMP Web    ${TmpWebAnthonyLogin}    ${TmpWebAnthonyPassword}


Test10
    [Documentation]    The first warning message appears automatically in the first connection of the user account, it requests the user to enter the medical number
    [Tags]    TC010
    Wait Until Page Contains     You must enter your personal unique medical number    timeout=15s
    Wait Until Element Is Visible    id=med-number    timeout=15s
    Wait Until Element Is Visible    css=.form-button    timeout=15s
    Take My Screenshot


Test11
    [Documentation]    The second warning message (Required field) appears automatically below the input box Medical Number after clicking the button Submit without entering the medical number
    [Tags]    TC011
    Click Button    css=.form-button
    Wait Until Page Contains    Required field    timeout=15s
    Take My Screenshot


Test12
    [Documentation]    The third warning message (Medical number already exists) appears automatically below the input box Medical Number after entering a pre-existing medical number
    [Tags]    TC012
    Input Text    id=med-number    12341001    clear=True
    Sleep    1s
    Textfield Value Should Be    id=med-number    12341001
    Click Button    css=.form-button
    Wait Until Page Contains    Medical number already exists    timeout=15s
    Take My Screenshot


Test13
    [Documentation]    The limited user account enters the valid medical number
    [Tags]    TC013
    Input Text    id=med-number    12341002    clear=True
    Sleep    1s
    Textfield Value Should Be    id=med-number    12341002
    Take My Screenshot
    Click Button    css=.form-button
    Wait Until Page Contains    My Patients    timeout=15s
    Take My Screenshot


Test14
    [Documentation]    The limited user account accesses the website of TMP Web
    [Tags]    TC014
    Page Should Contain Link    link=Settings    None    TRACE
    Click Link    link=Settings
    Sleep    3s
    Wait Until Page Contains    Personal details    timeout=15s
    Sleep    2s
    Take My Screenshot
    Log Out My User Session Of TMP Web
    Close All Browsers
    Sleep    1s


Test15
    [Documentation]    Administrator deletes the user account
    [Tags]    TC015
    My User Opens Internet Browser And Connects To My TMP Web    ${TmpWebAdministratorLogin}    ${TmpWebAdministratorPassword}
    Wait Until Page Contains    Admin    timeout=15s
    Click Link    link=Admin
    Sleep    3s
    Wait Until Page Contains    Manage users    timeout=15s
    Sleep    3s
    Page Should Contain Link    link=anthony    None    TRACE
    Click Link    link=anthony
    Wait Until Page Contains    Personal details    timeout=15s
    Wait Until Page Contains    Delete user    timeout=15s
    Sleep    4s
    Click Element    link=Delete user
    # Do NOT use both keyword (Handle Alert) and (Alert Should Be Present) together because the keyword (Alert Should Be Present) accepts the message automatically
    ${message} =    Handle Alert    action=ACCEPT    timeout=15s
    Sleep    3s
    Take My Screenshot
    # Synchronize two servers (TMP Web and Keycloak) to make sure that the user account does not exist anymore for the next tests
    Go To    https://${MyHostname}.telemiscloud.com/tmpweb/keycloak_synchro.app
    Sleep    2s
    Log Out My User Session Of TMP Web


Test16
    [Documentation]    Shut down the browser and reset the cache
    [Tags]    TC016
    # Close All Browsers
    Sleep    1s
