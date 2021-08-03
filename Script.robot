***Settings***
Resource       ${CURDIR}/Functions/LibraryImport.robot
Resource       ${CURDIR}/Functions/CommonKeywords.robot
Resource       ${CURDIR}/Functions/EventLogger.robot
Resource       ${CURDIR}/Functions/GetFromWongnai.robot
Resource       ${CURDIR}/Functions/LineCaller.robot
Resource       ${CURDIR}/Functions/ToTheCloud.robot
Resource       ${CURDIR}/Config.robot

***Variables***
#Config Variable
${ATTEMPT}             30 x
${WAIT}                1 sec
${SCREENSHOT_DIR}      ${CURDIR}\\AutoScreenshot
${GOLBAL_SLEEP}        1 sec
${GCP_BUILD_LINK}      https\://console.cloud.google.com/cloud-build/builds/${BUILD_ID}?project\=${PROJECT_ID}
${GOLBAL_TIMEOUT}      1 min

${EXPIRED_ORDER}       14 days
${REDEEM_USED_EXPIRED}  14 days
${REDEEM_DELETE_DATE}  7 days
############################################################################################################################################
***Keywords***
############################################################################################################################################
# Setup and Teardown Function
############################################################################################################################################
Script Setup
    [Arguments]  ${is_date}=False

    ${start_time}  Get Time
    log to console    ${\n}Start time: ${start_time}
    Set Date For FireStore  ${is_date}
    Run Keyword If  ${IS_LOCAL}  Import Variables  ${CURDIR}/Config-local.yaml
    SeleniumLibrary.Set Selenium Speed    0.001
    Open Wongnai POS WEB on Headless and Maximize Window
    Maximize Browser Window
    Login to Firebear Sothorn POS

End Script

    Run Keyword If Test Failed    Do This When Script Failed
    Close All Browsers

Do This When Script Failed
    ${TEST MESSAGE}  Remove String  ${TEST MESSAGE}  \n
    ${TEST MESSAGE}  Set Variable  ${TEST MESSAGE} Link: ${GCP_BUILD_LINK}

    # LineCaller.Sent Alert To Line By ID  message=The \[${TEST NAME}\] was Failed, with error \(${TEST MESSAGE}\)

############################################################################################################################################

Login to Firebear Sothorn POS
    Input Text  ${LOG_user}  ${_POS_USER}  clear=true  
    Input Text  ${LOG_pass}  ${_POS_PASS}  clear=true
    Click Element  ${LOG_submit_btn}
    BuiltIn.Wait Until Keyword Succeeds  5 x  1 sec    Check Should Be On Home Page
    Log To Console  ${\n}Login to Wongnai

Open Wongnai POS WEB on Headless and Maximize Window
    Open Browser Headless   url=${POS_WONGNAI_URL}
    Run Keyword If  ${IS_LOCAL}  Open Browser  url=${POS_WONGNAI_URL}  browser=chrome
    Log To Console  ${\n}Browser is open
    Maximize Browser Window

Open Browser Headless
    [Arguments]  ${url}
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${is_headless}  Set Variable  True
    IF  ${is_headless}
        BuiltIn.Call Method    ${chrome options}    add_argument    test-type
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-extensions
        BuiltIn.Call Method    ${chrome options}    add_argument    --headless
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-gpu
        BuiltIn.Call Method    ${chrome options}    add_argument    --no-sandbox
        BuiltIn.Call Method    ${chrome options}    add_argument    start-maximized
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
    END
    Create Webdriver    Chrome    chrome_options=${chrome options}
    Goto    ${url}

Clean Download Directory
    Empty Directory  ${DOWNLOAD_DIR}

Set Date For FireStore
    [Documentation]  Date format  30-12-2021
    [Arguments]  ${expect_date}=False

    IF  '${expect_date}'=='False'

        ${cur_date}=   Get Current Date  UTC  + 7 hour  result_format=%d-%m-%Y
        Set Test Variable  ${FS_DATE}  ${cur_date}

    ELSE

        Set Test Variable  ${FS_DATE}  ${expect_date}

    END

    Log to console  ${\n}Set FS_DATE to: ${FS_DATE}

Get Only Not Exist Bill Dict
    [Arguments]  ${non_exist_list}  ${bill_dict}
    ${update_list}  Create List

    FOR  ${KEY}  IN  @{non_exist_list}
        ${value}  Get From Dictionary  ${bill_dict}  ${KEY}
        Append To List  ${update_list}  ${value}
    END

    [Return]  ${update_list}

