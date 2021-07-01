***Settings***
Resource       ${CURDIR}/Functions/LibraryImport.robot
Resource       ${CURDIR}/Functions/CommonKeywords.robot
Resource       ${CURDIR}/Functions/EventLogger.robot
Resource       ${CURDIR}/Functions/GetFromWongnai.robot
Resource       ${CURDIR}/Functions/LineCaller.robot
Resource       ${CURDIR}/Functions/ToTheCloud.robot

Variables      ${CURDIR}/Config.yaml

***Variables***
#Config Variable
${ATTEMPT}             20 x
${WAIT}                0.5 sec
${SCREENSHOT_DIR}      ${CURDIR}\\AutoScreenshot
${GOLBAL_SLEEP}        0.5 sec
${GCP_BUILD_LINK}      https\://console.cloud.google.com/cloud-build/builds/${BUILD_ID}?project\=${PROJECT_ID}
${GOLBAL_TIMEOUT}      1 min

############################################################################################################################################
***Keywords***
############################################################################################################################################
# Setup and Teardown Function
############################################################################################################################################
Script Setup
    [Arguments]  ${is_date}=False

    Log to console  ${\n}Build_id: ${BUILD_ID}
    log to console  ${\n}Test link: ${GCP_BUILD_LINK}
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

    LineCaller.Sent Alert To Line By ID  message=The \[${TEST NAME}\] was Failed, with error \(${TEST MESSAGE}\)

############################################################################################################################################

Login to Firebear Sothorn POS
    Input Text  ${LOG_user}  ${_POS_USER}  clear=true  
    Input Text  ${LOG_pass}  ${_POS_PASS}  clear=true
    Click Element  ${LOG_submit_btn}
    Check Should Be On Home Page
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
    END
    Create Webdriver    Chrome    chrome_options=${chrome options}
    Goto    ${url}

Clean Download Directory
    Empty Directory  ${DOWNLOAD_DIR}

Count Row and Compare With Previous Run
    [Arguments]  ${is_prev_from_fs}=True
    GetFromWongnai.Count Row
    Check If Have New Record  ${CURRENT_ROW}  ${is_prev_from_fs}
    
    Log To Console  ${\n}Rows are Counted And Compared!
    
Check If Have New Record
    [Arguments]  ${current_row}  ${is_prev_from_fs}
    IF  ${is_prev_from_fs}

        ${prev}=  ToTheCloud.Get Prev Line Saved  ${FS_DATE}

    ELSE

        ${prev}=  Set Variable  0

    END

    IF  '${prev}'=='False'
        log to console  ${\n}Prev is NOT Exist
        Set Test Variable    ${IS_NEW}       True
        Set Test Variable    ${PREV_LENGTH}  0

    ELSE
        log to console  ${\n}Prev is Exist
        log to console  ${\n}Current row: ${current_row}
        ${is_new_line}  Run Keyword And Return Status  Should Be True  ${current_row}>${prev}  msg= There are no new order yet. Latest\[ ${current_row} \] Prev\[ ${prev} \]
        Set Test Variable    ${IS_NEW}       ${is_new_line}
        Set Test Variable    ${PREV_LENGTH}  ${prev}

    END

Set Date For FireStore
    [Documentation]  Date format  30-12-2021
    [Arguments]  ${expect_date}

    IF  '${expect_date}'=='False'
        ${cur_date}=   Get Current Date  UTC  + 7 hour  result_format=%d-%m-%Y
        Set Test Variable  ${FS_DATE}  ${cur_date}
    ELSE
        Set Test Variable  ${FS_DATE}  ${expect_date}
    END

    Log to console  ${\n}Set FS_DATE: ${FS_DATE}

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
Get Report From POS Wongnai, and Send Data to Firestore Cloud
    [Tags]    Get-New-Line
    [Setup]  Script Setup
    
    Set Test Variable    ${TEST NAME}    Get Report From POS Wongnai
    GetFromWongnai.Go To Daily Billing Page
    GetFromWongnai.Set Date To Today and Validate Data Date Should be Today
    GetFromWongnai.Click To Expected Time Order
    GetFromWongnai.Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    Count Row and Compare With Previous Run
    SeleniumLibrary.Set Selenium Speed    0

    IF  ${IS_NEW}

        log to console  ${\n}There are new line
        Sleep  ${GOLBAL_SLEEP}
        ${newline_detail}=  GetFromWongnai.Get New Order Detail  ${PREV_LENGTH}
        ToTheCloud.Transform To Firestore Format And Sent To FireStore    ${newline_detail}

    ELSE
        log to console  ${\n}No new line
        LineCaller.Sent Alert To Line By ID  message=No New Line To Add
    END

    [Teardown]  End Script

