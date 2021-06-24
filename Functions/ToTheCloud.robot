***Settings***
Library      ${CURDIR}/python/Uploader.py

***Keywords***
Transform To Firestore Format And Sent To FireStore
    [Arguments]    ${newline_detail}
    ${key}=    Get Dictionary Keys  ${newline_detail}
    ${dict_length}=    Get Length    ${key}
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
            log to console  ${\n}${result_body}

        END
    END
    Set New Line To The FireStore  ${result}

Set New Line To The FireStore
    [Arguments]    ${list}
    ${I}    Set Variable    0
    ${fail_list}    Create List
    ${success_list}  Create List
    ${bill_list}  Create List
    ${new_data_length}  Get Length  ${list}
    ${bill_date}  Get From Dictionary  ${list}[0]  OrderDate
    log to console  ${\n}bill_date: ${bill_date}

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

            #Validate Upload result
            # IF  ${upload_result}

            #     Append To List  ${success_list}  ${bill}

            # ELSE

            #     Append To List  ${fail_list}  ${bill}

            # END
        END
    
    END

    # ${is_success}=  Run Keyword And Return Status  Should Be Empty  ${fail_list}

    ${is_success}=  Uploader.billShouldExist  ${bill_list}  ${bill_date}
    log to console  ${\n}doc_list: ${is_success}

    IF  ${is_success}

        #Sent success notify and update the prev number
        LineCaller.Sent Alert To Line By ID  message=SuccessFully Upload new Line To Firestore. New ${new_data_length} records. Bill list: ${bill_list}
        
        ${cur_row}  Convert To String  ${CURRENT_ROW}
        ${date}=  Replace String  ${DATA_DATE}  /  -
        Update New Prev Number  ${date}  ${cur_row}
        log to console  ${\n}Update prev number for ${date} to ${cur_row}

        # Update Sale Total For Document '${date}'

    ELSE

        #Just sent fail notification and wait for retry on the next time
        Set Test Variable  ${TEST MESSAGE}  Failed To Upload new Line To Firestore. Re-try next round. Bill list: ${bill_list}
        # LineCaller.Sent Alert To Line By ID  message=Failed To Upload new Line To Firestore. Re-try next round. Bill list: ${bill_list}
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