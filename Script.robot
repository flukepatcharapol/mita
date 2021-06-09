***Settings***
Resource       ${CURDIR}/Functions/LibraryImport.robot
Resource       ${CURDIR}/Functions/CommonKeywords.robot
Resource       ${CURDIR}/Functions/EventLogger.robot
Resource       ${CURDIR}/Functions/GetFromWongnai.robot
Resource       ${CURDIR}/Functions/LineCaller.robot
Resource       ${CURDIR}/Functions/ToTheCloud.robot

# Variables      ${CURDIR}/Config.yaml

***Variables***
#Config Variable
${ATTEMPT}             5x
${WAIT}                0.5 sec
${SCREENSHOT_DIR}      ${CURDIR}\\AutoScreenshot
${BROWSER}             Chrome
${GOLBAL_SLEEP}        0.5 sec


#Script Variable
${Desired_menu}        #แต้มออนไลน์ Interim

${out_dir}             ${CURDIR}\\$TARGET\\Outputs\\
${prev_path_txt}       prev.txt




############################################################################################################################################
***Keywords***
############################################################################################################################################
# Setup and Teardown Function
############################################################################################################################################
Script Setup
    Set Test Variable    ${TEST NAME}    Get Report From POS Wongnai
    Empty Directory  ${CURDIR}\\FailedScreenshot\\
    Selenium2Library.Set Selenium Speed    0.001
    Open Wongnai POS WEB on Headless and Maximize Window
    Maximize Browser Window
    Login to Firebear Sothorn POS

End Script
    Run Keyword If Test Failed    Do This When Script Failed
    Close All Browsers

Do This When Script Failed
    ${cur_time}=  Get Time
    # Capture Page Screenshot  ${CURDIR}\\FailedScreenshot\\${cur_time}.png
    ${TEST MESSAGE}  Remove String  ${TEST MESSAGE}  \n

    LineCaller.Sent Alert To Line Group By ID  message=The \[${TEST NAME}\] was Failed, with error ${TEST MESSAGE}
    EventLogger.Log to Logger File  log_status=FAILED  event=TearDown  message=The \[${TEST NAME}\] was Failed, with error message: ${TEST MESSAGE}

############################################################################################################################################

Login to Firebear Sothorn POS
    # Input Text  ${LOG_user}  firebear.sothorn${pos_wn_username}  clear=true
    # Input Text  ${LOG_pass}  Makham${pos_wn_password}  clear=true
    Input Text  ${LOG_user}  ${_POS_USER}  clear=true  
    Input Text  ${LOG_pass}  ${_POS_PASS}  clear=true
    Click Element  ${LOG_submit_btn}
    Check Should Be On Home Page
    Log To Console  ${\n}Loged in to Wongnai!

Open Wongnai POS WEB on Headless and Maximize Window
    Selenium2Library.Open Browser   url=${POS_WONGNAI_URL}    browser=${BROWSER}
    Log To Console  ${\n}Browser is open!
    Maximize Browser Window

Clean Download Directory
    Empty Directory  ${DOWNLOAD_DIR}

Count Row and Compare With Previous Run
    GetFromWongnai.Count Row
    Check If Have New Record  ${CURRENT_ROW}
    
    Log To Console  ${\n}Rows are Counted And Compared!
    
Check If Have New Record
    [Arguments]  ${current_row}
    ${prev}=  ToTheCloud.Get Prev Line Saved  ${FS_DATE}
    IF  '${prev}'=='False'
        log to console  ${\n}Prev is NOT Exist
        Set Test Variable    ${IS_NEW}       True
        Set Test Variable    ${PREV_LENGTH}  0

    ELSE
        log to console  ${\n}Prev is Exist
        ${is_new_line}  Run Keyword And Return Status  Should Be True  '${current_row}'>'${prev}'  msg= There are no new order yet. Latest[ ${current_row} ] Prev[ ${prev} ]
        Set Test Variable    ${IS_NEW}       ${is_new_line}
        Set Test Variable    ${PREV_LENGTH}  ${prev}

    END

Set Date For FireStore
    ${cur_date}=   Get Current Date  local  result_format=%d-%m-%Y 
    Set Test Variable  ${FS_DATE}  ${cur_date}


############################################################################################################################################
***Test Cases***
############################################################################################################################################
Get Report From POS Wongnai, and Send Data to Firestore Cloud
    [Tags]    Get-New-Line-For-Normal
    [Setup]  Script Setup

    Set Test Variable  ${TARGET}  Normal
    Set Date For FireStore
    ${out_dir}=  Replace String  ${out_dir}  $TARGET  ${TARGET}
    Set Test Variable  ${OUTPUTS_DIR}  ${out_dir}
    Set Test Variable  ${PREV_PATH}  ${OUTPUTS_DIR}/${prev_path_txt}

    GetFromWongnai.Got To Daily Billing Page
    GetFromWongnai.Set Date To Today
    GetFromWongnai.Click To Expected Time Order
    GetFromWongnai.Click Show All Row
    Sleep  ${GOLBAL_SLEEP}
    Count Row and Compare With Previous Run
    Selenium2Library.Set Selenium Speed    0

    IF  ${IS_NEW}  

        Sleep  ${GOLBAL_SLEEP}
        ${newline_detail}=  GetFromWongnai.Get New Order Detail  ${PREV_LENGTH}
        ToTheCloud.Transform To Firestore Format And Sent To FireStore    ${newline_detail}

    ELSE
        ${cur_time}=  Get Time
        LineCaller.Sent Alert To Line Group By ID  message=No New Line To Add
        EventLogger.Log to Logger File  log_status=SUCCESS  event=No New Line  message=No New Line To Add
    END

    [Teardown]  End Script

Reset Every 00:00
    [Tags]    Morning-Reset

    # Set Test Variable  ${TARGET}  Normal
    # ${out_dir}=  Replace String  ${out_dir}  $TARGET  ${TARGET}
    # Set Test Variable  ${OUTPUTS_DIR}  ${out_dir}

    # Empty Directory    ${OUTPUTS_DIR}
    # ${is_empty}=  Run Keyword And Return Status  Directory Should Be Empty    ${OUTPUTS_DIR}
    # ${cur_time}=  Get TIme
    Set Date For FireStore
    ToTheCloud.Delete Prev Number From Date  ${FS_DATE}
    ${is_exist}=  ToTheCloud.Get Prev Line Saved  ${FS_DATE}

    IF  ${is_exist}==False

        LineCaller.Sent Alert To Line Group By ID  message=Finish Empty The Prev Line for ${FS_DATE}
        EventLogger.Log to Logger File  log_status=SUCCESS  event=Reset Daily  message=Finish Empty The Prev Line for ${FS_DATE}

    ELSE

        LineCaller.Sent Alert To Line Group By ID  message=FAILED to Empty The Prev Line for ${FS_DATE}
        EventLogger.Log to Logger File  log_status=FAILED  event=Reset Daily  message=FAILED To Empty The Prev Line for ${FS_DATE}

    END

    
    ${cur_date}=   Get Current Date  local  - 7 days  result_format=%d-%m-%Y

Test connection with google cloud build
    [Tags]  test-connect
    ${cur_date}  Get Time
    Set Test Variable  ${DATA_DATE}  ${cur_date}
    LineCaller.Sent Alert To Line Group By ID  message=The Could is successfully run!!!!!!
