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
    Element Should Be Visible With Retry  ${element}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Click Element  ${element}
    # Wait Until Element Is Visible  ${element}  ${GOLBAL_TIMEOUT}  error=The ${element} is not visible in ${GOLBAL_TIMEOUT}
    # Click Element  ${element}

Input Text When Ready
    [Arguments]  ${element}  ${text}  ${attempt}=${ATTEMPT}  ${wait_time}=${WAIT}
    BuiltIn.Wait Until Keyword Succeeds  ${attempt}  ${wait_time}  Input Text  ${element}  ${text}  clear=true
    # Wait Until Element Is Visible  ${element}  ${GOLBAL_TIMEOUT}  error=The ${element} is not visible in ${GOLBAL_TIMEOUT}
    # Input Text  ${element}  ${text}  clear=True

Common wait element is visible
    [Arguments]    ${element}    ${timeout}=${ELEMENT_TIMEOUT}
    Wait Until Element Is Visible    ${element}    ${timeout}

Common Click Element when ready
    [Arguments]    ${element}    ${timeout}=${ELEMENT_TIMEOUT}
    Wait Until Element Is Visible    ${element}    ${timeout}
    Click Element    ${element}

Common Input text when ready
    [Arguments]    ${element}    ${text}    ${timeout}=${ELEMENT_TIMEOUT}
    Wait Until Element Is Visible    ${element}    ${timeout}
    Input Text    ${element}    ${text}    clear=true

Common Input password when ready
    [Arguments]    ${element}    ${password}    ${timeout}=${ELEMENT_TIMEOUT}
    Wait Until Element Is Visible    ${element}    ${timeout}
    Input password    ${element}    ${password}    clear=true

Common element should contain
    [Arguments]    ${element}    ${expected}    ${timeout}=${ELEMENT_TIMEOUT}
    Wait Until Element Is Visible    ${element}    ${timeout}
    Element Should Contain    ${element}    ${expected}