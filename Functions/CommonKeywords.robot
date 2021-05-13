***Keywords***
############################################################################################################################################
#Common Function
############################################################################################################################################
Element Should Be Visible With Retry
    [Arguments]  ${element}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Element Should Be Visible  ${element}

Click Element When Ready
    [Arguments]  ${element}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Click Element  ${element}

Input Text When Ready
    [Arguments]  ${element}  ${text}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Input Text  ${element}  ${text}  clear=true

Log To Console And Debug With Message '${msg}'
    Log To Console    ${\n}${msg}${\n}
    Debug