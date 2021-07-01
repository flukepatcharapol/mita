***Keywords***
############################################################################################################################################
#Common Function
############################################################################################################################################
Element Should Be Visible With Retry
    [Arguments]  ${element}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Element Should Be Visible  ${element}
    # Wait Until Element Is Visible  ${element}  ${GOLBAL_TIMEOUT}  error=The ${element} is not visible in ${GOLBAL_TIMEOUT}

Click Element When Ready
    [Arguments]  ${element}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Click Element  ${element}
    # Wait Until Element Is Visible  ${element}  ${GOLBAL_TIMEOUT}  error=The ${element} is not visible in ${GOLBAL_TIMEOUT}
    # Click Element  ${element}

Input Text When Ready
    [Arguments]  ${element}  ${text}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Input Text  ${element}  ${text}  clear=true
    # Wait Until Element Is Visible  ${element}  ${GOLBAL_TIMEOUT}  error=The ${element} is not visible in ${GOLBAL_TIMEOUT}
    # Input Text  ${element}  ${text}  clear=True
