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
${ATTEMPT}              30 x
${WAIT}                 1 sec
${Global_SLEEP}         1 sec
# ${GCP_BUILD_LINK}      https\://console.cloud.google.com/cloud-build/builds/${BUILD_ID}?project\=${PROJECT_ID}
${Global_TIMEOUT}        1 min
${ELEMENT_TIMEOUT}       10 sec

${EXPIRED_ORDER}         7 days
${REDEEM_USED_EXPIRED}   7 days
${REDEEM_DELETE_DATE}    7 days
############################################################################################################################################
***Keywords***
############################################################################################################################################
# Setup and Teardown Function
############################################################################################################################################
Script Setup
    [Arguments]  ${is_date}=False
    
    IF  ${IS_LOCAL}
        # Get value from local config file
        Import Variables  ${CURDIR}/Config-local.yaml
    ELSE
        # Get value from OS and set if normal or BO trigger
        Set up initial value from OS variable
    END
    
    Set Date For FireStore  ${is_date}
    SeleniumLibrary.Set Selenium Speed    0.01
    Open Wongnai POS WEB on Headless and Maximize Window

Set up initial value from OS variable
    ${_POS_USER}        Get Environment Variable    _POS_USER
    ${_POS_PASS}        Get Environment Variable    _POS_PASS
    ${_FLUKE_UID}       Get Environment Variable    _FLUKE_UID
    ${_ACCESS_TOKEN}    Get Environment Variable    _ACCESS_TOKEN

    Set Global Variable    ${_POS_USER}         ${_POS_USER}
    Set Global Variable    ${_POS_PASS}         ${_POS_PASS}
    Set Global Variable    ${_FLUKE_UID}        ${_FLUKE_UID}
    Set Global Variable    ${_ACCESS_TOKEN}     ${_ACCESS_TOKEN}

End Script
    Run Keyword If Test Failed    Do This When Script Failed
    Close All Browsers

Do This When Script Failed
    ${TEST MESSAGE}  Remove String  ${TEST MESSAGE}  \n
    Send Text To Line User  \[Robot Failed\]${TEST MESSAGE}  ${_FLUKE_UID}  ${_ACCESS_TOKEN}
    Run Keyword If    ${IS_LOCAL}  Capture Page Screenshot    Screenshot.png
    # LineCaller.Sent Alert To Line By ID  message=${TEST NAME} was Failed, with error \(${TEST MESSAGE}\)
    # Capture Page Screenshot
    Close All Browsers

############################################################################################################################################

Login to Firebear Sothorn POS
    Common Input text when ready    ${LOG_user}  ${_POS_USER}
    Common Input password when ready    ${LOG_pass}  ${_POS_PASS}
    Common Click Element when ready    ${LOG_submit_btn}
    # BuiltIn.Wait Until Keyword Succeeds  5 x  1 sec    Check Should Be On Home Page
    Log To Console  ${\n}Login to Wongnai
    Check date button should be visible
    Reload Page  #Reload to get rid of advertise

# Open Wongnai POS WEB on Headless and Maximize Window
#     Open Browser Headless   url=${POS_WONGNAI_URL}
#     # Run Keyword If  ${IS_LOCAL}  Open Browser  url=${POS_WONGNAI_URL}  browser=chrome
#     Log To Console  ${\n}Browser is open
#     Maximize Browser Window

Open Wongnai POS WEB on Headless and Maximize Window
    [Arguments]    ${url}=${POS_WONGNAI_URL}
    # ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # ${is_headless}  Set Variable  True
    IF  ${IS_LOCAL}

        Open Browser    ${url}    browser=chrome

    ELSE
        ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        BuiltIn.Call Method    ${chrome options}    add_argument    test-type
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-extensions
        BuiltIn.Call Method    ${chrome options}    add_argument    --headless
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-gpu
        BuiltIn.Call Method    ${chrome options}    add_argument    --no-sandbox
        BuiltIn.Call Method    ${chrome options}    add_argument    start-maximized
        BuiltIn.Call Method    ${chrome options}    add_argument    --disable-dev-shm-usage
        Create Webdriver    Chrome    chrome_options=${chrome options}
        Goto    ${url}
    END
    Maximize Browser Window
    Log To Console  ${\n}Browser is open

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

