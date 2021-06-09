***Keywords***
####################################################################################################################################################################################
Send Text To Line User
    [Arguments]  ${text}  ${receiver}
    ${header}=  Get MY Bot Header

    # ${message_body}=  Create Dictionary  type=text  text=${text}
    # ${list_msg}=  Create List  ${message_body}
    # ${body}=  Create Dictionary  to=${receiver}  message=${list_msg}

    ${body}  Set Variable  {"to": "${receiver}","messages": [{"type": "text","text": "${text}"}]} 
    Create Session  Send Text  ${LINE}[URL]  headers=${header}  verify=True
    ${response}=  POST Request  Send Text  ${LINE}[path][push_message]  data=${body}     # [interim]${response}=  POST On Session  alias=Send Text  url=${LINE}[path][push_message]  data=${body}
    Delete All Sessions

    ${is_success}=  Run Keyword And Return Status  Should Be Equal As Strings  ${response.status_code}  200  
    ...    msg=Failed To send Message with code:${response.status_code} body:${response.json()}

    IF  ${is_success}

        EventLogger.Log to Logger File  log_status=PASSED  event=Send Line  message=code:${response.status_code} body:${response.json()} Text:${body}

    ELSE

        EventLogger.Log to Logger File  log_status=FAILED  event=Send Line  message=code:${response.status_code} body:${response.json()} Text:${body}
        
    END

    #Validate Send text result
    Should Be Equal As Strings  ${response.status_code}  200   msg=Failed To send Message with code:${response.status_code} body:${response.json()}

####################################################################################################################################################################################

Get My Bot Header
    [Arguments]  ${token}=${LINE_ACCESS_TOKEN}
    ${header}=  Create Dictionary  Content-Type=application/json  Authorization=${token}
    [Return]  ${header}

Sent Alert To Line Group By ID
    [Arguments]  ${message}  ${receiver}=${LINE_FLUKE_UID}
    ${cur_time}=  Get Time

    ${body_message}=  Set Variable  ${message} DATA_DATE: ${DATA_DATE} at \[${cur_time}\]
    Send Text To Line User  text=${body_message}  ${receiver}
    # Send Text To Line User  text=${body_message}  receiver=U2e38cbaf2f18ee4bb4b16b303c5903c8