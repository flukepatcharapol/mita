***Keywords***
####################################################################################################################################################################################
Send Text To Line User
    [Arguments]  ${text}    ${receiver}   ${sender}
    ${header}=  Get MY Bot Header   ${sender}

    ${body}  Set Variable  {"to": "${receiver}","messages": [{"type": "text","text": "${text}"}]} 
    Create Session  Send Text  ${LINE.url}  headers=${header}  verify=True
    ${response}=  POST Request  Send Text  ${LINE.push_message}  data=${body}     # [interim]${response}=  POST On Session  alias=Send Text  url=${LINE}[push_message]  data=${body}
    Delete All Sessions

    ${is_success}=  Run Keyword And Return Status  Should Be Equal As Strings  ${response.status_code}  200  
    ...    msg=Failed To send Message with code:${response.status_code} body:${response.json()}

    #Validate Send text result
    Should Be Equal As Strings  ${response.status_code}  200   msg=Failed To send Message with code:${response.status_code} body:${response.json()}

####################################################################################################################################################################################

Get My Bot Header
    [Arguments]  ${token}=${_ACCESS_TOKEN}
    ${header}=  Create Dictionary  Content-Type=application/json  Authorization=Bearer ${token}
    [Return]  ${header}

Sent Alert To Line By ID
    [Arguments]  ${message}  ${receiver}=${_FLUKE_UID}  ${sender}=${_ACCESS_TOKEN}
    ${is_exist}  Run Keyword And return Status  Variable Should Exist  ${DATA_DATE}

    IF  ${is_exist}

        ${show_date}  Set Variable  DATA_DATE

    ELSE

        ${show_date}  Set Variable  FS_DATE
        Set Test Variable  ${DATA_DATE}  ${FS_DATE}

    END

    ${body_message}=  Set Variable    ${message} ${show_date}: ${DATA_DATE}
    Send Text To Line User  ${body_message}  ${receiver}  ${sender}