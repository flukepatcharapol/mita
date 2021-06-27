***Settings***
Library      ${CURDIR}/python/Uploader.py

***Keywords***
Transform To Firestore Format And Sent To FireStore
    [Arguments]    ${newline_detail}  ${is_add}=True
    ${key}=    Get Dictionary Keys  ${newline_detail}
    ${dict_length}=    Get Length    ${key}
    ${bill_list}=  Create List
    ${result}=    Create List
    FOR  ${INDEX}    IN    @{key}
        ${body}=    Get From Dictionary   ${newline_detail}   ${INDEX}  #INDEX is key
        ${is_valid}=    Get From Dictionary    ${body}    Is_valid
        IF  ${is_valid}

            #Get info
            ${order_date}    Get From Dictionary  ${body}  Order_date
            ${point}         Get From Dictionary  ${body}  Point
            ${price}         Get From Dictionary  ${body}  Price
            ${amount}        Get From Dictionary  ${body}  Amount
            ${bill}          Get From Dictionary  ${body}  Bill_id
            ${type}          Get From Dictionary  ${body}  Type
            ${product_list}  Get From Dictionary  ${body}  Product_list

            #Set into Doc info to Document format
            ${result_body}=  Create Dictionary    Delivery=${type}    
            ...    OrderDate=${order_date}    Point=${point}    Price=${price}
            ...    Amount=${amount}  BillId=${bill}  ProductList=${product_list}  isValid=${is_valid}

            #Append Info to Document
            Append To List    ${result}    ${result_body}
            Append To List    ${bill_list}  ${bill}
            log to console  ${\n}${result_body}

        END
    END
    Run Keyword If  ${is_add}  Set New Line To The FireStore  ${result}
    [Return]  ${bill_list}

Set New Line To The FireStore
    [Arguments]    ${list}
    ${I}    Set Variable    0
    ${fail_list}    Create List
    ${success_list}  Create List
    ${bill_list}  Create List
    ${new_data_length}  Get Length  ${list}
    ${bill_date}  Get From Dictionary  ${list}[0]  OrderDate

    FOR  ${INDEX}  IN  @{list}

        #Get information from ordered dict
        ${delivery}    Get From Dictionary  ${INDEX}  Delivery
        ${date}        Get From Dictionary  ${INDEX}  OrderDate
        ${bill}        Get From Dictionary  ${INDEX}  BillId
        ${prod_list}   Get From Dictionary  ${INDEX}  ProductList
        ${is_valid}    Get From Dictionary  ${INDEX}  isValid
        ${price}       Get From Dictionary  ${INDEX}  Price
        ${amount}      Get From Dictionary  ${INDEX}  Amount

        # Get Point and convert to Int
        ${point}       Get From Dictionary  ${INDEX}  Point
        ${point}       Convert To Integer   ${point}
        ${date}        Convert To String    ${date}

        Append To List  ${bill_list}  ${bill}

        #Call uploader to send info to firestore
        IF  ${is_valid}
            Uploader.sendToFireStoreCollection    ${delivery}  ${date}  
            ...   ${point}  ${bill}  ${price}  ${amount}  ${prod_list}
        END
    
    END

    ${is_success}=  Uploader.billShouldExist  ${bill_list}  ${bill_date}

    IF  ${is_success}

        #Sent success notify and update the prev number
        LineCaller.Sent Alert To Line By ID  message=SuccessFully Upload new Line To Firestore. New ${new_data_length} records. Bill list: ${bill_list}
        
        ${cur_row}  Convert To String  ${CURRENT_ROW}
        ${date}=  Replace String  ${DATA_DATE}  /  -
        Update New Prev Number  ${date}  ${cur_row}
        log to console  ${\n}Update prev number for ${date} to ${cur_row}

    ELSE

        #Just sent fail notification and wait for retry on the next time
        Set Test Variable  ${TEST MESSAGE}  Failed To Upload new Line To Firestore. Re-try next round. Bill list: ${bill_list}
        Fail
        

    END

Get Prev Line Saved
    [Arguments]  ${date}
    ${result}=    Uploader.getPrevNumber  ${date}
    ${line}=  Get From Dictionary  ${result}  line
    [Return]  ${line}

Update New Prev Number
    [Documentation]  Date format  11-05-2021
    [Arguments]  ${date}  ${number}
    Uploader.setPrevNumber    ${date}  ${number}

Delete Prev Number Where older Than '${date}'
    [Documentation]  Date format  11-05-2021
    ${result}  Uploader.deleteAllOlderPrev  ${date}
    [Return]  ${result}

Delete Document Where older Than '${date}'
    [Documentation]  Date format  11-05-2021
    ${result}  Uploader.deleteAllOlderDoc  ${date}
    [Return]  ${result}

Bill list should exist for today
    [Arguments]  ${bill_list}
    ${date}  Replace String  ${DATA_DATE}  /  -
    ${result}  ${fail_list}  Uploader.billShouldExist  ${bill_list}  ${date}
    Should Be True  ${result}  msg=[End-day] Not every bill for today is added ${fail_list} not exist
    [Return]  ${result}