Reset Every 00:00
    [Tags]    Morning-Reset
    #Get the date older than today for 4 days
    Set Date For FireStore
    Set Test Variable  ${DATA_DATE}  ${FS_DATE}
    ${expire_due_date}=  Set Variable  7
    ${cur_date}  Get Current Date  UTC  + 7 hours - ${expire_due_date} days  result_format=%d-%m-%Y
    Log to console  ${\n}[Mita] Delete every prev before ${cur_date}

    #Delete the doc which older than ${cur_date}
    ${result}  ToTheCloud.Delete Prev Number Where older Than '${cur_date}'
    ${is_empty}  Run Keyword And Return Status  Should Be Empty  ${result}

    #Sent noti to line is success or not
    IF  ${is_empty}

        LineCaller.Sent Alert To Line By ID  message=[Mita] Success Empty The Prev Line for ${FS_DATE}

    ELSE

        LineCaller.Sent Alert To Line By ID  message=[Mita] FAILED to Empty The Prev Line for ${FS_DATE} Failed list: ${result}
        log to console  ${\n}Failed list: ${result}

    END

    ${result}  ToTheCloud.Delete Document Where older Than '${cur_date}'
    ${is_empty}  Run Keyword And Return Status  Should Be Empty  ${result}
    Log to console  ${\n}[Order] Delete every document before ${cur_date}

    #Sent noti to line is success or not
    IF  ${is_empty}

        LineCaller.Sent Alert To Line By ID  message=[Order] Finish Empty The Document for ${FS_DATE}

    ELSE

        LineCaller.Sent Alert To Line By ID  message=[Order] FAILED to Empty The Document for ${FS_DATE} Failed list: ${result}
        log to console  ${\n}Failed list: ${result}

    END



Test connection with google cloud build
    [Tags]  test-img
    Import Library  ${CURDIR}/Image.py
    ${img_b64}  Image.getImageConvertTo64  ${CURDIR}/test/test.png
    Import Library  DebugLibrary
    Debug
    Create session  Upload Image  https://api.imgbb.com/  verify=true
    ${body}=  Create Dictionary  image=${img_b64}
    ${params}=  Create Dictionary  expiration=600  key=e3d1cebcde04c6b4d2ae049f5e63ab3b  
    ${response}  Post Request  Upload Image  /1/upload?expiration\=600&key=e3d1cebcde04c6b4d2ae049f5e63ab3b  files=/test/test.png
    

End Day Check
    [Tags]  End-Day
    [Setup]  Script Setup

    GetFromWongnai.Go To Daily Billing Page
    GetFromWongnai.Set Date To Today and Validate Data Date Should be Today
    GetFromWongnai.Click To Expected Time Order
    GetFromWongnai.Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    Count Row and Compare With Previous Run  is_prev_from_fs=False
    SeleniumLibrary.Set Selenium Speed    0

    IF  ${IS_NEW}

        log to console  ${\n}There are new line
        Sleep  ${GOLBAL_SLEEP}
        ${newline_detail}=  GetFromWongnai.Get New Order Detail  ${PREV_LENGTH}
        ${bill_list}=  ToTheCloud.Transform To Firestore Format And Sent To FireStore    ${newline_detail}  is_add=False
        ${result}  ${fail_list}=  ToTheCloud.Bill list should exist for today  ${bill_list}
        IF  ${result}
            LineCaller.Sent Alert To Line By ID  message=[End-day] Every bill is updated
        ELSE
            LineCaller.Sent Alert To Line By ID  message=[End-day] Not every bill for today is added ${fail_list} is not exist
        END
    [Teardown]  End Script

Get All Bills from POS wongnai and update to Firestore cloud
    [Tags]  Update-Delivery
    [Setup]  Script Setup

    Set Test Variable    ${TEST NAME}    Update Bill To Firestore
    GetFromWongnai.Go To Daily Billing Page
    # GetFromWongnai.Set Date To Today and Validate Data Date Should be Today
    # GetFromWongnai.Click To Expected Time Order
    GetFromWongnai.Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    Set Test Variable  ${PREV_LENGTH}  0
    SeleniumLibrary.Set Selenium Speed    0

    log to console  ${\n}There are new line
    Sleep  ${GOLBAL_SLEEP}
    ${bill_dict}  ${bill_list}=  GetFromWongnai.Get New Order Detail  ${PREV_LENGTH}
    ${is_up_to_date}  ${non_exist_list}  ${existing_list}  ${doc_list}  ToTheCloud.Bill list should exist for today  ${bill_list}
    log to console  ${\n}non_exist_list:${\n}${non_exist_list}
    log to console  ${\n}existing_list:${\n}${existing_list}
    log to console  ${\n}doc_list:${\n}${doc_list}
    log to console  ${\n}is_up_to_date:${\n}${is_up_to_date}

    IF  ${is_up_to_date}

        LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] Every bill is updated

    ELSE
        log to console  ${\n}in else
        ${update_list}  Get Only Not Exist Bill Dict  ${non_exist_list}  ${bill_dict}
        log to console  ${\n}result: ${update_list}
        ToTheCloud.Update Bill Document to FireStore  ${update_list}

    END

    [Teardown]  End Script