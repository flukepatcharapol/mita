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

    #Check if there are only counter order
    ${list_length}  Get Length  ${list}
    ${is_new_delivery}  Run Keyword and Return Status  Should Be True  ${list_length}<=0
    IF  ${is_new_delivery}
        Pass Execution  There are only new counter orders.
    END
    Update Bill Document to FireStore  ${list}

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
    
    IF  '${result}'=='False'
        LineCaller.Sent Alert To Line By ID  message=\[Order\] No document older than ${date}
        Pass Execution  There are no document older than ${date}
    END

    [Return]  ${result}

Bill list should exist for today
    [Arguments]  ${bill_list}
    ${date}  Replace String  ${DATA_DATE}  /  -
    ${result}  ${fail_list}  Uploader.billShouldExist  ${bill_list}  ${date}
    [Return]  ${result}  ${fail_list}

Update Bill to Firestore
    [Arguments]  ${bill_dict}
    ${is_update}  ${update_list}  Uploader.updateDeliveryBillToCloud  ${bill_dict}

    IF  ${is_update}
        ${list_length}  Get Length  ${update_list}
        LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] Update ${list_length} bills, which are ${update_list}
    ELSE
        LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] There is no new bill to update.
    END

Delete used and expired RedeemhHistory
    [Arguments]  ${used_due_date}  ${expire_due_date}
    @{used_list}  Uploader.removeRedeemHistory  ${used_due_date}  ${expire_due_date}
    log to console  finish delete used:${used_list}    #and expire: ${expired_list}
    LineCaller.Sent Alert To Line By ID  message=\[${TEST NAME}\] finish delete used:${used_list}   # and expire: ${expired_list}