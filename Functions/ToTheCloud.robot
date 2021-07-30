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

Update Bill Document to FireStore
    [Arguments]  ${list}
    ${fail_list}    Create List
    ${success_list}  Create List
    ${bill_list}  Create List
    ${new_data_length}  Get Length  ${list}
    ${bill_date}  Get From Dictionary  ${list}[0]  Order_date

    FOR  ${INDEX}  IN  @{list}

        #Get information from ordered dict
        ${delivery}    Get From Dictionary  ${INDEX}  Type
        ${date}        Get From Dictionary  ${INDEX}  Order_date
        ${bill}        Get From Dictionary  ${INDEX}  Bill_id
        ${prod_list}   Get From Dictionary  ${INDEX}  Product_list
        ${is_valid}    Get From Dictionary  ${INDEX}  Is_valid
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
            log to console  ${\n}Sent update for ${bill}
        END
    
    END

    #The result_list retrun the list of fail or sucess depends on is_success.
    ${is_success}  ${result_list}=  Uploader.billShouldExist  ${bill_list}  ${bill_date}

    IF  ${is_success}

        #Sent success notify and update the prev number
        LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] New ${new_data_length} records. Success list: ${result_list}

    ELSE
        #Just sent fail notification and wait for retry on the next time
        ${fail_length}  Get Length  ${result_list}
        Set Test Variable  ${TEST MESSAGE}  Fail to up date ${fail_length} records. Fail list: ${result_list}
        Fail
        

    END

Bill list should exist for today
    [Arguments]  ${bill_list}
    ${date}  Replace String  ${DATA_DATE}  /  -
    ${result}  ${fail_list}  Uploader.billShouldExist  ${bill_list}  ${date}
    [Return]  ${result}  ${fail_list}

Delete used and expired RedeemhHistory
    [Arguments]  ${used_due_date}  ${expire_due_date}  ${delete_date}
    ${mark_expired_list}  ${delete_list}  Uploader.removeRedeemHistory  ${used_due_date}  ${expire_due_date}  ${delete_date}
    LineCaller.Sent Alert To Line By ID  message=\[CODE\] finish delete Redeem-code Mark expired list:${mark_expired_list} Delete list:${delete_list}
    Pass Execution  finish delete Redeem-code Mark expired list:${mark_expired_list} Delete list:${delete_list}

Delete Document Where older Than '${date}'
    [Documentation]  Date format  11-05-2021
    ${result}  ${list}  Uploader.deleteAllOlderDoc  ${date}
    log to console    ${\n}result:${result}${\n}list:${list}
    
    # Check the result and sent Line notification
    IF  '${result}'=='False'

        LineCaller.Sent Alert To Line By ID  message=\[Order\] No document older than ${date}
        Pass Execution  There are no document older than ${date}

    ELSE IF  '${result}'=='Success'

        LineCaller.Sent Alert To Line By ID  message=\[Order\] Finish Empty ${list} older than ${date}
        Pass Execution   Finish Empty ${list} for ${date}

    ELSE IF  '${result}'=='Failed'

        Fail  Failed to empty ${list} older than ${date}

    ELSE

        Fail  Failed to empty doc older than ${date} with no reason

    END