############################################################################################################################################
***Test Cases***
############################################################################################################################################
Update delivery and rewardable counter bill to Firestore
    [Tags]    Include-counter
    [Setup]  Script Setup  ${INPUT_DATE}
    Set Test Variable    ${TEST NAME}    [Include counter] Update Bill To Firestore

    Login to Firebear Sothorn POS
    Go To Daily Billing Page
    Set Date To Expect Date and Validate Data Date Should be Expecte Date
    Click To Show All Row
    Sleep  ${Global_SLEEP}
    Set Selenium Speed   0

    ${delivery_bill_list}    Get All Current Bill Exclude Counter
    log to console  ${\n}Delivery bill list:${\n}${delivery_bill_list}

    ${reward_counter_list}    Get Rewardable Counter Bill
    log to console  ${\n}Reward counter list:${\n}${reward_counter_list}

    ${cur_bill_list}   Combine Lists    ${delivery_bill_list}    ${reward_counter_list}
    log to console  ${\n}Cur bill list:${\n}${cur_bill_list}
    ${is_up_to_date}  ${non_exist_list}  ToTheCloud.Bill list should exist for expected day  ${cur_bill_list}  ${FS_DATE}

    IF  ${is_up_to_date}

        log to console  ${\n}Every bill is updated.
        # LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated.

    ELSE

        log to console  ${\n}Non exist list:${\n}${non_exist_list}
        ${bill_info}  Get New Order Detail From Bill List  ${non_exist_list}
        Update Bill Document to FireStore  ${bill_info}

    END

    ${is_void_exist}    ${void_order_list}    Get void order if exist
    log to console  ${\n}Void order list:${\n}${void_order_list}

    IF  ${is_void_exist}
        ${is_void_exist_in_fs}  Check If Void Bill is exist  ${void_order_list}  ${FS_DATE}
        IF  ${is_void_exist_in_fs}
            Delete List Of Order  ${void_order_list}  ${FS_DATE}
            log to console    ${\n}Success delete void: ${void_order_list}
        ELSE
            log to console    ${\n}All void deleted
        END
    ELSE
        log to console    ${\n}No void
    END

    [Teardown]  End Script

Delete every document that older
    [Tags]    Clear-Old-Document
    [Setup]    Set up initial value from OS variable
    #Get the date older than today for 7 days
    Set Date For FireStore
    Set Test Variable  ${DATA_DATE}  ${FS_DATE}
    ${cur_date}  Get Current Date  UTC  + 7 hours - ${EXPIRED_ORDER}  result_format=%d-%m-%Y

    log to console    ${\n}Delete Document Where older Than ${cur_date}
    ToTheCloud.Delete Document Where older Than '${cur_date}'
    [Teardown]
  
Clear Redeem History
    [Tags]    Clear-Redeem-History
    [Setup]    Set up initial value from OS variable
    
    Set Date For FireStore
    Set Test Variable  ${DATA_DATE}  ${FS_DATE}
    ${expire_due_date}  Get Current Date  UTC  + 7 hours  result_format=%d-%m-%Y
    ${used_due_date}  Get Current Date  UTC  + 7 hours - ${REDEEM_USED_EXPIRED}  result_format=%d-%m-%Y
    ${delete_date}  Get Current Date  UTC  + 7 hours + ${REDEEM_DELETE_DATE}  result_format=%d-%m-%Y
    log to console  ${\n}expire_date:${expire_due_date} used_due_date:${used_due_date}
    
    Delete used and expired RedeemhHistory  ${used_due_date}  ${expire_due_date}
    [Teardown]

Test docker
    [Tags]    docker
    [Setup]    Set up initial value from OS variable
    log to console    ${\n}Test Success
    [Teardown]

Update only delivery bill to firestore
    [Documentation]    This script goto poswognai and check not exist bill then update them to Firestore
    [Tags]    new-logic-update-bill
    [Setup]  Script Setup  ${INPUT_DATE}

    Set Test Variable    ${TEST NAME}    [New-logic] Update bill for ${FS_DATE}
    log to console    ${\n}${TEST NAME}
    Go To Daily Billing Page
    Set Date To Expect Date and Validate Data Date Should be Expecte Date
    Click Show All Row
    Sleep  ${Global_SLEEP}
    SeleniumLibrary.Set Selenium Speed    0

    ${cur_bill_list}  Get All Current Bill Exclude Counter
    log to console  ${\n}cur_bill_list:${\n}${cur_bill_list}
    ${is_up_to_date}  ${non_exist_list}  Bill list should exist for expected day  ${cur_bill_list}  ${FS_DATE}
    

    IF  ${is_up_to_date}

        log to console  ${\n}Every bill is updated.
        # Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated.

    ELSE

        log to console  ${\n}non_exist_list:${\n}${non_exist_list}
        ${bill_info}  Get New Order Detail From Bill List  ${non_exist_list}
        log to console  ${\n}bill_info:${\n}${bill_info}
        Update Bill Document to FireStore  ${bill_info}

    END

    [Teardown]  End Script
