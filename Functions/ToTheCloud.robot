***Settings***
Library      ${CURDIR}/python/Uploader.py

***Keywords***
Update Bill Document to FireStore
    [Arguments]  ${bill_info}
    ${bill_list}  Create List
    ${key}  Get Dictionary Keys  ${bill_info}
    ${new_data_length}  Get Length  ${key}
    ${bill_date}  Get From Dictionary  ${bill_info}[${key}[0]]  Order_date

    FOR  ${INDEX}  IN  @{key}
        ${key_info}   Get From Dictionary  ${bill_info}  ${INDEX}

        #Get information from ordered dict
        ${delivery}    Get From Dictionary  ${key_info}  Type
        ${time}        Get From Dictionary  ${key_info}  Order_time
        ${date}        Get From Dictionary  ${key_info}  Order_date
        ${bill}        Get From Dictionary  ${key_info}  Bill_id
        ${prod_list}   Get From Dictionary  ${key_info}  Product_list
        ${is_valid}    Get From Dictionary  ${key_info}  Is_valid
        ${price}       Get From Dictionary  ${key_info}  Price
        ${amount}      Get From Dictionary  ${key_info}  Amount

        # Get Point and convert to Int
        ${point}       Get From Dictionary  ${key_info}  Point
        ${point}       Convert To Integer   ${point}
        ${date}        Convert To String    ${date}

        Append To List  ${bill_list}  ${bill}

        #Call uploader to send info to firestore
        IF  ${is_valid}
            Uploader.sendToFireStoreCollection    ${delivery}  ${date}  
            ...   ${point}  ${bill}  ${price}  ${amount}  ${time}  ${prod_list}
            log to console  ${\n}Sent update for ${bill}
        END
    
    END

    #The result_list retrun the list of fail or sucess depends on is_success.
    ${is_success}  ${result_list}=  Uploader.billShouldExist  ${bill_list}  ${bill_date}

    IF  ${is_success}
        
        Send line to crew and fluke phone
        LineCaller.Sent Alert To Line By ID  message=เพิ่มออเดอร์ใหม่ ${new_data_length} ออเดอร์ ออเดอร์ที่ถูกเพิ่ม: ${result_list}    receiver=${_CREW_UID}    sender=${_ACCESS_TOKEN_BO}
        
    ELSE
        #Just sent fail notification and wait for retry on the next time
        ${fail_length}  Get Length  ${result_list}
        Set Test Variable  ${TEST MESSAGE}  ${TEST NAME} Fail to up date ${fail_length} records. Fail list: ${result_list}

    END

Bill list should exist for expected day
    [Arguments]  ${bill_list}  ${expect_date}=${DATA_DATE}
    ${date}  Replace String  ${expect_date}  /  -
    ${result}  ${fail_list}  Uploader.billShouldExist  ${bill_list}  ${date}
    [Return]  ${result}  ${fail_list}

Delete used and expired RedeemhHistory
    [Arguments]  ${used_due_date}  ${expire_due_date}
    ${delete_list}  Uploader.removeRedeemHistory  ${used_due_date}  ${expire_due_date}
    LineCaller.Sent Alert To Line By ID  message=\[CODE\] finish delete Code Delete list:${delete_list}
    Pass Execution  finish delete Code Delete list:${delete_list}

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

Delete List Of Order
    [Arguments]    ${void_list}    ${order_date}=${FS_DATE}
    FOR  ${BILL}  IN  @{void_list}
        Uploader.deleteOrder  ${BILL}  ${order_date}
    END
    LineCaller.Sent Alert To Line By ID  message=\[Void\] Delete void list: ${void_list}

Check If Void Bill is exist
    [Arguments]    ${void_list}    ${order_date}=${FS_DATE}
    ${is_exist}  Uploader.isVoidBillExist  ${void_list}  ${order_date}
    [Return]  ${is_exist}