############################################################################################################################################
***Test Cases***
############################################################################################################################################
Get All Bills from POS wongnai and update to Firestore cloud
    [Tags]    Update-Delivery
    [Setup]  Script Setup

    Set Test Variable    ${TEST NAME}    Update Bill To Firestore
    Go To Daily Billing Page
    Set Date To Expect Date and Validate Data Date Should be Expecte Date
    Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    Set Test Variable  ${PREV_LENGTH}  0
    SeleniumLibrary.Set Selenium Speed    0

    Sleep  ${GOLBAL_SLEEP}
    ${bill_dict}  ${bill_list}=  Get New Order Detail  ${PREV_LENGTH}
    ${is_up_to_date}  ${non_exist_list}  ToTheCloud.Bill list should exist for today  ${bill_list}

    IF  ${is_up_to_date}

        log to console  ${\n}Every bill is updated.
        # LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated.

    ELSE

        log to console  ${\n}non_exist_list:${\n}${non_exist_list}
        ${update_list}  Get Only Not Exist Bill Dict  ${non_exist_list}  ${bill_dict}
        log to console  ${\n}result: ${update_list}
        ToTheCloud.Update Bill Document to FireStore  ${update_list}

    END

    [Teardown]  End Script

Update bill to firestore
    [Documentation]    This script goto poswognai and check not exist bill then update them to Firestore
    [Tags]    Daily-update-bill
    [Setup]  Script Setup  ${INPUT_DATE}

    Set Test Variable    ${TEST NAME}    Update bill for ${FS_DATE}
    log to console    ${\n}${TEST NAME}
    Go To Daily Billing Page
    Set Date To Expect Date and Validate Data Date Should be Expecte Date
    Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    SeleniumLibrary.Set Selenium Speed    0

    ${bill_dict}  ${bill_list}=  Get New Order Detail
    ${is_up_to_date}  ${non_exist_list}  ToTheCloud.Bill list should exist for today  ${bill_list}

    IF  ${is_up_to_date}

        log to console  ${\n}Every bill is updated.
        # LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated.

    ELSE

        log to console  ${\n}non_exist_list:${\n}${non_exist_list}
        ${update_list}  Get Only Not Exist Bill Dict  ${non_exist_list}  ${bill_dict}
        log to console  ${\n}Not exist bill detail list: ${update_list}
        ToTheCloud.Update Bill Document to FireStore  ${update_list}

    END

    [Teardown]  End Script

Delete every document that older
    [Tags]    Clear-Old-Document
    #Get the date older than today for 7 days
    Set Date For FireStore
    Set Test Variable  ${DATA_DATE}  ${FS_DATE}
    ${cur_date}  Get Current Date  UTC  + 7 hours - ${EXPIRED_ORDER}  result_format=%d-%m-%Y

    log to console    ${\n}Delete Document Where older Than ${cur_date}
    ToTheCloud.Delete Document Where older Than '${cur_date}'
  
Clear Redeem History
    [Tags]    Clear-Redeem-History
    
    Set Date For FireStore
    Set Test Variable  ${DATA_DATE}  ${FS_DATE}
    ${expire_due_date}  Get Current Date  UTC  + 7 hours  result_format=%d-%m-%Y
    ${used_due_date}  Get Current Date  UTC  + 7 hours - ${REDEEM_USED_EXPIRED}  result_format=%d-%m-%Y
    ${delete_date}  Get Current Date  UTC  + 7 hours + ${REDEEM_DELETE_DATE}  result_format=%d-%m-%Y
    log to console  ${\n}expire_date:${expire_due_date} used_due_date:${used_due_date}
    
    Delete used and expired RedeemhHistory  ${used_due_date}  ${expire_due_date}

Test docker
    [Tags]    docker
    [Setup]
    log to console    ${\n}Success
    [Teardown]

New Logic
    [Documentation]    This script goto poswognai and check not exist bill then update them to Firestore
    [Tags]    new-logic
    [Setup]  Script Setup  ${INPUT_DATE}

    Set Test Variable    ${TEST NAME}    [new-logic]Update bill for ${FS_DATE}
    log to console    ${\n}${TEST NAME}
    Go To Daily Billing Page
    Set Date To Expect Date and Validate Data Date Should be Expecte Date
    Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    SeleniumLibrary.Set Selenium Speed    0

    ${cur_bill_list}  Get All Current Bill Exclude Counter
    log to console  ${\n}cur_bill_list:${\n}${cur_bill_list}
    ${is_up_to_date}  ${non_exist_list}  Bill list should exist for today  ${cur_bill_list}
    log to console  ${\n}non_exist_list:${\n}${non_exist_list}
    

    IF  ${is_up_to_date}

        log to console  ${\n}Every bill is updated.
        # Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated.

    ELSE

        ${bill_info}  Get New Order Detail From Bill List  ${cur_bill_list}
        log to console  ${\n}bill_info:${\n}${bill_info}
        Update Bill Document to FireStore  ${bill_info}

    END

    [Teardown]  End Script
